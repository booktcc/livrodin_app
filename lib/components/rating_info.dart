import 'package:flutter/material.dart';

class RatingInfo extends StatelessWidget {
  const RatingInfo({
    super.key,
    required this.rating,
    this.iconSize = 20,
    this.fontSize = 14,
    this.isLoading = false,
  });

  final double rating;
  final double iconSize;
  final double fontSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          rating == 0.0
              ? Icons.star_border_rounded
              : (rating < 1 ? Icons.star_half_rounded : Icons.star_rounded),
          color: Colors.amber,
          size: iconSize,
        ),
        Icon(
          rating <= 1.0
              ? Icons.star_border_rounded
              : (rating < 2 ? Icons.star_half_rounded : Icons.star_rounded),
          color: Colors.amber,
          size: iconSize,
        ),
        Icon(
          rating <= 2.0
              ? Icons.star_border_rounded
              : (rating < 3 ? Icons.star_half_rounded : Icons.star_rounded),
          color: Colors.amber,
          size: iconSize,
        ),
        Icon(
          rating <= 3.0
              ? Icons.star_border_rounded
              : (rating < 4 ? Icons.star_half_rounded : Icons.star_rounded),
          color: Colors.amber,
          size: iconSize,
        ),
        Icon(
          rating <= 4.0
              ? Icons.star_border_rounded
              : (rating < 5 ? Icons.star_half_rounded : Icons.star_rounded),
          color: Colors.amber,
          size: iconSize,
        ),
        const SizedBox(width: 10),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: Colors.amber,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        Visibility(
          visible: isLoading,
          child: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 10,
              width: 10,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        )
      ],
    );
  }
}
