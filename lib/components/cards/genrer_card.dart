import 'package:flutter/material.dart';
import 'package:livrodin/models/Genrer.dart';

class GenrerCard extends StatelessWidget {
  const GenrerCard({super.key, required this.genrer, this.onTap});

  final Function(Genrer)? onTap;
  final Genrer genrer;
  final double radius = 20;
  final double width = 200;
  final double height = 200;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(genrer),
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(genrer.coverUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5),
                BlendMode.lighten,
              ),
              //opacity: 0.5,
            ),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 0.1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              genrer.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Avenir',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
