import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ta_anywhere/components/queryTile.dart';
import 'package:ta_anywhere/components/reupload_del.dart';
import 'package:ta_anywhere/components/textSize.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final queries = FirebaseFirestore.instance.collection('user queries');
  final storageRef = FirebaseStorage.instance.ref();
  TextEditingController searchController = TextEditingController();
  String code = '';

  Future<void> _refreshBrowse() async {
    return await Future.delayed(const Duration(seconds: 1));
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
        height: 30,
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
                child: mediumLabel('No queries posted.', context),
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
                SliverList.separated(
                  itemCount: queriesSnapshots.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = queriesSnapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (data['inSession'] == false) {
                      var posted = uploadtimeconversion(data['uploadedTime']);
                      if (posted >= 10) {
                        queries
                            .doc(queriesSnapshots.data!.docs[index].id
                                .toString())
                            .update({'uploadedTime': DateTime.now()})
                            .then((value) =>
                                debugPrint('Updated uploadTime field'))
                            .catchError((error) =>
                                debugPrint('Failed to update: $error'));
                      }
                      //auto purge after 60min
                      var lifetime = lifetimeconversion(data['lifetime']);
                      if (lifetime >= 60) {
                        queries
                            .doc(queriesSnapshots.data!.docs[index].id
                                .toString())
                            .delete()
                            .then((value) =>
                                debugPrint('Purged data after 60min'))
                            .catchError((error) =>
                                debugPrint('Failed to delete query: $error'));
                        deleteImages(data[
                            'image_url']); //del image in FirebaseStorage too
                      }
                      if (code.trim().isEmpty) {
                        return itemTile(context, data, lifetime);
                      }
                      if (data['module Code']
                              .toString()
                              .toLowerCase()
                              .contains(code.toLowerCase())) {
                        return itemTile(context, data, lifetime);
                      }
                    }
                    return Container();
                  },
                  separatorBuilder: (BuildContext context, index) =>
                      const Divider(
                    indent: 15,
                    endIndent: 15,
                    height: 10,
                    thickness: 1.4,
                    color: Color.fromARGB(255, 48, 97, 104),
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
