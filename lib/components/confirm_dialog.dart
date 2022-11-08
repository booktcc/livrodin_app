import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/configs/themes.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? onConfirm;
  const ConfirmDialog(
      {super.key, required this.title, required this.content, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: lightGrey,
      title: Text(title),
      content: Text(content),
      actions: [
        ButtonAction(onPressed: () => Get.back(result: false), label: 'Não'),
        ButtonAction(
            onPressed: () async {
              onConfirm?.call();
            },
            label: 'Sim'),
      ],
    );
  }
}
