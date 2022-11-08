import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:livrodin/components/bottom_menu.dart';
import 'package:livrodin/components/bottom_profile.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/button_option.dart';
import 'package:livrodin/components/button_option_badge.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/components/transaction_painel.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/pages/home_page.dart';
import 'package:livrodin/pages/login_page.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'components/filter_option.stories.dart';
import 'components/header.stories.dart';
import 'components/layout.stories.dart';
import 'components/profile_icon.stories.dart';
import 'components/profile_info.stories.dart';
import 'components/toggle_offer_status.stories.dart';
import 'components/transaction_card.stories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('pt_BR', null);
  runApp(const StorybookApp());
}

class StorybookApp extends StatefulWidget {
  const StorybookApp({super.key});

  @override
  State<StorybookApp> createState() => _StorybookAppState();
}

class _StorybookAppState extends State<StorybookApp> {
  @override
  Widget build(BuildContext context) => Storybook(
        wrapperBuilder: (context, child) => MaterialApp(
          title: 'Livrodin',
          theme: themeData,
          home: child,
          debugShowCheckedModeBanner: false,
        ),
        stories: [
          Story(
            name: 'Pages/HomePage',
            builder: (context) => HomePage(),
          ),
          Story(
            name: 'Pages/LoginPage',
            builder: (context) => const LoginPage(),
          ),
          Story(
            name: 'Components/Header',
            builder: (context) => const HeaderStories(),
          ),
          Story(
            name: 'Components/BottomMenu',
            builder: (context) => Scaffold(
              backgroundColor: dark,
              bottomNavigationBar: BottomMenu(pageController: PageController()),
            ),
          ),
          Story(
            name: 'Components/ButtonOption',
            builder: (context) => Scaffold(
              backgroundColor: lightGrey,
              body: Center(
                child: ButtonOption(
                  iconData: Icons.home,
                  text: 'Home',
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Story(
            name: 'Components/BookCard',
            builder: (context) => Scaffold(
              backgroundColor: lightGrey,
              body: Center(
                  child: BookCard(
                book: Book(
                  id: "1",
                  isbn13: "978-85-7522-510-0",
                  title: "Harry Potter e a Pedra Filosofal",
                  authors: ["J. K. Rowling"],
                  coverUrl:
                      "https://books.google.com.br/books/publisher/content?id=GjgQCwAAQBAJ&hl=pt-BR&pg=PP1&img=1&zoom=3&bul=1&sig=ACfU3U32CKE-XFfMvnbcz1qW0PS46Lg-Ew&w=1280",
                ),
                onTap: (book) {},
              )),
            ),
          ),
          Story(
            name: 'Components/ToggleOfferStatus',
            builder: (context) {
              return const ToggleOfferStatusStories();
            },
          ),
          Story(
            name: 'Components/ProfileIcon',
            builder: (context) => const ProfileIconStories(),
          ),
          Story(
            name: 'Components/ButtonAction',
            builder: (context) => Scaffold(
              backgroundColor: lightGrey,
              body: Center(
                child: ButtonAction(
                  onPressed: () {},
                  icon: Icons.swap_horizontal_circle_rounded,
                  label: 'Trocar',
                ),
              ),
            ),
          ),
          Story(
            name: 'Components/FilterOption',
            builder: (context) => const FilterOptionStories(),
          ),
          Story(
            name: 'Components/ProfileInfo',
            builder: (context) => const ProfileInfoStories(),
          ),
          Story(
            name: 'Components/TansactionPainel',
            builder: (context) => Scaffold(
              backgroundColor: lightGrey,
              body: Center(
                child: TransactionPainel(
                  type: TransactionType.trade,
                ),
              ),
            ),
          ),
          Story(
            name: 'Components/ButtonOptionBadge',
            builder: (context) => Scaffold(
              backgroundColor: lightGrey,
              body: Center(
                child: ButtonOptionBadge(
                  onPressed: () {},
                  iconData: Icons.book_rounded,
                  text: 'Pedidos Recebidos',
                ),
              ),
            ),
          ),
          Story(
            name: 'Components/Layout',
            builder: (context) {
              return const LayoutStories();
            },
          ),
          Story(
            name: 'Components/BottomProfile',
            builder: (context) => const Scaffold(
              backgroundColor: lightGrey,
              body: Center(
                child: BottomProfile(),
              ),
            ),
          ),
          Story(
            name: 'Components/TradeCard',
            builder: (context) {
              return const TransactionCardStories();
            },
          ),
        ],
      );
}
