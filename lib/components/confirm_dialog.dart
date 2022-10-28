import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? onConfirm;
  const ConfirmDialog(
      {super.key, required this.title, required this.content, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Não', style: TextStyle(color: azure)),
        ),
        TextButton(
          onPressed: onConfirm?.call,
          child: const Text('Sim', style: TextStyle(color: azure)),
        ),
      ],
    );
  }
}
