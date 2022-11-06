import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/models/book.dart';

class ToggleOfferStatus extends StatefulWidget {
  final void Function(BookAvailableType)? onChange;
  const ToggleOfferStatus({
    super.key,
    this.onChange,
  });

  @override
  State<ToggleOfferStatus> createState() => _ToggleOfferStatusState();
}

class _ToggleOfferStatusState extends State<ToggleOfferStatus> {
  Rx<BookAvailableType> status = Rx(BookAvailableType.both);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusBlock(
            text: 'Doação',
            selected: status.value == BookAvailableType.donate,
            roundedSide: _RoundedSide.left,
            onTap: () => {
              widget.onChange?.call(BookAvailableType.donate),
              status.value = BookAvailableType.donate
            },
          ),
          _StatusBlock(
            text: 'Ambos',
            selected: status.value == BookAvailableType.both,
            roundedSide: _RoundedSide.none,
            onTap: () => {
              widget.onChange?.call(BookAvailableType.both),
              status.value = BookAvailableType.both
            },
          ),
          _StatusBlock(
            text: 'Troca',
            selected: status.value == BookAvailableType.trade,
            roundedSide: _RoundedSide.right,
            onTap: () => {
              widget.onChange?.call(BookAvailableType.trade),
              status.value = BookAvailableType.trade
            },
          ),
        ],
      ),
    );
  }
}

enum _RoundedSide { left, right, none }

const _roundValue = 100.0;

const _selectedColor = Color(0xFFEFEFF4);

class _StatusBlock extends StatelessWidget {
  final String text;
  final bool selected;
  final _RoundedSide roundedSide;
  final void Function()? onTap;
  const _StatusBlock({
    Key? key,
    required this.text,
    required this.selected,
    this.roundedSide = _RoundedSide.none,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.only(
      topLeft:
          Radius.circular(roundedSide == _RoundedSide.left ? _roundValue : 0),
      topRight:
          Radius.circular(roundedSide == _RoundedSide.right ? _roundValue : 0),
      bottomLeft:
          Radius.circular(roundedSide == _RoundedSide.left ? _roundValue : 0),
      bottomRight:
          Radius.circular(roundedSide == _RoundedSide.right ? _roundValue : 0),
    );

    return InkWell(
      onTap: selected ? null : onTap,
      borderRadius: borderRadius,
      child: Ink(
        child: Container(
          width: 70,
          height: 40,
          decoration: BoxDecoration(
            color: selected ? _selectedColor : Colors.white,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
