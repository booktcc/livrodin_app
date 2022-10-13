import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderProps {
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showLogo;
  final String? title;

  HeaderProps({
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.showLogo = false,
    this.title,
  });
}

class Header extends StatefulWidget with PreferredSizeWidget {
  final HeaderProps props;
  const Header({
    super.key,
    required this.props,
  });

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    HeaderProps props = widget.props;
    return AppBar(
      toolbarHeight: 52,
      centerTitle: props.showLogo || props.title == null,
      title: props.title != null
          ? Text(
              props.title!,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            )
          : props.showLogo
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
            children: props.actions ?? [],
          ),
        ),
      ],
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (props.showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          if (props.leading != null) props.leading!,
        ],
      ),
    );
  }
}
