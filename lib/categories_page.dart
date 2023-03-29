import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/category_select.dart';
import 'package:e_commerce_app/morphism_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Categories",
          style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final documentSnapshot = snapshot.data?.docs[index];
                final data = documentSnapshot?.data();
                return GestureDetector(
                  child: Container(
                    height: 150,
                    child: MorphismCard(
                      child: Column(
                        children: [
                          Image.network(
                            data!['imageurl'],
                            height: 50,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            data!['cat'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CategorySelect(category: data['cat'])));
                  },
                );
              },
            );
          }),
    );
  }
}
