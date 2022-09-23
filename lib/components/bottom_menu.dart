import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    String currentRoute = Get.currentRoute;

    print(currentRoute);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 80,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
        ),
        Container(
          width: double.infinity,
          transform: Matrix4.translationValues(0, -2, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.home,
                            color: grey,
                          ),
                          onPressed: () {},
                          iconSize: 28,
                          padding: const EdgeInsets.all(0),
                          isSelected: true,
                          selectedIcon:
                              const Icon(Icons.home, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.category),
                          onPressed: () {},
                          iconSize: 28,
                          color: grey,
                          padding: const EdgeInsets.all(0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chat),
                          onPressed: () {},
                          iconSize: 28,
                          color: grey,
                          padding: const EdgeInsets.all(0),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () {},
                          iconSize: 28,
                          color: grey,
                          padding: const EdgeInsets.all(0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 66,
          height: 66,
          decoration: const BoxDecoration(
            color: red,
            borderRadius: BorderRadius.all(
              Radius.circular(90),
            ),
          ),
          // move a bit to top
          transform: Matrix4.translationValues(0, -16, 0),
          child: Center(
            child: IconButton(
              iconSize: 28,
              onPressed: () {},
              icon: const Icon(
                Icons.menu_book,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(6),
            ),
          ),
        ),
      ],
    );
  }
}
