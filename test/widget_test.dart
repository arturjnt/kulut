import 'package:flutter_test/flutter_test.dart';

import 'package:kulut/providers/categories.dart';

void main() {
  test('Number of categories is as expected', () async {
    List<Category> categories = Categories().categories;

    expect(categories.length, 9);
  });
}
