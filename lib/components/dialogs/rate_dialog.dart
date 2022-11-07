import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/configs/themes.dart';

class RateDialog extends StatefulWidget {
  final String title;
  final void Function({
    required int rate,
    required String comment,
  })? onConfirm;
  const RateDialog({
    super.key,
    required this.title,
    this.onConfirm,
  });

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  int rate = 3;
  final TextEditingController _commentController =
      TextEditingController(text: "");
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RatingBar.builder(
              minRating: 1,
              maxRating: 5,
              initialRating: 3,
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                );
              },
              onRatingUpdate: (rating) {
                rate = rating.toInt();
              },
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Input(
                controller: _commentController,
                hintText: "Comentário",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Campo obrigatório";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        ButtonAction(
          elevation: 0,
          onPressed: () => Get.back(),
          label: "Deixar para depois",
          color: lightGrey,
          textColor: azure,
        ),
        ButtonAction(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm?.call(
                rate: rate,
                comment: _commentController.text,
              );
              Get.back();
            }
          },
          label: "Avaliar",
        ),
      ],
    );
  }
}
