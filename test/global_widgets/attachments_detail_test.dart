import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/global_widgets/attachments_detail/controller.dart';

void main() {
  List<AttachmentResourceModel> attachments = [
    AttachmentResourceModel(url: 'file1', id: 1),
    AttachmentResourceModel(url: 'file2', id: 2),
  ];
  List<AttachmentResourceModel> attachments1 = [
    AttachmentResourceModel(url: 'file1.txt', classType: 'ppt', id: 1),
    AttachmentResourceModel(url: 'file2.png', classType: 'png', id: 2),
  ];
  List<AttachmentResourceModel> attachments2 = [
    AttachmentResourceModel(url: 'file1', classType: 'jpeg', id: 1),
    AttachmentResourceModel(url: 'file2', classType: 'Type2', id: 2),
  ];

  group('AttachmentController@getAttachmentExtension should return correct extension', () {
    test('Should return extension from url when attachments list contains url with extension', () {

      final controller = AttachmentController(attachments1);
      final result = controller.getAttachmentExtension(0);

      expect(result, 'txt');
    });
    test('Should return extension from classType when attachments list url does not contains extension', () {
      final controller = AttachmentController(attachments2);
      final result = controller.getAttachmentExtension(0);
      expect(result, 'jpeg');
    });
    test('Should return empty string when attachments list does not contain url with extension and classType is also empty', () {
      final controller = AttachmentController(attachments);
      final result = controller.getAttachmentExtension(0);
      expect(result, '');
    });
  });
}
