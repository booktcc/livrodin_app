import 'package:flutter/material.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/models/reply.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    super.key,
    required this.comment,
    this.margin,
    this.onTapProfile,
    this.seeMore = true,
  });

  final Reply comment;
  final EdgeInsetsGeometry? margin;
  final Function()? onTapProfile;
  final bool seeMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 110,
      ),
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
          GestureDetector(
            onTap: onTapProfile,
            child: SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileIcon(
                    image: comment.user.profilePictureUrl,
                    size: ProfileSize.lg,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    comment.user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                comment.text,
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
