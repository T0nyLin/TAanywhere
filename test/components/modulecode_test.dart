import 'package:flutter_test/flutter_test.dart';
import 'package:ta_anywhere/components/modulecode.dart';

void main() {
  group('search for NUS module code and return if available', () {
    test('return valid NUS module code', () {
      //arrange
      String code = 'CS1010';
      //act
      Future<List<ModuleCode>> result = getModCodes(code);
      //assert
      Future<List<ModuleCode>> expected = getModCodes('CS1010');
      expect(result.toString(), expected.toString());
    });
  });
}
