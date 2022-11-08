import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/cards/discussions_card.dart';
import 'package:livrodin/components/cards/reply_card.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_detail_controller.dart';
import 'package:livrodin/pages/book_detail_page.dart';

class TabViewDiscussions extends StatelessWidget {
  final BookDetailController bookDetailController =
      Get.find<BookDetailController>();
  final AuthController authController = Get.find<AuthController>();
  TabViewDiscussions({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final BookDetailController _bookDetailController =
      Get.find<BookDetailController>();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _bookDetailController.pageViewController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _page1(),
        _page2(),
      ],
    );
  }

  Widget _page1() {
    return Obx(
      () {
        if (_bookDetailController.bookDiscussionStatus.value ==
            BookDiscussionStatus.loaded) {
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
                          onPressed: () =>
                              authController.user.value!.isAnonymous
                                  ? Get.offAllNamed("/login")
                                  : _bookDetailController.addDiscussion(),
                          label: "Criar Discussão",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverVisibility(
                visible: _bookDetailController.book!.discussions.isNotEmpty,
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
                      _bookDetailController.book!.discussions.length,
                      (index) => DiscussionCard(
                        seeMore: true,
                        discussion:
                            _bookDetailController.book!.discussions[index],
                        margin: const EdgeInsets.only(bottom: 10),
                        onTap: () {
                          if (authController.user.value!.isAnonymous) {
                            Get.offAllNamed("/login");
                          }
                          _bookDetailController.selectedDiscussion.value =
                              _bookDetailController.book!.discussions[index];
                          _bookDetailController.fetchDiscussionReplies();
                          _bookDetailController.pageViewController
                              .jumpToPage(1);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (_bookDetailController.bookDiscussionStatus.value ==
            BookDiscussionStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ocorreu um erro ao carregar as discussões"),
                ButtonAction(
                  onPressed: _bookDetailController.reloadBookDiscussions,
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

  Widget _page2() {
    return Obx(
      () {
        if (_bookDetailController.bookDiscussionStatus.value ==
            BookDiscussionStatus.loaded) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          ButtonAction(
                            onPressed: () {
                              _bookDetailController.pageViewController
                                  .jumpToPage(0);
                            },
                            icon: Icons.arrow_back,
                            color: lightGrey,
                            textColor: red,
                            elevation: 0,
                            minHeight: 40,
                            minWidth: 40,
                          ),
                        ],
                      )),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      DiscussionCard(
                        discussion:
                            _bookDetailController.selectedDiscussion.value!,
                        margin: const EdgeInsets.only(bottom: 10),
                        seeMore: false,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Respostas",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      ButtonAction(
                        onPressed: _bookDetailController.addDiscussionReply,
                        icon: Icons.add,
                        minHeight: 30,
                        minWidth: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      _bookDetailController
                          .selectedDiscussion.value!.replies.length,
                      (index) => ReplyCard(
                        comment: _bookDetailController
                            .selectedDiscussion.value!.replies[index],
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (_bookDetailController.bookDiscussionStatus.value ==
            BookDiscussionStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ocorreu um erro ao carregar as discussões"),
                ButtonAction(
                  onPressed: _bookDetailController.fetchDiscussionReplies,
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
}
