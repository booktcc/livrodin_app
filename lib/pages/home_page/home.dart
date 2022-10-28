import 'package:app_flutter/components/home_banner.dart';
import 'package:app_flutter/components/title.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/models/book.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        final double minSize =
            (boxConstraints.maxHeight - 240) / boxConstraints.maxHeight;
        return Stack(
          children: [
            // HomeBanner(
            //   books: const [],
            // ),
            DraggableScrollableSheet(
              initialChildSize: minSize,
              maxChildSize: 1,
              minChildSize: minSize,
              builder: (context, scrollController) => ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(pageRadius),
                ),
                child: Container(
                  color: lightGrey,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: PageTitle(
                          title: "Últimos Disponibilizados",
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.more_rounded),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: PageTitle(
                          title: "Recomendados",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
