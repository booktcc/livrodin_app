import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/models/book.dart';

class HomeBanner extends StatelessWidget {
  HomeBanner({
    super.key,
    required this.books,
    int initialPage = 0,
  })  : _currentIndex = Rx(initialPage),
        _pageController = PageController(initialPage: initialPage) {
    if (books.isEmpty) {
      throw Exception('HomeBanner: books must not be empty');
    }
  }

  final List<Book> books;
  final Rx<int> _currentIndex;
  final PageController _pageController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => _currentIndex.value = value,
            physics: const BouncingScrollPhysics(),
            itemCount: books.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Get.toNamed('/book/detail/${books[index].id}'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              books[index].coverUrl!,
                              fit: BoxFit.cover,
                              height: constraints.maxHeight,
                              width: (constraints.maxHeight * 240) / 360,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.handshake_rounded,
                                  color: Colors.green[600],
                                ),
                                Icon(
                                  Icons.swap_horizontal_circle_rounded,
                                  color: Colors.green[600],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            books[index].authorsString.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w300,
                              color: grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            books[index].title!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    books.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 5),
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color:
                            _currentIndex.value == index ? Colors.white : grey,
                        borderRadius: BorderRadius.circular(360),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
