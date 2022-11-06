import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import fetch from "node-fetch";

type BookAvailable = {
  idBook: string;
  availableType: BookAvailableType;
  createdAt: Date;
};

enum BookAvailableType {
  FOR_TRADE = "FOR_TRADE",
  FOR_DONATION = "FOR_DONATION",
  BOTH = "BOTH",
}

enum TransactionStatus {
  PENDING = "PENDING",
  IN_PROGRESS = "IN_PROGRESS",
  COMPLETED = "COMPLETED",
  CANCELED = "CANCELED",
}

enum TransactionType {
  TRADE = "TRADE",
  DONATION = "DONATION",
}

admin.initializeApp();

const baseBookApi = "https://www.googleapis.com/books/v1/volumes/";

const fetchBook = async (bookId: string) => {
  const response = await fetch(`${baseBookApi}${bookId}`);
  const data = (await response.json()) as any;
  return {
    coverUrl: data.volumeInfo.imageLinks.thumbnail as string,
    title: data.volumeInfo.title as string,
  };
};

const calculateAvailableType = (
  book: admin.firestore.DocumentData,
  newBookAvailable: BookAvailable
) => {
  if (book.availableType === BookAvailableType.BOTH)
    return BookAvailableType.BOTH;
  if (
    book.availableType === BookAvailableType.FOR_DONATION &&
    newBookAvailable.availableType === BookAvailableType.FOR_TRADE
  )
    return BookAvailableType.BOTH;
  if (
    book.availableType === BookAvailableType.FOR_TRADE &&
    newBookAvailable.availableType === BookAvailableType.FOR_DONATION
  )
    return BookAvailableType.BOTH;
  return newBookAvailable.availableType;
};

export const onBookAvailabilityCreated = functions
  .region("southamerica-east1")
  .firestore.document("BookAvailable/{bookAvailableId}")
  .onCreate(async (change) => {
    const db = admin.firestore();

    const availabityBook = change.data() as BookAvailable;

    const bookRef = db.collection("Book").doc(availabityBook.idBook);

    const book = await bookRef.get();

    if (!book.exists) {
      const bookData = await fetchBook(availabityBook.idBook);
      await bookRef.set({
        ...bookData,
        availableType: availabityBook.availableType,
        lastAvailabilityUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      const bookData = book.data();
      if (!bookData) return;
      // if book available type is different from the one in the book, update it

      await bookRef.update({
        availableType: calculateAvailableType(bookData, availabityBook),
        lastAvailabilityUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });

export const onBookAvailabilityDeleted = functions
  .region("southamerica-east1")
  .firestore.document("BookAvailable/{bookAvailableId}")
  .onDelete(async (change) => {
    const db = admin.firestore();

    const availabityBook = change.data() as BookAvailable;

    const bookRef = db.collection("Book").doc(availabityBook.idBook);

    const book = await bookRef.get();

    if (!book.exists) return;

    const bookData = book.data();

    if (!bookData) return;

    const availabilityBooks = await db
      .collection("BookAvailable")
      .where("idBook", "==", availabityBook.idBook)
      .orderBy("createdAt", "desc")
      .get();

    const forTrade = availabilityBooks.docs.some(
      (doc) => doc.data().availableType === BookAvailableType.FOR_TRADE
    );

    const forDonation = availabilityBooks.docs.some(
      (doc) => doc.data().availableType === BookAvailableType.FOR_DONATION
    );

    const newAvailableType = forTrade
      ? forDonation
        ? BookAvailableType.BOTH
        : BookAvailableType.FOR_TRADE
      : forDonation
      ? BookAvailableType.FOR_DONATION
      : null;

    await bookRef.update({
      availableType: newAvailableType,
      lastAvailabilityUpdated:
        newAvailableType === null
          ? null
          : admin.firestore.FieldValue.serverTimestamp(),
    });
  });

export const createTransaction = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const user2Id = context.auth?.uid;

    if (!user2Id) return { error: "User not authenticated" };

    const { availabilityId, type } = data as {
      availabilityId: string;
      type: TransactionType;
    };

    const bookAvailable = await db
      .collection("BookAvailable")
      .doc(availabilityId)
      .get();

    // check if user has a transaction in progress
    const userTransactions = await db
      .collection("Transaction")
      .where("user2Id", "==", user2Id)
      .where("status", "in", [
        TransactionStatus.IN_PROGRESS,
        TransactionStatus.PENDING,
        TransactionStatus.COMPLETED,
      ])
      .get();

    if (userTransactions.docs.length > 0)
      return { error: "User already has a transaction in progress" };

    if (bookAvailable.data()?.userId === user2Id) {
      return { error: "You can't trade with yourself" };
    }
    if (!bookAvailable.exists) return { error: "Book not available" };

    const bookAvailableData = bookAvailable.data();

    if (!bookAvailableData) return { error: "Book not found" };

    if (
      (type === TransactionType.TRADE && !bookAvailableData?.forTrade) ||
      (type === TransactionType.DONATION && !bookAvailableData?.forDonation)
    ) {
      return { error: "Book not available for this type of transaction" };
    }

    const transaction = await db.collection("Transaction").add({
      availabilityId,
      user1Id: bookAvailableData.idUser,
      user2Id,
      status: TransactionStatus.PENDING,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      type,
    });

    return transaction.id;
  });

export const confirmTransaction = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const user1Id = context.auth?.uid;

    if (!user1Id) return { error: "User not authenticated" };

    const { transactionId, availability2Id } = data as {
      transactionId: string;
      availability2Id?: string;
    };

    const transaction = await db
      .collection("Transaction")
      .doc(transactionId)
      .get();

    if (!transaction.exists) return { error: "Transaction not found" };

    const transactionData = transaction.data();

    if (!transactionData) return { error: "Transaction not found" };

    if (transactionData.status !== TransactionStatus.PENDING)
      return { error: "Transaction not pending" };

    if (transactionData.user1Id !== user1Id)
      return { error: "User not authorized" };

    if (transactionData.type === TransactionType.TRADE && !availability2Id)
      return { error: "User2 availability id is required" };

    await transaction.ref.update({
      status: TransactionStatus.IN_PROGRESS,
      availability2Id: availability2Id || null,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return transaction.id;
  });

export const completeTransaction = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const user1Id = context.auth?.uid;

    if (!user1Id) return { error: "User not authenticated" };

    const { transactionId } = data as { transactionId: string };

    const transaction = await db
      .collection("Transaction")
      .doc(transactionId)
      .get();

    if (!transaction.exists) return { error: "Transaction not found" };

    const transactionData = transaction.data();

    if (!transactionData) return { error: "Transaction not found" };

    if (transactionData.status !== TransactionStatus.IN_PROGRESS)
      return { error: "Transaction not in progress" };

    if (transactionData.user1Id !== user1Id)
      return { error: "User not authorized" };

    await transaction.ref.update({
      status: TransactionStatus.COMPLETED,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await db
      .collection("BookAvailable")
      .doc(transactionData.bookAvailableId)
      .delete();

    return transaction.id;
  });

export const cancelTransaction = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const user1Id = context.auth?.uid;

    if (!user1Id) return { error: "User not authenticated" };

    const { transactionId } = data as { transactionId: string };

    const transaction = await db
      .collection("Transaction")
      .doc(transactionId)
      .get();

    if (!transaction.exists) return { error: "Transaction not found" };

    const transactionData = transaction.data();

    if (!transactionData) return { error: "Transaction not found" };

    if (transactionData.status === TransactionStatus.COMPLETED)
      return { error: "Transaction already completed" };

    if (transactionData.user1Id !== user1Id)
      return { error: "User not authorized" };

    await transaction.ref.update({
      status: TransactionStatus.CANCELED,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return transaction.id;
  });
