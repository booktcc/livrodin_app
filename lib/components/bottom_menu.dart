import 'package:app_flutter/components/profile_icon.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
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
        SizedBox(
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
                            onTap: () => widget.pageController.jumpToPage(0),
                            borderRadius: BorderRadius.circular(90),
                            child: const SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.home,
                                size: 28,
                                color: grey,
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
                            onTap: () => widget.pageController.jumpToPage(1),
                            borderRadius: BorderRadius.circular(90),
                            child: const SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.category,
                                size: 28,
                                color: grey,
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
                            onTap: () => widget.pageController.jumpToPage(2),
                            borderRadius: BorderRadius.circular(90),
                            child: const SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.notifications_rounded,
                                size: 28,
                                color: grey,
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
                            onTap: () {},
                            borderRadius: BorderRadius.circular(90),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: ProfileIcon(
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
        ),
        Positioned(
          top: -16,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(90),
            color: Colors.red,
            child: InkWell(
              onTap: () => Get.toNamed("/book_availability"),
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
