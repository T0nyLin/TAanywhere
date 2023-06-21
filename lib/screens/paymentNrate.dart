import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PaymentAndRateScreen extends StatefulWidget {
  const PaymentAndRateScreen({super.key});

  @override
  State<PaymentAndRateScreen> createState() => _PaymentAndRateScreenState();
}

class _PaymentAndRateScreenState extends State<PaymentAndRateScreen> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBar.builder(
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemSize: 46,
                minRating: 0,
                itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                updateOnDrag: true,
                onRatingUpdate: (rating) => setState(() {
                      this.rating = rating;
                    })),
            Text(
              'Rate your mentor: $rating',
              style: Theme.of(context).primaryTextTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }
}
