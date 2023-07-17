import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/textSize.dart';

class ViewUserProfileScreen extends StatefulWidget {
  const ViewUserProfileScreen(
      {super.key, required this.userid, required this.username});

  final String userid;
  final String username;

  @override
  State<ViewUserProfileScreen> createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  final User? user = Auth().currentUser;
  double avg = 0;
  String? _profilePicUrl;

  Widget _mentorRank(num rater) {
    String rank = '';
    if (rater <= 2) {
      rank = 'Newcomer';
    } else if (rater <= 5) {
      rank = 'Beginner';
    } else if (rater <= 10) {
      rank = 'Average';
    } else if (rater <= 20) {
      rank = 'Talented';
    } else if (rater <= 35) {
      rank = 'Competent';
    } else if (rater <= 60) {
      rank = 'Proficient';
    } else if (rater <= 80) {
      rank = 'Master';
    } else {
      rank = 'Grand Master';
    }
    return largeLabel(rank, context);
  }

  Widget _ratingStars(num rater, num rating) {
    if (rater == 0.0) {
      return RatingBar(
        ratingWidget: RatingWidget(
          full: Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: Icon(
            Icons.star_outline,
          ),
        ),
        glow: false,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemSize: 22,
        minRating: 0,
        ignoreGestures: true,
        initialRating: 0,
        onRatingUpdate: (rating) {
          debugPrint(rating.toString());
        },
      );
    }

    avg = rating / rater;
    return RatingBar(
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: Colors.amber,
        ),
        half: Icon(
          Icons.star_half,
          color: Colors.amber,
        ),
        empty: Icon(
          Icons.star_outline,
        ),
      ),
      glow: false,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemSize: 30,
      minRating: 0,
      ignoreGestures: true,
      initialRating: avg,
      onRatingUpdate: (rating) {
        debugPrint(rating.toString());
      },
    );
  }

  Widget _moduleBox(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _myModulesHeader() {
    return Row(
      children: [
        Text(
          'My Modules this Sem:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _myModulesList(List<dynamic> modules) {
    if (modules.isEmpty) {
      return const Text('No modules added.');
    }

    List<Widget> moduleRows = [];
    List<Widget> currentRow = [];

    for (int i = 0; i < modules.length; i++) {
      Widget moduleBox = _moduleBox(modules[i]);
      currentRow.add(moduleBox);
      currentRow.add(SizedBox(width: 10));

      // Check if four modules have been added to the current row
      if (currentRow.length == 8 || i == modules.length - 1) {
        moduleRows.add(Row(
          children: currentRow,
          mainAxisAlignment: MainAxisAlignment.start,
        ));
        moduleRows.add(SizedBox(height: 10));
        currentRow = [];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align rows to the left
      children: moduleRows,
    );
  }

  Widget _helpModulesHeader() {
    return Row(
      children: [
        Text(
          'Modules I can help with:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _helpModulesList(List<dynamic> modules) {
    if (modules.isEmpty) {
      return const Text('No modules added.');
    }

    List<Widget> moduleRows = [];
    List<Widget> currentRow = [];

    for (int i = 0; i < modules.length; i++) {
      Widget moduleBox = _moduleBox(modules[i]);
      currentRow.add(moduleBox);
      currentRow.add(SizedBox(width: 10));

      // Check if four modules have been added to the current row
      if (currentRow.length == 8 || i == modules.length - 1) {
        moduleRows.add(Row(
          children: currentRow,
          mainAxisAlignment: MainAxisAlignment.start,
        ));
        moduleRows.add(SizedBox(height: 10));
        currentRow = [];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align rows to the left
      children: moduleRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: largeLabel("${widget.username}'s Profile", context),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userid)
              .snapshots(),
          builder: (ctx, usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.waveDots(
                    color: Colors.black, size: 100),
              );
            }
            if (!usersnapshot.hasData || !usersnapshot.data!.exists) {
              return Center(
                child: mediumLabel('No queries posted.', context),
              );
            }
            if (usersnapshot.hasError) {
              return const Center(
                child: Text('Something went wrong...'),
              );
            }

            var data = usersnapshot.data!.data() as Map<String, dynamic>;

            // Extract the modules list from the data
            List<dynamic>? modules = data['modules'] as List<dynamic>?;

            if (modules == null) {
              modules = [];
            }

            List<dynamic>? modules_help =
                data['modules_help'] as List<dynamic>?;

            if (modules_help == null) {
              modules_help = [];
            }
            data['rater'] == 0 ? avg = 0 : avg = data['rating'] / data['rater'];

            _profilePicUrl = data['profile_pic'];

            return Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Mentor Rank:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              _mentorRank(data['rater']),
                              SizedBox(
                                height: 20,
                              ),
                              (data['rater'] == 0 || data['rater'] == 1)
                                  ? Text(
                                      '${data['rater']} RATING',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    )
                                  : Text(
                                      '${data['rater']} RATINGS',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                              Center(
                                child: Text(
                                  '${avg.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              _ratingStars(
                                data['rater'],
                                data['rating'],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showImageViewer(
                                context,
                                CachedNetworkImageProvider(
                                    _profilePicUrl.toString()),
                                swipeDismissible: true,
                                doubleTapZoomable: true);
                          },
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: _profilePicUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: _profilePicUrl.toString(),
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            LoadingAnimationWidget
                                                .threeArchedCircle(
                                                    color: Color.fromARGB(
                                                        255, 48, 97, 104),
                                                    size: 60),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ) as ImageProvider<Object>
                                : AssetImage('assets/icons/profile_pic.png'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _myModulesHeader(),
                          const SizedBox(height: 10),
                          _myModulesList(modules),
                          const SizedBox(height: 20),
                          _helpModulesHeader(),
                          const SizedBox(height: 10),
                          _helpModulesList(modules_help),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
