import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import fetch from "node-fetch";

type BookAvailable = {
  idBook: string;
  forTrade: boolean;
  forDonation: boolean;
  createdAt: Date;
};

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
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      const bookData = book.data();
      if (!bookData) return;

      await bookRef.update({
        forTrade: Boolean(availabityBook.forTrade || bookData.forTrade),
        forDonation: Boolean(
          availabityBook.forDonation || bookData.forDonation
        ),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });
