import 'package:flutter/material.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/components/rating_info.dart';
import 'package:livrodin/models/rating.dart';

class RatingCard extends StatelessWidget {
  const RatingCard({super.key, required this.rating, this.margin});

  final Rating rating;
  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0.1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileIcon(
                  image: rating.user.profilePictureUrl,
                  size: ProfileSize.lg,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  rating.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RatingInfo(
                  rating: rating.rating.toDouble(),
                  iconSize: 14,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                rating.comment,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
