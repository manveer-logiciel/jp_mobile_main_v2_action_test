import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';

void main() {
  group('MessageMediaModel.fromJson should parse fields properly', () {
    test("In case all fields are available, they should be parsed correctly", () {
      final result = MessageMediaModel.fromJson({
        'id': 1,
        'message_sid': 'sid123',
        'media_url': 'http://example.com/media.png',
        'short_url': 'http://short.url/media'
      });
      expect(result.id, 1);
      expect(result.messageSid, 'sid123');
      expect(result.mediaUrl, 'http://example.com/media.png');
      expect(result.shortUrl, 'http://short.url/media');
      expect(result.fileName, 'media.png');
      expect(result.fileExtension, 'png');
      expect(result.thumbIconType, isNotNull);
    });

    test("In case media_url is null, short_url should be used for fileName and thumbIconType", () {
      final result = MessageMediaModel.fromJson({
        'id': 1,
        'message_sid': 'sid123',
        'short_url': 'http://short.url/media'
      });
      expect(result.id, 1);
      expect(result.messageSid, 'sid123');
      expect(result.mediaUrl, null);
      expect(result.shortUrl, 'http://short.url/media');
      expect(result.fileName, 'http://short.url/media');
      expect(result.thumbIconType, JPThumbIconType.url);
    });

    test("In case id is missing, it should throw an error", () {
      expect(() => MessageMediaModel.fromJson({
        'message_sid': 'sid123',
        'media_url': 'http://example.com/media.png'
      }), throwsA(isA<TypeError>()));
    });
  });

  group('MessageMediaModel.toJson should convert fields properly', () {
    test("It should convert all fields to JSON correctly", () {
      final model = MessageMediaModel(
          id: 1,
          messageSid: 'sid123',
          mediaUrl: 'http://example.com/media.png',
          shortUrl: 'http://short.url/media'
      );
      final json = model.toJson();
      expect(json['id'], 1);
      expect(json['message_sid'], 'sid123');
      expect(json['media_url'], 'http://example.com/media.png');
      expect(json['short_url'], 'http://short.url/media');
    });
  });

  group('MessageMediaModel.filePath should give url to load file', () {
    test("In case mediaUrl does not exists, it should be shortUrl", () {
      final model = MessageMediaModel(
          id: 1,
          messageSid: 'sid123',
          shortUrl: 'http://short.url/media'
      );
      expect(model.filePath, 'http://short.url/media');
    });

    test("In case mediaUrl is available, it should be mediaUrl", () {
      final model = MessageMediaModel(
          id: 1,
          messageSid: 'sid123',
          mediaUrl: 'http://example.com/media.png'
      );
      expect(model.filePath, 'http://example.com/media.png');
    });

    test("In case both mediaUrl and shortUrl are missing, it should be empty", () {
      final model = MessageMediaModel(
          id: 1,
          messageSid: 'sid123'
      );
      expect(model.filePath, null);
    });
  });
}