import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/confirm_dialog.dart';
import 'package:livrodin/components/dialogs/book_list_available.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/components/rating_info.dart';
import 'package:livrodin/components/tabs/book_detail/details.dart';
import 'package:livrodin/components/tabs/book_detail/discussions.dart';
import 'package:livrodin/components/tabs/book_detail/ratings.dart';
import 'package:livrodin/components/tabs/book_detail/synopsis.dart';
import 'package:livrodin/configs/livrodin_icons.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/controllers/book_detail_controller.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/utils/state_machine.dart';

enum BookStatus { init, loading, loaded, error }

enum BookRatingStatus { init, loading, loaded, error }

enum BookDiscussionStatus { init, loading, loaded, error }

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final BookController _bookController = Get.find<BookController>();
  final BookDetailController _bookDetailController =
      Get.find<BookDetailController>();

  @override
  void initState() {
    String? bookId = Get.parameters['idBook'];
    _bookDetailController.bookStatus.value = BookStatus.loading;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (bookId == null) {
        Get.toNamed("/home");
      }
      _bookDetailController.fetchBook(bookId!);
    });

    super.initState();
  }

  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: true,
        showBackButton: true,
      ),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          final double minSize =
              (boxConstraints.maxHeight - 240) / boxConstraints.maxHeight;

          return Stack(
            children: [
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Obx(() {
                      if (_bookDetailController.bookStatus.value ==
                          BookStatus.loading) {
                        return const CircularProgressIndicator();
                      } else if (_bookDetailController.bookStatus.value ==
                          BookStatus.error) {
                        return const SizedBox.shrink();
                      } else {
                        return LayoutBuilder(builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              _bookDetailController.book!.coverUrl!,
                              fit: BoxFit.cover,
                              height: constraints.maxHeight,
                              width: (constraints.maxHeight * 240) / 360,
                            ),
                          );
                        });
                      }
                    }),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: minSize,
                maxChildSize: 1,
                minChildSize: minSize,
                builder: (context, scrollController) => ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(pageRadius),
                  ),
                  child: Container(
                    color: lightGrey,
                    child: Obx(
                      () {
                        if (_bookDetailController.bookStatus.value ==
                            BookStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (_bookDetailController.bookStatus.value ==
                            BookStatus.error) {
                          return const Center(
                            child: Text("Erro ao carregar o livro"),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _bookDetailController.book!.title!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      _bookDetailController.book!.authorsString
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    RatingInfo(
                                      rating: _bookDetailController
                                          .book!.averageRating,
                                      isLoading: _bookDetailController
                                                  .bookRatingStatus.value ==
                                              BookDiscussionStatus.loading
                                          ? true
                                          : false,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                child: DefaultTabController(
                                  length: 4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TabBar(
                                        enableFeedback: true,
                                        labelColor: dark,
                                        physics: const BouncingScrollPhysics(),
                                        labelStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                        unselectedLabelStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        isScrollable: true,
                                        tabs: [
                                          const Tab(text: "Sinopse"),
                                          const Tab(text: "Detalhes"),
                                          Tab(
                                              text:
                                                  "Avaliações (${_bookDetailController.book!.ratings.length})"),
                                          const Tab(text: "Discussões"),
                                        ],
                                      ),
                                      Flexible(
                                        child: TabBarView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          children: [
                                            TabViewSynopsis(
                                              scrollController:
                                                  scrollController,
                                            ),
                                            TabViewDetails(
                                              scrollController:
                                                  scrollController,
                                            ),
                                            TabViewRatings(
                                              scrollController:
                                                  scrollController,
                                            ),
                                            TabViewDiscussions(
                                              scrollController:
                                                  scrollController,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          if (_bookDetailController
                                  .userInterestFetchState.value ==
                              FetchState.loading) {
                            return const SizedBox.shrink();
                          } else if (_bookDetailController
                                  .userInterestFetchState.value ==
                              FetchState.error) {
                            return const SizedBox.shrink();
                          } else {
                            return ButtonAction(
                              onPressed: () => authController
                                      .user.value!.isAnonymous
                                  ? Get.offAllNamed("/login")
                                  : _bookDetailController
                                          .isUserBookInterest.value
                                      ? _bookDetailController.removeInterest()
                                      : _bookDetailController.addInterest(),
                              color: Colors.white,
                              icon:
                                  _bookDetailController.isUserBookInterest.value
                                      ? Icons.bookmark_remove
                                      : Icons.bookmark_add,
                              iconSize: 24,
                              radius: 360,
                              minHeight: 40,
                              minWidth: 40,
                              textColor: grey,
                            );
                          }
                        }),
                        Obx(
                          () {
                            var availabilityForTrade =
                                _bookDetailController.bookAvailabilityList
                                    .where(
                                      (element) =>
                                          element.availableType ==
                                              BookAvailableType.trade ||
                                          element.availableType ==
                                              BookAvailableType.both,
                                    )
                                    .toList();
                            var availabilityForDonate =
                                _bookDetailController.bookAvailabilityList
                                    .where(
                                      (element) =>
                                          element.availableType ==
                                              BookAvailableType.donate ||
                                          element.availableType ==
                                              BookAvailableType.both,
                                    )
                                    .toList();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: availabilityForDonate.isNotEmpty,
                                  child: ButtonAction(
                                    onPressed: () => authController
                                            .user.value!.isAnonymous
                                        ? Get.offAllNamed("/login")
                                        : Get.dialog<String>(BookListAvailable(
                                            title: "Selecione para pedir",
                                            availabilityList:
                                                availabilityForDonate,
                                          )).then((availabilityId) {
                                            if (availabilityId != null) {
                                              Get.dialog<bool>(ConfirmDialog(
                                                title: "Pedir",
                                                content:
                                                    "Deseja pedir o livro?",
                                                onConfirm: () {
                                                  Get.back(result: true);
                                                },
                                              )).then((value) async {
                                                if (!value!) return;
                                                _bookController.requestBook(
                                                  availabilityId,
                                                  TransactionType.donate,
                                                );
                                              });
                                            }
                                          }),
                                    label: "PEDIR",
                                    icon: LivrodinIcons.donateIcon,
                                  ),
                                ),
                                Visibility(
                                  visible: availabilityForDonate.isNotEmpty,
                                  child: const SizedBox(width: 30),
                                ),
                                Visibility(
                                  visible: availabilityForTrade.isNotEmpty,
                                  child: ButtonAction(
                                    onPressed: () => authController
                                            .user.value!.isAnonymous
                                        ? Get.offAllNamed("/login")
                                        : Get.dialog<String>(BookListAvailable(
                                            title: "Selecione para trocar",
                                            availabilityList:
                                                availabilityForTrade,
                                          )).then((availabilityId) {
                                            if (availabilityId != null) {
                                              Get.dialog<bool>(ConfirmDialog(
                                                title: "Trocar",
                                                content:
                                                    "Deseja trocar o livro?",
                                                onConfirm: () {
                                                  Get.back(result: true);
                                                },
                                              )).then((value) async {
                                                if (!value!) return;
                                                _bookController.requestBook(
                                                  availabilityId,
                                                  TransactionType.trade,
                                                );
                                              });
                                            }
                                          }),
                                    label: "TROCAR",
                                    icon: Icons.swap_horizontal_circle,
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
