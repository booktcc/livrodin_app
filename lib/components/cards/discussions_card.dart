import 'package:flutter/material.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/models/discussion.dart';

class DiscussionCard extends StatelessWidget {
  const DiscussionCard({
    super.key,
    required this.discussion,
    this.margin,
    this.onTap,
    this.onTapProfile,
    this.seeMore = true,
  });

  final Discussion discussion;
  final EdgeInsetsGeometry? margin;
  final Function()? onTap;
  final Function()? onTapProfile;
  final bool seeMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: seeMore ? 120 : null,
      width: double.infinity,
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
        crossAxisAlignment:
            seeMore ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTapProfile,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileIcon(
                      image: discussion.user.profilePictureUrl,
                      size: ProfileSize.lg,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      discussion.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: seeMore ? FlexFit.tight : FlexFit.loose,
                      child: Text(
                        discussion.title,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: seeMore ? 4 : null,
                        overflow: seeMore ? TextOverflow.ellipsis : null,
                      ),
                    ),
                    Visibility(
                      visible: seeMore,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Clique para participar",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
