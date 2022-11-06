import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/profile_edit_controller.dart';

class EditProfileDialog extends StatelessWidget {
  EditProfileDialog({
    super.key,
    this.onConfirm,
    this.onCancel,
    required this.formKey,
    required this.title,
    required this.inputs,
  });

  final profileEditController = Get.find<ProfileEditController>();

  final GlobalKey<FormState> formKey;
  final void Function()? onConfirm;
  final void Function()? onCancel;
  final String title;
  final List<Widget> inputs;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
          decoration: const BoxDecoration(
            color: lightGrey,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    children: inputs,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonAction(
                          onPressed: () => onCancel?.call(),
                          label: "Cancelar",
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ButtonAction(
                          onPressed: () => onConfirm?.call(),
                          label: "Salvar",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
