import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/reply.dart';
import 'package:livrodin/models/user.dart';

class ReplyDialog extends StatefulWidget {
  final String title;
  final void Function({
    required Reply reply,
  })? onConfirm;
  final Discussion discussion;
  const ReplyDialog(
      {super.key,
      required this.title,
      this.onConfirm,
      required this.discussion});

  @override
  State<ReplyDialog> createState() => _ReplyDialogState();
}

class _ReplyDialogState extends State<ReplyDialog> {
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
            hintText: "Responda a discussão",
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
              final Reply reply = Reply(
                discussion: widget.discussion,
                text: _commentController.text,
                user: User(
                  id: authController.user.value!.uid,
                  name: authController.user.value?.displayName ?? "",
                  isMe: true,
                  profilePictureUrl: authController.user.value!.photoURL,
                ),
              );
              widget.onConfirm?.call(reply: reply);
              Get.back();
            }
          },
          label: "Criar",
        ),
      ],
    );
  }
}
