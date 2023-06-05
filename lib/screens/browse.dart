import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  var queries = FirebaseFirestore.instance.collection('user queries');
  List<Map<String, dynamic>> allqueries = [];
  List<Map<String, dynamic>> _foundqueries = [];
  TextEditingController searchController = TextEditingController();
  String code = "";

  // @override
  // void initState() {
  //   super.initState();
  // }

  // void displose() {
  //   searchController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
              hintText: 'Search Module Code',
              prefixIcon: Icon(Icons.search_rounded),
              suffixIcon: Icon(Icons.close_rounded)),
          onChanged: (val) {
            setState(() {
              code = val;
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user queries')
            .orderBy('uploadedTime', descending: true)
            .snapshots(),
        builder: (ctx, queriesSnapshots) {
          if (queriesSnapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.waveDots(
                  color: Colors.black, size: 100),
            );
          }
          if (!queriesSnapshots.hasData ||
              queriesSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No queries posted.'),
            );
          }
          if (queriesSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: queriesSnapshots.data!.docs.length,
                  (BuildContext context, int index) {
                    var data = queriesSnapshots.data!.docs[index].data()
                        as Map<String, dynamic>;

                    Timestamp uploadtime = data['uploadedTime'];
                    final DateTime dateConvert =
                        DateTime.fromMillisecondsSinceEpoch(
                            uploadtime.seconds * 1000);
                    DateTime now = DateTime.now();
                    var diff = now.difference(dateConvert);
                    var posted = diff.inMinutes.toString();

                    if (code.trim().isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   searchController.text =
                            //       data[index]['module Code'];
                            // });
                          },
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image(
                                image: NetworkImage(
                                  data['image_url'],
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(data['query']),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data['module Code']),
                                    Text(data['cost']),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data['mentee']),
                                    Text('$posted min'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_right),
                          ),
                        ),
                      );
                    }
                    if (data['module Code']
                        .toString()
                        .toLowerCase()
                        .contains(code.toLowerCase())) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   searchController.text =
                            //       _foundqueries[index]['module Code'];
                            // });
                          },
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image(
                                image: NetworkImage(
                                  data['image_url'],
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(data['query']),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data['module Code']),
                                    Text(data['cost']),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data['mentee']),
                                    Text('$posted min'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_right),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
