import 'dart:convert';

import 'package:http/http.dart' as http;

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = http.Client();

  PlaceApiProvider(this.sessionToken);

  final String sessionToken;

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    final String request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=en&components=country:Sg&key=AIzaSyC7EFshsiUoJdt-lItecOX5Wpm4mGo2dCo&sessiontoken=$sessionToken';
    final Uri url = Uri.parse(request);
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
