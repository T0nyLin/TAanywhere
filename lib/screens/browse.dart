import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ta_anywhere/widget/queryinfo.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final queries = FirebaseFirestore.instance.collection('user queries');
  TextEditingController searchController = TextEditingController();
  String code = "";

  void displose() {
    searchController.dispose();
    super.dispose();
  }

  void _showModalBottomSheet(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      isDismissible: true,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 165, 228, 234),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.8,
        minChildSize: 0.45,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: QueryInfoScreen(data: data),
        ),
      ),
    );
  }

  _uploadtimeconversion(Map<String, dynamic> data) {
    Timestamp lifetime = data['uploadedTime'];
    final DateTime dateConvert =
        DateTime.fromMillisecondsSinceEpoch(lifetime.seconds * 1000);
    DateTime now = DateTime.now();
    var diff = now.difference(dateConvert);
    var upload = diff.inMinutes;

    return upload;
  }

  _lifetimeconversion(Map<String, dynamic> data) {
    Timestamp firstuploadtime = data['lifetime'];
    final DateTime dateConvert =
        DateTime.fromMillisecondsSinceEpoch(firstuploadtime.seconds * 1000);
    DateTime now = DateTime.now();
    var diff = now.difference(dateConvert);
    var lifetime = diff.inMinutes;

    return lifetime;
  }

  Future<void> _refreshBrowse() async {
    return await Future.delayed(const Duration(seconds: 1));
  }

  Widget _search(Map<String, dynamic> data, int posted) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () {
              showImageViewer(
                context,
                CachedNetworkImageProvider(data['image_url']),
                swipeDismissible: true,
                doubleTapZoomable: true,
              );
            },
            child: CachedNetworkImage(
              imageUrl: data['image_url'].toString(),
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) =>
                  const CircularProgressIndicator(
                      color: Color.fromARGB(255, 48, 97, 104)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 50,
            ),
          ),
        ),
        title: Text(
          data['query'],
          style: Theme.of(context).primaryTextTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['module Code'],
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                Text(
                  'Cost: ${data['cost']}',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['mentee'],
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                Text(
                  'Posted: $posted min ago',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_right),
        onTap: () => _showModalBottomSheet(context, data),
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
              hintStyle: Theme.of(context).primaryTextTheme.bodyMedium,
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
      body: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 20,
        showChildOpacityTransition: false,
        animSpeedFactor: 2,
        height: 50,
        backgroundColor: const Color.fromARGB(255, 48, 97, 104),
        color: const Color.fromARGB(255, 128, 222, 234),
        onRefresh: _refreshBrowse,
        child: StreamBuilder<QuerySnapshot>(
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
              return Center(
                child: Text(
                  'No queries posted.',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              );
            }
            if (queriesSnapshots.hasError) {
              return const Center(
                child: Text('Something went wrong...'),
              );
            }
            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: queriesSnapshots.data!.docs.length,
                    (BuildContext context, int index) {
                      var data = queriesSnapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      //auto brings older posts to the top
                      var posted = _uploadtimeconversion(data);
                      if (posted >= 10) {
                        queries
                            .doc(queriesSnapshots.data!.docs[index].id
                                .toString())
                            .update({'uploadedTime': DateTime.now()});
                      }
                      //auto purge after 60min
                      var lifetime = _lifetimeconversion(data);
                      if (lifetime >= 60) {
                        queries
                            .doc(queriesSnapshots.data!.docs[index].id
                                .toString())
                            .delete();
                      }

                      if (code.trim().isEmpty) {
                        return _search(data, lifetime);
                      }
                      if (data['module Code']
                          .toString()
                          .toLowerCase()
                          .contains(code.toLowerCase())) {
                        return _search(data, lifetime);
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
