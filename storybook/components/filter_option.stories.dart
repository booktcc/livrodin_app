import 'package:livrodin/components/filter_option.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';

class FilterOptionStories extends StatefulWidget {
  const FilterOptionStories({super.key});

  @override
  State<FilterOptionStories> createState() => _FilterOptionStoriesState();
}

class _FilterOptionStoriesState extends State<FilterOptionStories> {
  bool donationActive = true;
  bool tradeActive = false;

  calculateActive() {
    var count = 0;
    if (donationActive) count++;
    if (tradeActive) count++;
    return count;
  }

  bool canChange(bool nextValue) {
    if (nextValue == false && calculateActive() == 1) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: Center(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilterOption(
            title: "Doação",
            selected: donationActive,
            onTap: () {
              // check has one option selected
              if (!canChange(!donationActive)) {
                return;
              }
              setState(() {
                donationActive = !donationActive;
              });
            },
          ),
          const SizedBox(
            width: 10,
          ),
          FilterOption(
            title: "Troca",
            selected: tradeActive,
            onTap: () {
              if (!canChange(!tradeActive)) {
                return;
              }
              setState(() {
                tradeActive = !tradeActive;
              });
            },
          ),
        ],
      )),
    );
  }
}
