import 'package:app_flutter/components/toggle_offer_status.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';

class ToggleOfferStatusStories extends StatefulWidget {
  const ToggleOfferStatusStories({super.key});

  @override
  State<ToggleOfferStatusStories> createState() =>
      _ToggleOfferStatusStoriesState();
}

class _ToggleOfferStatusStoriesState extends State<ToggleOfferStatusStories> {
  OfferStatus status = OfferStatus.both;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: Center(
        child: ToggleOfferStatus(
          status: status,
          onChange: (newStatus) => setState(() {
            status = newStatus;
          }),
        ),
      ),
    );
  }
}