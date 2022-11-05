import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import fetch from "node-fetch";

type BookAvailable = {
  idBook: string;
  forTrade: boolean;
  forDonation: boolean;
  createdAt: Date;
};

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

// type Transaction = {
//   bookAvailableId: string;
//   user1Id: string;
//   user2Id: string;
//   user1BookId: string;
//   user2BookId?: string;
//   status: TransactionStatus;
//   createdAt: Date;
//   updatedAt: Date;
//   type: TransactionType;
// };

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

export const onBookAvailabilityCreated = functions.firestore
  .document("BookAvailable/{bookAvailableId}")
  .onCreate(async (change) => {
    const db = admin.firestore();

    const availabityBook = change.data() as BookAvailable;

    const bookRef = db.collection("Book").doc(availabityBook.idBook);

    const book = await bookRef.get();

    if (!book.exists) {
      const bookData = await fetchBook(availabityBook.idBook);
      await bookRef.set({
        ...bookData,
        forTrade: Boolean(availabityBook.forTrade),
        forDonation: Boolean(availabityBook.forDonation),
        lastAvailabilityUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      const bookData = book.data();
      if (!bookData) return;

      await bookRef.update({
        forTrade: Boolean(availabityBook.forTrade || bookData.forTrade),
        forDonation: Boolean(
          availabityBook.forDonation || bookData.forDonation
        ),
        lastAvailabilityUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });

export const onBookAvailabilityDeleted = functions.firestore
  .document("BookAvailable/{bookAvailableId}")
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
      (doc) => doc.data().forTrade === true
    );

    const forDonation = availabilityBooks.docs.some(
      (doc) => doc.data().forDonation === true
    );

    await bookRef.update({
      forTrade,
      forDonation,
      lastAvailabilityUpdated: !availabilityBooks.empty
        ? availabilityBooks.docs[0].data().createdAt
        : null,
    });
  });

export const createTransaction = functions.https.onCall(
  async (data, context) => {
    const db = admin.firestore();

    const user2Id = context.auth?.uid;

    if (!user2Id) return { error: "User not authenticated" };

    const { bookAvailableId, type } = data as {
      bookAvailableId: string;
      type: TransactionType;
    };

    const bookAvailable = await db
      .collection("BookAvailable")
      .doc(bookAvailableId)
      .get();

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
      bookAvailableId,
      user1Id: bookAvailableData.idUser,
      user2Id,
      user1BookId: bookAvailableData.idBook,
      status: TransactionStatus.PENDING,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      type,
    });

    return transaction.id;
  }
);

export const confirmTransaction = functions.https.onCall(
  async (data, context) => {
    const db = admin.firestore();

    const user1Id = context.auth?.uid;

    if (!user1Id) return { error: "User not authenticated" };

    const { transactionId, user2BookId } = data as {
      transactionId: string;
      user2BookId?: string;
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

    if (transactionData.type === TransactionType.TRADE && !user2BookId)
      return { error: "User2 book id is required" };

    await transaction.ref.update({
      status: TransactionStatus.IN_PROGRESS,
      user2BookId: user2BookId || null,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return transaction.id;
  }
);
