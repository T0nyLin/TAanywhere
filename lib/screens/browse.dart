import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';


class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  var queries = FirebaseFirestore.instance.collection('user queries');
  TextEditingController searchController = TextEditingController();
  String code = "";

  void displose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _search(Map<String, dynamic> data, String posted) {
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
            child: GestureDetector(
              onTap: () {
                showImageViewer(
                  context,
                  Image.network(
                    data['image_url'],
                  ).image,
                  swipeDismissible: true,
                  doubleTapZoomable: true,
                );
              },
              child: Image(
                image: NetworkImage(
                  data['image_url'],
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(data['query']),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data['module Code']),
                  Text(data['cost']),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Search Module Code',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  searchController.clear();
                  code = "";
                },
                icon: const Icon(Icons.close_rounded),
              )),
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
            scrollDirection: Axis.vertical,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                      return _search(data, posted);
                    }
                    if (data['module Code']
                        .toString()
                        .toLowerCase()
                        .contains(code.toLowerCase())) {
                      return _search(data, posted);
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
