import 'package:livrodin/components/toggle_offer_status.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:livrodin/models/book.dart';

class ToggleOfferStatusStories extends StatefulWidget {
  const ToggleOfferStatusStories({super.key});

  @override
  State<ToggleOfferStatusStories> createState() =>
      _ToggleOfferStatusStoriesState();
}

class _ToggleOfferStatusStoriesState extends State<ToggleOfferStatusStories> {
  BookAvailableType status = BookAvailableType.both;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: Center(
        child: ToggleOfferStatus(
          onChange: (newStatus) => setState(() {
            status = newStatus;
          }),
        ),
      ),
    );
  }
}
