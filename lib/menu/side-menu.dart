import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 288,
          height: double.infinity,
          color: Colors.teal,
          child: Column(
            children: [
              InfoCard(name: 'Ákos', profession: 'Software developer'),
            ],
          ),
        )
      )
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
    required this.profession,
  }): super(key: key);

  final String name, profession;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
  CupertinoIcons.person,
        color: Colors.white,
        )
        ),
         title: Text(
        'Bolemányi Ákos',
         ),
        subtitle: Text('Software developer'),
      );
  }
}