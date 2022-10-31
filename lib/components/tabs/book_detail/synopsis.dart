import 'package:flutter/material.dart';
import 'package:livrodin/models/book.dart';

class TabViewSynopsis extends StatelessWidget {
  const TabViewSynopsis({
    super.key,
    required this.book,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final Book book;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverToBoxAdapter(
            child: Text(
              book.synopsis ??
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam sed ex ante. Curabitur tincidunt nisi ac magna sodales, in iaculis mi commodo. In molestie consequat risus, id malesuada dolor luctus vel. Vestibulum tempus, dolor ut dapibus tempus, orci metus auctor lacus, dignissim ullamcorper sem dolor dapibus turpis. Nullam blandit magna id quam blandit, a semper nisl laoreet. Sed accumsan condimentum nulla quis facilisis. Maecenas ac arcu luctus, suscipit ipsum ultricies, scelerisque dui. Donec efficitur, nibh id feugiat malesuada, nulla dui pretium dolor, id ornare ex elit eu tellus. Nulla facilisi. Suspendisse mollis eleifend leo, pellentesque aliquam elit auctor vel. Praesent sed mattis enim. Donec feugiat sed ex non scelerisque. Duis pellentesque ultricies est. Nullam venenatis molestie arcu, et bibendum orci congue vel. Nam mollis finibus augue, at lacinia dolor vehicula id. Praesent fringilla tincidunt erat, maximus gravida risus vestibulum a. Vivamus a gravida nisi, et consequat orci. Vivamus at velit nec sem interdum eleifend. Sed a dictum ligula. Donec ligula lorem, ullamcorper pellentesque velit nec, tristique mattis justo. Duis vel turpis fringilla, tempor orci vel, laoreet lectus. Vestibulum dapibus leo tortor, a auctor lorem commodo eu. Proin diam eros, suscipit nec aliquet at, cursus sit amet risus. Fusce hendrerit elit sit amet dui sollicitudin scelerisque. Aliquam finibus ut sem sit amet scelerisque. Cras lacinia pretium mauris, tempus congue lectus mollis eget Ut ac ante quis dolor lobortis dictum. Etiam efficitur libero ante, ac iaculis orci placerat luctus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris ultricies, nibh eu venenatis accumsan, turpis tellus maximus ante, quis congue dolor urna a justo. Nulla facilisi. Aenean sollicitudin gravida leo ut dictum. Donec sit amet aliquet urna. Sed eu sapien eget orci posuere consectetur sit amet in est. Cras mollis, purus at vulputate mollis, elit quam mollis odio, et pellentesque felis neque rutrum orci. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse consectetur lectus eu eros malesuada blandit. Donec imperdiet mi et turpis dignissim feugiat. Nunc tincidunt hendrerit ligula sed cursus. In quis sapien metus. In hac habitasse platea dictumst. Duis fermentum magna vitae purus bibendum, nec mattis felis malesuada. Curabitur ac magna eleifend, rhoncus dui vitae, luctus elit. Duis in pellentesque urna. Nullam consequat cursus euismod. Nunc massa ex, lacinia in cursus eu, ornare id eros. Phasellus enim dolor, elementum a lorem nec, aliquam ultrices erat. Integer porta nisi et arcu elementum, nec faucibus lacus hendrerit. Pellentesque imperdiet lectus nec ipsum condimentum tristique. Suspendisse potenti. Fusce metus quam, hendrerit sit amet viverra quis, pulvinar vel enim.",
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
