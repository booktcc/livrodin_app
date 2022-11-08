import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/notification_controller.dart';

class BottomMenu extends StatefulWidget {
  BottomMenu({
    super.key,
    required this.pageController,
    int initialIndex = 0,
  }) : _selectefIndex = Rx(initialIndex);

  final PageController pageController;
  final Rx<int> _selectefIndex;
  final AuthController authController = Get.find<AuthController>();
  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  final AuthController authController = Get.find<AuthController>();

  final NotificationController _notificationController =
      Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        Obx(() {
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget._selectefIndex.value == 0
                                  ? null
                                  : () {
                                      widget.pageController.jumpToPage(0);
                                      widget._selectefIndex.value = 0;
                                    },
                              borderRadius: BorderRadius.circular(90),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.home,
                                  size: 28,
                                  color: widget._selectefIndex.value == 0
                                      ? Colors.black
                                      : grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget._selectefIndex.value == 1
                                  ? null
                                  : () {
                                      widget.pageController.jumpToPage(1);
                                      widget._selectefIndex.value = 1;
                                    },
                              borderRadius: BorderRadius.circular(90),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.category,
                                  size: 28,
                                  color: widget._selectefIndex.value == 1
                                      ? Colors.black
                                      : grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget._selectefIndex.value == 2
                                  ? null
                                  : () {
                                      widget.pageController.jumpToPage(2);
                                      widget._selectefIndex.value = 2;
                                    },
                              borderRadius: BorderRadius.circular(90),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Obx(
                                  () {
                                    var count = _notificationController
                                        .notifications.length;
                                    return Badge(
                                      showBadge: count > 0,
                                      badgeColor: red,
                                      badgeContent: Text(
                                        count < 10 ? "0$count" : "$count",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.notifications_rounded,
                                        size: 28,
                                        color: widget._selectefIndex.value == 2
                                            ? Colors.black
                                            : grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  authController.user.value!.isAnonymous
                                      ? Get.offAllNamed('/login')
                                      : Get.toNamed('/profile'),
                              borderRadius: BorderRadius.circular(90),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ProfileIcon(
                                  image: authController.user.value?.photoURL,
                                  size: ProfileSize.sm,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        Positioned(
          top: -16,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(90),
            color: Colors.red,
            child: InkWell(
              onTap: () => authController.user.value!.isAnonymous
                  ? Get.offAllNamed('/login')
                  : Get.toNamed("/book/availability"),
              borderRadius: BorderRadius.circular(90),
              child: const SizedBox(
                width: 70,
                height: 70,
                child: Icon(
                  Icons.menu_book,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
