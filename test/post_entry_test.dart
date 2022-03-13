import 'package:test/test.dart';
import 'package:wastey/models/post_entry.dart';

void main() {
  test('Post quantity should be generated', () {
    final post = PostDTO();

    post.savedCount = '5';

    expect(post.savedCount, '5');
  });

  test('Post lat and long should be generated', () {
    final post = PostDTO();

    post.latitude = 'Latitude: 37.4219983';
    post.longitude = 'Longitude: -122.084';

    expect(post.latitude, 'Latitude: 37.4219983');
    expect(post.longitude, 'Longitude: -122.084');
  });

  test('Post photo and date should be generated', () {
    final post = PostDTO();

    post.imageFile = 'https://source.unsplash.com/random/?husky';
    post.postDate = 'Saturday, March 12';

    expect(post.imageFile, 'https://source.unsplash.com/random/?husky');
    expect(post.postDate, 'Saturday, March 12');
  });
}
