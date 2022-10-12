import 'package:flutter/material.dart';

enum OfferStatus { both, trade, donate }

class ToggleOfferStatus extends StatelessWidget {
  final OfferStatus status;
  final void Function(OfferStatus)? onChange;
  const ToggleOfferStatus({
    super.key,
    this.status = OfferStatus.both,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusBlock(
          text: 'Doação',
          selected: status == OfferStatus.donate,
          roundedSide: _RoundedSide.left,
          onTap: () => onChange?.call(OfferStatus.donate),
        ),
        _StatusBlock(
          text: 'Ambos',
          selected: status == OfferStatus.both,
          roundedSide: _RoundedSide.none,
          onTap: () => onChange?.call(OfferStatus.both),
        ),
        _StatusBlock(
          text: 'Troca',
          selected: status == OfferStatus.trade,
          roundedSide: _RoundedSide.right,
          onTap: () => onChange?.call(OfferStatus.trade),
        ),
      ],
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
