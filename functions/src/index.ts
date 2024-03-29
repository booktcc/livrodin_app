import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import fetch from "node-fetch";

type BookAvailable = {
  idBook: string;
  idUser: string;
  availableType: BookAvailableType;
  createdAt: Date;
};

type Notification = {
  type: NotificationType;
  transactionId: string;
  createdAt: admin.firestore.FieldValue;
  userId: string;
  message: string;
};

type Message = {
  systemMessage?: SystemMessage;
  userId: string;
  createdAt: admin.firestore.FieldValue;
  message?: string;
};

enum SystemMessage {
  CONFIRMED = "CONFIRMED",
  CANCELED = "CANCELED",
  FINISHED = "FINISHED",
}

enum NotificationType {
  MESSAGE = "MESSAGE",
  TRANSACTION = "TRANSACTION",
}

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
  TRADE = "FOR_TRADE",
  DONATION = "FOR_DONATION",
}

admin.initializeApp();

admin.firestore().settings({ ignoreUndefinedProperties: true });

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

    if (!user2Id) return { message: "Usuário não autenticado", error: true };

    const { availabilityId, type } = data as {
      availabilityId: string;
      type: TransactionType;
    };

    const bookAvailable = await db
      .collection("BookAvailable")
      .doc(availabilityId)
      .get();

    const userTransactions = await db
      .collection("Transaction")
      .where("user2Id", "==", user2Id)
      .where("availabilityId", "==", availabilityId)
      .where("status", "in", [
        TransactionStatus.IN_PROGRESS,
        TransactionStatus.PENDING,
      ])
      .get();

    if (userTransactions.docs.length > 0)
      return {
        message: "Usuário já possui uma transação em andamento",
        error: true,
      };

    if (bookAvailable.data()?.userId === user2Id) {
      return {
        message: "Usuário não pode solicitar um livro dele mesmo",
        error: true,
      };
    }
    if (!bookAvailable.exists)
      return { message: "Livro não encontrado", error: true };

    const bookAvailableData = bookAvailable.data() as BookAvailable;

    if (!bookAvailableData)
      return { message: "Livro não encontrado", error: true };

    if (type === TransactionType.TRADE) {
      const userBooksAvailable = await db
        .collection("BookAvailable")
        .where("idUser", "==", user2Id)
        .get();

      if (userBooksAvailable.docs.length === 0) {
        return {
          message: "Você não possui livros disponíveis para troca",
          error: true,
        };
      }
    }

    if (
      bookAvailableData?.availableType === BookAvailableType.FOR_TRADE &&
      type !== TransactionType.TRADE
    ) {
      return {
        message: "O Livro está disponível apenas para troca",
        error: true,
      };
    }
    if (
      bookAvailableData?.availableType === BookAvailableType.FOR_DONATION &&
      type !== TransactionType.DONATION
    ) {
      return {
        message: "O Livro está disponível apenas para doação",
        error: true,
      };
    }

    const transaction = await db.collection("Transaction").add({
      availabilityId,
      user1Id: bookAvailableData.idUser,
      idBook1: bookAvailableData.idBook,
      user2Id,
      status: TransactionStatus.PENDING,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      type,
    });

    return {
      error: false,
      message: "Transação criada com sucesso",
      transactionId: transaction.id,
    };
  });

export const confirmTransaction = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const user1Id = context.auth?.uid;

    if (!user1Id) return { message: "Usuário não autenticado", error: true };

    const { transactionId, availability2Id } = data as {
      transactionId: string;
      availability2Id?: string;
    };

    const transaction = await db
      .collection("Transaction")
      .doc(transactionId)
      .get();

    if (!transaction.exists)
      return { message: "Transação não encontrada", error: true };

    const transactionData = transaction.data();

    if (!transactionData)
      return { error: true, message: "Transação não encontrada" };

    if (transactionData.status !== TransactionStatus.PENDING)
      return { message: "Transação não está pendente", error: true };

    if (transactionData.user1Id !== user1Id)
      return { message: "Usuário não é o dono da transação", error: true };

    if (transactionData.type === TransactionType.TRADE && !availability2Id)
      return { message: "Livro para troca não informado", error: true };

    await transaction.ref.update({
      status: TransactionStatus.IN_PROGRESS,
      availability2Id: availability2Id || null,
      idBook2: availability2Id
        ? await db
            .collection("BookAvailable")
            .doc(availability2Id)
            .get()
            .then((doc) => doc.data()?.idBook)
        : null,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { error: false, message: "Transação confirmada com sucesso" };
  });

export const completeTransaction = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const userId = context.auth?.uid;

    if (!userId) return { error: true, message: "Usuário não autenticado" };

    const { transactionId } = data as { transactionId: string };

    const transaction = await db
      .collection("Transaction")
      .doc(transactionId)
      .get();

    if (!transaction.exists)
      return { error: true, message: "Transação não encontrada" };

    const transactionData = transaction.data();

    if (!transactionData)
      return { error: true, message: "Transação não encontrada" };

    if (transactionData.status !== TransactionStatus.IN_PROGRESS)
      return { error: true, message: "Transação não está em andamento" };

    if (
      transactionData.user1Id !== userId &&
      transactionData.user2Id !== userId
    ) {
      return { error: true, message: "Você não faz parte da transação" };
    }
    // check if user has confirmed

    if (
      (transactionData.user1Id === userId && transactionData.user1Confirm) ||
      (transactionData.user2Id === userId && transactionData.user2Confirm)
    ) {
      return {
        error: true,
        message: "Você já confirmou a transação. Aguarde o outro usuário.",
      };
    }

    const user1Confirm =
      transactionData.user1Id === userId || transactionData.user1Confirm;

    const user2Confirm =
      transactionData.user2Id === userId || transactionData.user2Confirm;

    const usersConfirmed = Boolean(user1Confirm && user2Confirm);

    await transaction.ref.update({
      status: usersConfirmed ? TransactionStatus.COMPLETED : undefined,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      user1Confirm,
      user2Confirm,
    });

    if (usersConfirmed) {
      db.collection("BookAvailable")
        .doc(transactionData.availabilityId)
        .delete();
      if (transactionData.availability2Id) {
        db.collection("BookAvailable")
          .doc(transactionData.availability2Id)
          .delete();
      }

      transaction.ref.collection("Messages").add({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        systemMessage: SystemMessage.FINISHED,
        userId: userId,
      } as Message);

      return { error: false, message: "Transação concluída com sucesso" };
    }

    transaction.ref.collection("Messages").add({
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      systemMessage: SystemMessage.CONFIRMED,
      userId: userId,
    } as Message);

    return { error: false, message: "Você confirmou a transação" };
  });

export const cancelTransaction = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const userId = context.auth?.uid;

    if (!userId) return { error: true, message: "Usuário não autenticado" };

    const { transactionId } = data as { transactionId: string };

    const transaction = await db
      .collection("Transaction")
      .doc(transactionId)
      .get();

    if (!transaction.exists)
      return { error: true, message: "Transação não encontrada" };

    const transactionData = transaction.data();

    if (!transactionData)
      return { error: true, message: "Transação não encontrada" };

    if (transactionData.status === TransactionStatus.COMPLETED)
      return { error: true, message: "Transação já foi concluída" };

    if (transactionData.status === TransactionStatus.PENDING) {
      await transaction.ref.delete();
    } else {
      await transaction.ref.update({
        status: TransactionStatus.CANCELED,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      transaction.ref.collection("Messages").add({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        systemMessage: SystemMessage.CANCELED,
        userId: userId,
      } as Message);
    }

    return { error: false, message: "Transação cancelada com sucesso" };
  });

export const sendTransactionMessage = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    const db = admin.firestore();

    const userId = context.auth?.uid;

    if (!userId) return { error: true, message: "Usuário não autenticado" };

    const { transactionId, message } = data as {
      transactionId: string;
      message: string;
    };

    const transaction = await db
      .collection("Transaction")
      .doc(transactionId)
      .get();

    if (!transaction.exists)
      return { error: true, message: "Transação não encontrada" };

    const transactionData = transaction.data();

    if (!transactionData)
      return { error: true, message: "Transação não encontrada" };

    if (transactionData.status !== TransactionStatus.IN_PROGRESS)
      return { error: true, message: "Transação não está em andamento" };

    if (
      transactionData.user1Id !== userId &&
      transactionData.user2Id !== userId
    )
      return { error: true, message: "Usuário não é parte da transação" };

    await transaction.ref.collection("Messages").add({
      text: message,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      userId,
    });

    // send notification to other user
    const otherUserId =
      transactionData.user1Id === userId
        ? transactionData.user2Id
        : transactionData.user1Id;

    db.collection("Users")
      .doc(otherUserId)
      .collection("Notification")
      .doc(`${NotificationType.MESSAGE}-${transactionId}`)
      .set({
        type: NotificationType.MESSAGE,
        transactionId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        userId,
        message,
      } as Notification);

    return { error: false, message: "Mensagem enviada com sucesso" };
  });

export const onUserAuthWithGoogleCreated = functions
  .region("southamerica-east1")
  .auth.user()
  .onCreate(async (user) => {
    const db = admin.firestore();

    const { email, displayName, photoURL, providerData } = user;

    // check if user has logged with google
    const hasGoogleProvider = providerData.some(
      (provider) => provider.providerId === "google.com"
    );

    if (!hasGoogleProvider) return;

    const userDoc = await db.collection("Users").doc(user.uid).get();

    if (userDoc.exists) return;

    await db.collection("Users").doc(user.uid).set({
      email,
      name: displayName,
      profilePictureUrl: photoURL,
    });
  });
