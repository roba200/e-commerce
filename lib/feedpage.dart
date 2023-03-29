import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/details_page.dart';
import 'package:e_commerce_app/morphism_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeedPage extends StatefulWidget {
  bool isLiked = false;
  String searchText = "";
  String userId = FirebaseAuth.instance.currentUser!.uid;

  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: Icon(Icons.search),
        title: TextField(
          controller: _controller,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "Search",
          ),
          onChanged: (value) {
            setState(() {
              widget.searchText = value;
            });
          },
        ),
      ),
      body: StreamBuilder(
          stream: widget.searchText.isNotEmpty
              ? FirebaseFirestore.instance
                  .collection('items')
                  .where('name', isGreaterThanOrEqualTo: widget.searchText)
                  .where('name', isLessThan: widget.searchText + 'z')
                  .snapshots()
              : FirebaseFirestore.instance.collection('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.hasData) {
              bool isLiked = true;
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 230,
                      childAspectRatio: 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    final documentSnapshot = snapshot.data?.docs[index];
                    final data = documentSnapshot?.data();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                        document: data,
                                      )));
                        },
                        child: MorphismCard(
                            child: Column(
                          children: [
                            Image.network(
                              data!['imageurl'],
                              height: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$" + data['price'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Text(
                              data['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(),
                            ),
                          ],
                        )),
                      ),
                    );
                  }));
            } else {
              return Center(
                child: Text("Error"),
              );
            }
          }),
    );
  }
}
