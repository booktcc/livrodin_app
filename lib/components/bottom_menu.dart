import 'package:app_flutter/components/profile_icon.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Ink(
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
        Ink(
          width: double.infinity,
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
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
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
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            icon: const Icon(Icons.category),
                            onPressed: () {},
                            iconSize: 28,
                            color: grey,
                            padding: const EdgeInsets.all(0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            icon: const Icon(Icons.chat),
                            onPressed: () {},
                            iconSize: 28,
                            color: grey,
                            padding: const EdgeInsets.all(0),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        const ProfileIcon(
                          size: ProfileSize.sm,
                        )
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
          child: Ink(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(
                Radius.circular(90),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(235, 28, 36, 0.13),
                  offset: Offset(0.0, 10.0),
                  blurRadius: 15.0,
                ),
              ],
            ),
            // move a bit to top
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
        ),
      ],
    );
  }
}
