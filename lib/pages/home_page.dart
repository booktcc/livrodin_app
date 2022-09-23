import 'package:app_flutter/components/header.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      backgroundColor: dark,
      body: Column(
        children: [
          const SizedBox(
            height: 241,
            width: double.infinity,
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              // border rounded top
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.red,
                        height: 100,
                      ),
                      Container(
                        color: Colors.blue,
                        height: 500,
                      ),
                      Container(
                        color: Colors.yellow,
                        height: 400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
