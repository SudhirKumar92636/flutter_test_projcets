
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/views/bottomnav/homescreens.dart';
import '../../razoritemsmodle/itemsshow.dart';
import '../addusersdetails/profile.dart';
import '../addusersdetails/showusersrealtime.dart';


class BottomNavigationsPages extends StatefulWidget {
  const BottomNavigationsPages({super.key});

  @override
  State<BottomNavigationsPages> createState() => _BottomNavigationsPagesState();
}

class _BottomNavigationsPagesState extends State<BottomNavigationsPages> {
  int currentIndex =0;
  final screens =[
    const HomeScreens(),
     const ProDuctsScreens(),
    const ShowUserInfo()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (value) {
            currentIndex =value;
            setState(() {

            });
          },
          items: const [
            BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon:Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon:Icon(Icons.shopping_bag),
                label: 'Product'),

            BottomNavigationBarItem(
                backgroundColor: Colors.green,
                icon:Icon(Icons.person),
                label: 'Profile'),
          ]
      ),
      body: screens[currentIndex],
    );
  }
}
