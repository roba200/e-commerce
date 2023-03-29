import 'package:e_commerce_app/cart_page.dart';
import 'package:e_commerce_app/categories_page.dart';
import 'package:e_commerce_app/favourite_page.dart';
import 'package:e_commerce_app/feedpage.dart';
import 'package:e_commerce_app/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [
    FeedPage(),
    FavouritePage(),
    CategoriesPage(),
    CartPage(),
    ProfilePage(),
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favourites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          setState(() {
            current = index;
          });
        },
        currentIndex: current,
      ),
      body: screens[current],
    );
  }
}
