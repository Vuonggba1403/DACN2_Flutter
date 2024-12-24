import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:travelapp_flutter/information_screen/information_history.dart';
import 'package:travelapp_flutter/information_screen/notification_firebase.dart';
import 'package:travelapp_flutter/models/model_news.dart';
import 'package:travelapp_flutter/screens/news.dart';
import 'favorite_screen.dart';
import '../utils/loading_screen.dart';
import 'ChatBot/chatbot.dart';

import 'profile_page.dart';
import 'search_page.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int index = 0;

  final items = [
    Column(
      children: [
        Image.asset(
          'assets/images/home.png',
          width: 30,
          height: 30,
        ),
        const Text(
          "Home",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    Column(
      children: [
        Image.asset(
          'assets/images/heart.png',
          width: 30,
          height: 30,
        ),
        const Text(
          "Faviorite",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    Column(
      children: [
        Image.asset(
          'assets/images/send.png',
          width: 30,
          height: 30,
        ),
        const Text(
          "Trip",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    Column(
      children: [
        Image.asset(
          'assets/images/history.png',
          width: 30,
          height: 30,
        ),
        const Text(
          "History",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    Column(
      children: [
        Image.asset(
          'assets/images/user.png',
          width: 30,
          height: 30,
        ),
        const Text(
          "Profiles",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ];

  final screen = [
    const SearchPage(),
    const FavoriteScreen(),
    const NewsPage(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //Title
      body: NestedScrollView(
          headerSliverBuilder: (context, innerIsScrolled) => [
                SliverAppBar(
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false, //tat nut quay lai
                    backgroundColor: const Color.fromARGB(31, 4, 9, 82),
                    title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedTextKit(
                                animatedTexts: [
                                  WavyAnimatedText('iVIVU.COM',
                                      textStyle: const TextStyle(
                                          color: Colors.orange,
                                          fontSize: 30,
                                          fontFamily: 'RubikWetPaint',
                                          wordSpacing: 40,
                                          fontWeight: FontWeight.bold)),
                                ],
                                repeatForever: true,
                                isRepeatingAnimation: true,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () => loadingScreen(
                                      context,
                                      () => const ChatBot(),
                                    ),
                                    child: LottieBuilder.asset(
                                        "assets/Lottie/chatbot.json",
                                        width: 60,
                                        height: 60),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      loadingScreen(context,
                                          () => const NotificationScreen());
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],

          //body screen
          body: screen[index]),

      //NavigationBar
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(31, 4, 9, 82),
        buttonBackgroundColor: Colors.blue,
        height: 60,
        animationCurve: Curves.decelerate,
        animationDuration: const Duration(milliseconds: 450),
        backgroundColor: Colors.transparent,
        items: items
            .map((item) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10), // Khoảng cách lùi về dưới
                      item,
                    ],
                  ),
                ))
            .toList(),
        index: index,
        onTap: (index) => setState(() {
          this.index = index;
        }),
      ),
    );
  }
}
