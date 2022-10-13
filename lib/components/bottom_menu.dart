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
    return Container(
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
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                          InkWell(
                            onTap: () {},
                            child: const ProfileIcon(
                              size: ProfileSize.sm,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -16, 0),
            decoration: const BoxDecoration(
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
            child: CircleAvatar(
              radius: 33,
              child: IconButton(
                enableFeedback: true,
                onPressed: () {},
                icon: const Icon(Icons.menu_book),
                iconSize: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
