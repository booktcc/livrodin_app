import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/models/availability.dart';

class BookListAvailable extends StatelessWidget {
  final List<Availability> availabilityList;
  final String title;

  const BookListAvailable(
      {super.key, required this.availabilityList, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: 300,
        width: 300,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: availabilityList.length,
          itemBuilder: (context, index) {
            var availability = availabilityList[index];
            return ListTile(
              title: Text(availability.user.name),
              leading: ProfileIcon(
                image: availability.user.profilePictureUrl,
                size: ProfileSize.sm,
              ),
              onTap: () {
                Get.back(result: availability.id);
              },
            );
          },
        ),
      ),
    );
  }
}
