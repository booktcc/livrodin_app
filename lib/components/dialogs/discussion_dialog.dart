import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/user.dart';

class DiscussionDialog extends StatefulWidget {
  final String title;
  final void Function({
    required Discussion discussion,
  })? onConfirm;
  const DiscussionDialog({super.key, required this.title, this.onConfirm});

  @override
  State<DiscussionDialog> createState() => _DiscussionDialogState();
}

class _DiscussionDialogState extends State<DiscussionDialog> {
  int rate = 3;
  final TextEditingController _commentController =
      TextEditingController(text: "");

  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: lightGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(widget.title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Input(
            controller: _commentController,
            hintText: "Titulo da discussão",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            },
          ),
        ),
      ),
      actions: [
        ButtonAction(
          onPressed: () => Get.back(),
          label: "Deixar para depois",
          color: lightGrey,
          textColor: azure,
        ),
        ButtonAction(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final Discussion discussion = Discussion(
                id: "",
                title: _commentController.text,
                user: User(
                  id: authController.user.value!.uid,
                  name: authController.user.value?.displayName ?? "",
                  isMe: true,
                  profilePictureUrl: authController.user.value!.photoURL,
                ),
              );
              widget.onConfirm?.call(discussion: discussion);
              Get.back();
            }
          },
          label: "Criar",
        ),
      ],
    );
  }
}
