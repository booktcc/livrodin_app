import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/cards/discussions_card.dart';
import 'package:livrodin/components/dialogs/discussion_dialog.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/pages/book_detail_page.dart';

class TabViewDiscussions extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final BookController _bookController = Get.find<BookController>();

  TabViewDiscussions({
    super.key,
    required this.scrollController,
    required this.bookDiscussionsStatus,
    required this.book,
  });

  final Rx<BookDiscussionStatus> bookDiscussionsStatus;
  final Book book;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (bookDiscussionsStatus.value == BookDiscussionStatus.loaded) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Deseja interagir com outros usuários? Crie uma discussão! Ou participe das discussões já criadas.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonAction(
                          onPressed: () => Get.dialog(
                            DiscussionDialog(
                              title: "Criar Discussão",
                              onConfirm: ({
                                required Discussion discussion,
                              }) =>
                                  _bookController
                                      .createDiscussion(
                                book: book,
                                discussion: discussion,
                              )
                                      .whenComplete(() async {
                                _reloadBookDiscussions();
                              }),
                            ),
                          ),
                          label: "Criar Discussão",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverVisibility(
                visible: book.discussions.isNotEmpty,
                sliver: const SliverPadding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Discussões Criadas",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      book.discussions.length,
                      (index) => DiscussionCard(
                        discussion: book.discussions[index],
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (bookDiscussionsStatus.value == BookDiscussionStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ocorreu um erro ao carregar as discussões"),
                ButtonAction(
                  onPressed: _reloadBookDiscussions,
                  label: "Tentar novamente",
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future _reloadBookDiscussions() async {
    bookDiscussionsStatus.value = BookDiscussionStatus.loading;
    try {
      await _bookController.fetchBookDiscussions(book);
      bookDiscussionsStatus.value = BookDiscussionStatus.loaded;
    } catch (e) {
      bookDiscussionsStatus.value = BookDiscussionStatus.error;
    }
  }
}
