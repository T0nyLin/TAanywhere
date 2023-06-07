import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class QueryInfoScreen extends StatefulWidget {
  const QueryInfoScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<QueryInfoScreen> createState() => _QueryInfoScreenState();
}

class _QueryInfoScreenState extends State<QueryInfoScreen> {
  _lifetimeconversion(Map<String, dynamic> data) {
    Timestamp firstuploadtime = data['lifetime'];
    final DateTime dateConvert =
        DateTime.fromMillisecondsSinceEpoch(firstuploadtime.seconds * 1000);
    DateTime now = DateTime.now();
    var diff = now.difference(dateConvert);
    var lifetime = diff.inMinutes;

    return lifetime;
  }

  @override
  Widget build(BuildContext context) {
    var posted = _lifetimeconversion(widget.data);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -15,
            child: Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 164, 179, 179),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  showImageViewer(
                    context,
                    Image.network(widget.data['image_url']).image,
                    swipeDismissible: true,
                    doubleTapZoomable: true,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  width: double.infinity,
                  height: 300,
                  child: Image.network(
                    widget.data['image_url'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.data['query'],
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                  maxLines: 3,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.location_on_rounded),
                label: Text(
                  widget.data['location'],
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                  maxLines: 2,
                ),
                onPressed: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Landmark: ',
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                  ),
                  Text(
                    '${widget.data['landmark']}',
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Module Code: ',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        'Mentee: ',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        'Cost: ',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        'Level: ',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        'Posted: ',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.data['module Code']}',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        '${widget.data['mentee']}',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        '${widget.data['cost']}',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        '${widget.data['level']}',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      Text(
                        '$posted min ago',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const SearchMentorScreen(),
                  //   ),
                  // );
                },
                icon: const Icon(Icons.assignment_turned_in_rounded),
                label: const Text('Accept to help?'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
