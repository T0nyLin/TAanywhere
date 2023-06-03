import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  var queries = FirebaseFirestore.instance.collection('user queries');
  List<Map<String, dynamic>> items = [];
  bool isLoaded = false;

  _displayQuery() async {
    Future.delayed(const Duration(seconds: 2));

    List<Map<String, dynamic>> tempList = [];
    var query = await queries.get();

    query.docs.forEach((element) {
      tempList.add(element.data());
    });

    setState(() {
      items = tempList;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _displayQuery();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user queries')
          .orderBy('uploadedTime', descending: true)
          .snapshots(),
      builder: (ctx, queriesSnapshots) {
        if (queriesSnapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child:
                LoadingAnimationWidget.waveDots(color: Colors.black, size: 100),
          );
        }
        // if (isLoaded) {
        //   return Center(
        //     child:
        //         LoadingAnimationWidget.waveDots(color: Colors.black, size: 100),
        //   );
        // }
        if (!queriesSnapshots.hasData || queriesSnapshots.data!.docs.isEmpty) {
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
          slivers: [
            const SliverAppBar(
              pinned: true,
              backgroundColor: Color.fromARGB(255, 41, 128, 99),
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title:
                    TextField(decoration: InputDecoration(labelText: 'Search')),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: items.length,
                (BuildContext context, int index) {
                  Timestamp uploadtime = items[index]['uploadedTime'];
                  print(uploadtime.seconds);
                  final DateTime dateConvert =
                  DateTime.fromMillisecondsSinceEpoch(uploadtime.seconds * 1000);
                  DateTime now = DateTime.now();
                  var format = DateFormat('hh:mm');
                  var diff = now.difference(dateConvert);
                  var posted = diff.inMinutes.toString();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image(
                          image: NetworkImage(
                            items[index]['image_url'],
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      title: Text(items[index]['query']),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(items[index]['module Code']),
                              Text(items[index]['cost']),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(items[index]['mentee']),
                              Text('$posted min'),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_right),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
