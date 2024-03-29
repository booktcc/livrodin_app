import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/dialogs/discussion_dialog.dart';
import 'package:livrodin/components/dialogs/rate_dialog.dart';
import 'package:livrodin/components/dialogs/reply_dialog.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/reply.dart';
import 'package:livrodin/pages/book_detail_page.dart';
import 'package:livrodin/utils/state_machine.dart';

class BookDetailController extends GetxController {
  final PageController pageViewController = PageController();
  final Rx<Discussion?> selectedDiscussion = Rx(null);

  Book? book;
  final Rx<BookStatus> bookStatus = BookStatus.init.obs;
  final Rx<BookRatingStatus> bookRatingStatus = BookRatingStatus.init.obs;
  final Rx<BookDiscussionStatus> bookDiscussionStatus =
      BookDiscussionStatus.init.obs;
  final RxList<Availability> bookAvailabilityList = <Availability>[].obs;
  final Rx<FetchState> userInterestFetchState = FetchState.loading.obs;
  final Rx<bool> isUserBookInterest = false.obs;

  final BookController _bookController = Get.find<BookController>();
  final AuthController _authController = Get.find<AuthController>();

  Future fetchBook(String bookId) async {
    bookStatus.value = BookStatus.loading;
    try {
      book = await _bookController.getBookOnGoogleApi(bookId);
      bookStatus.value = BookStatus.loaded;
      reloadBookDiscussions();
      reloadBookRating();
      reloadAvailableList();
      reloadUserInterest();
    } catch (e) {
      bookStatus.value = BookStatus.error;
    }
  }

  Future reloadUserInterest() async {
    if (book == null) {
      return;
    }
    userInterestFetchState.value = FetchState.loading;
    try {
      if (!_authController.user.value!.isAnonymous) {
        isUserBookInterest.value =
            await _bookController.isUserBookInterest(book!.id);
      }
      userInterestFetchState.value = FetchState.success;
    } catch (e) {
      userInterestFetchState.value = FetchState.error;
    }
  }

  Future<void> addInterest() async {
    userInterestFetchState.value = FetchState.loading;
    try {
      await _bookController.addBookInterest(book!);
      userInterestFetchState.value = FetchState.success;
      isUserBookInterest.value = true;
    } catch (e) {
      userInterestFetchState.value = FetchState.error;
    }
  }

  Future reloadBookDiscussions() async {
    bookDiscussionStatus.value = BookDiscussionStatus.loading;
    try {
      await _bookController.fetchBookDiscussions(book!);
      bookDiscussionStatus.value = BookDiscussionStatus.loaded;
    } catch (e) {
      bookDiscussionStatus.value = BookDiscussionStatus.error;
    }
  }

  Future reloadBookRating() async {
    bookRatingStatus.value = BookRatingStatus.loading;
    try {
      await _bookController.fetchBookRating(book!);
      bookRatingStatus.value = BookRatingStatus.loaded;
    } catch (e) {
      bookRatingStatus.value = BookRatingStatus.error;
    }
  }

  Future reloadAvailableList() async {
    try {
      bookAvailabilityList.value =
          await _bookController.getBookAvailabityById(book!.id);
    } catch (e) {
      bookAvailabilityList.value = <Availability>[];
    }
  }

  Future<void> removeInterest() async {
    try {
      await _bookController.removeBookInterest(book!.id);
      isUserBookInterest.value = false;
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future addDiscussion() async {
    try {
      await Get.dialog(
        DiscussionDialog(
            book: book!,
            title: "Criar Discussão",
            onConfirm: ({
              required Discussion discussion,
            }) async {
              await _bookController.createDiscussion(
                  book: book!, discussion: discussion);
              reloadBookDiscussions();
            }),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future addDiscussionReply() async {
    try {
      await Get.dialog(
        ReplyDialog(
            discussion: selectedDiscussion.value!,
            title: "Responder Discussão",
            onConfirm: ({
              required Reply reply,
            }) async {
              await _bookController.createDiscussionReply(
                  book: book!,
                  reply: reply,
                  parentDiscussion: selectedDiscussion.value!);
              fetchDiscussionReplies();
            }),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future addRate() async {
    try {
      await Get.dialog(
        RateDialog(
          title: 'Avalie o livro',
          onConfirm: ({
            required rate,
            required comment,
          }) async {
            _bookController.rateBook(book: book!, rate: rate, comment: comment);
            reloadBookRating();
          },
        ),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future fetchDiscussionReplies() async {
    try {
      bookDiscussionStatus.value = BookDiscussionStatus.loading;
      await _bookController
          .fetchBookDiscussionsReplis(selectedDiscussion.value!);
      bookDiscussionStatus.value = BookDiscussionStatus.loaded;
    } catch (e) {
      bookDiscussionStatus.value = BookDiscussionStatus.error;
    }
  }
}
