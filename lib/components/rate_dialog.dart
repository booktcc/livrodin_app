import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class RateDialog extends StatelessWidget {
  final String title;
  final String content;
  final void Function(int rate)? onConfirm;
  RateDialog(
      {super.key, required this.title, required this.content, this.onConfirm});

  int rate = 3;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: RatingBar.builder(
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
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child:
              const Text('Deixar para depois', style: TextStyle(color: azure)),
        ),
        TextButton(
          onPressed: () => onConfirm?.call(rate),
          child: const Text('Avaliar', style: TextStyle(color: azure)),
        ),
      ],
    );
  }
}
