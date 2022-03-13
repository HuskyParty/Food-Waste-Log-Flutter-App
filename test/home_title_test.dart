import 'package:test/test.dart';
import 'package:wastey/home_page.dart';

void main() {
  test('Home Title Test', () {
    final home = MyHomePage(title: 'Wastey');

    expect(home.title, 'Wastey');
  });
}
