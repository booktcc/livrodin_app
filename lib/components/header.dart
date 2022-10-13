import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatefulWidget with PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showLogo;
  final String? title;
  const Header({
    super.key,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.showLogo = false,
    this.title,
  });

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      centerTitle: widget.showLogo || widget.title == null,
      title: widget.title != null
          ? Text(
              widget.title!,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            )
          : widget.showLogo
              ? RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 18 * 0.29,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(text: "LIVROD"),
                      TextSpan(
                        text: "IN",
                        style: TextStyle(
                          color: red,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
      backgroundColor: dark,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: widget.actions ?? [],
          ),
        ),
      ],
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          if (widget.leading != null) widget.leading!,
        ],
      ),
    );
  }
}
