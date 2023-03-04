import 'package:brianpharmacy/constraints.dart';
import 'package:flutter/material.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DoctorsTile(
            image: "assets/images/profile.png",
            title: "Marcus James",
            subtitle: "Orthodontist",
            press: () {},
          ),
          DoctorsTile(
            image: "assets/images/profile.png",
            title: "Juliet Akoth",
            subtitle: "Psychiatrists",
            press: () {},
          ),
          DoctorsTile(
            image: "assets/images/profile.png",
            title: "Joe Doe",
            subtitle: "Neurologists",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DoctorsTile extends StatelessWidget {
  const DoctorsTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.press,
  });
  final String image, title, subtitle;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding / 10,
      ),
      width: size.width * 1,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: press,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30, // Image radius
                    backgroundImage: AssetImage(image),
                  ),
                  title: Text(
                    title,
                    textScaleFactor: 1.5,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_add_outlined)),
                  subtitle: Text(subtitle),
                  selected: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
