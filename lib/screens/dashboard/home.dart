import 'package:brianpharmacy/components/nav_bar.dart';
import 'package:brianpharmacy/constraints.dart';
import 'package:brianpharmacy/screens/dashboard/components/body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Body(),
      bottomNavigationBar: const MyNavBar(),
    );
  } 

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.more_vert_rounded,
        ),
      ),
    );
  }
}