import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<ModuleCode>> getModCodes(String query) async {
  const String url = "https://api.nusmods.com/v2/2022-2023/moduleList.json";
  final http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List code = json.decode(response.body) as List<dynamic>;

    return code.map((json) => ModuleCode.fromJson(json)).where((code) {
      final codeUpper = code.modCode.toUpperCase();
      final queryUpper = query.toUpperCase();

      return codeUpper.contains(queryUpper);
    }).toList();
  } else {
    throw Exception();
  }
}

class ModuleCode {
  String modCode = "";

  ModuleCode({
    required this.modCode,
  });

  ModuleCode.fromJson(Map<String, dynamic> json) {
    modCode = json['moduleCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['moduleCode'] = modCode;
    return data;
  }
}
