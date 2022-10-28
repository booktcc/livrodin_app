import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum OfferStatus { both, trade, donate }

class ToggleOfferStatus extends StatefulWidget {
  final void Function(OfferStatus)? onChange;
  const ToggleOfferStatus({
    super.key,
    this.onChange,
  });

  @override
  State<ToggleOfferStatus> createState() => _ToggleOfferStatusState();
}

class _ToggleOfferStatusState extends State<ToggleOfferStatus> {
  Rx<OfferStatus> status = Rx(OfferStatus.both);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusBlock(
            text: 'Doação',
            selected: status.value == OfferStatus.donate,
            roundedSide: _RoundedSide.left,
            onTap: () => {
              widget.onChange?.call(OfferStatus.donate),
              status.value = OfferStatus.donate
            },
          ),
          _StatusBlock(
            text: 'Ambos',
            selected: status.value == OfferStatus.both,
            roundedSide: _RoundedSide.none,
            onTap: () => {
              widget.onChange?.call(OfferStatus.both),
              status.value = OfferStatus.both
            },
          ),
          _StatusBlock(
            text: 'Troca',
            selected: status.value == OfferStatus.trade,
            roundedSide: _RoundedSide.right,
            onTap: () => {
              widget.onChange?.call(OfferStatus.trade),
              status.value = OfferStatus.trade
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
