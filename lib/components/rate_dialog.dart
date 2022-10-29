import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class RateDialog extends StatefulWidget {
  final String title;
  final void Function({required int rate, required String comment})? onConfirm;
  const RateDialog({super.key, required this.title, this.onConfirm});

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  int rate = 3;
  final TextEditingController _commentController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RatingBar.builder(
            minRating: 1,
            maxRating: 5,
            initialRating: 3,
            itemCount: 5,
            glow: false,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return const Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  );
                case 2:
                  return const Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
                case 3:
                  return const Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
                default:
                  return const Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
              }
            },
            onRatingUpdate: (rating) {
              rate = rating.toInt();
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Comentário',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child:
              const Text('Deixar para depois', style: TextStyle(color: azure)),
        ),
        TextButton(
          onPressed: () => widget.onConfirm?.call(
            rate: rate,
            comment: _commentController.text,
          ),
          child: const Text('Avaliar', style: TextStyle(color: azure)),
        ),
      ],
    );
  }
}
