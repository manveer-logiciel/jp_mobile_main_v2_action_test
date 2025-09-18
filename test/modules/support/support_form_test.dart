
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/modules/support/controller.dart';

void main(){
  final controller = SupportFormController();
  late Map<String, dynamic> tempInitialJson;

  test("SupportFormController should be initilize with default values", () {
    expect(controller.subjectController.text, isEmpty);
    expect(controller.messageController.text, isEmpty);

    expect(controller.attachments, isEmpty);
    expect(controller.initialJson, isEmpty);
    expect(controller.totalAttachedFileSize, 0);
    expect(controller.isSavingForm, false);
    expect(controller.validateFormOnDataChange, false);
  });

  test('SupportFormController@supportFormJson() should generate json from form-data', () {
    tempInitialJson = controller.supportFormJson();
    final tempJson = controller.supportFormJson();
    expect(tempInitialJson, tempJson);
  });

  group('SupportFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });

    });

  group('SupportFormController@checkIfNewDataAdded() should check if any addition/update is made in form', () {

      String initialTitle = controller.subjectController.text;
      test('When no changes in form are made', () {
        controller.initialJson = controller.supportFormJson();
        final val = controller.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        controller.subjectController.text = "123";
        final val = controller.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        controller.subjectController.text = initialTitle;
        final val = controller.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When there is attachment attached', () {
        controller.attachments = [AttachmentResourceModel(id: 123)];
        final val = controller.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When there is no attachment attached', () {
        controller.attachments = [];
        final val = controller.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('SupportFormController@validateSubject() should validate field', () {

      test('When Subject field is empty',(){
        controller.subjectController.text = '';
        String? msg = controller.validateSubject(controller.subjectController.text);
        expect(msg, "subject_is_required");
      });
      
      test('When Subject fields data is not empty',(){
        controller.subjectController.text = '123';
        String? msg = controller.validateSubject(controller.subjectController.text);
        expect(msg, isNull);
      });

    });

    group('SupportFormController@validateMessage() should validate field', () {

      test('When Message field is empty',(){
        controller.messageController.text = '';
        String? msg = controller.validateMessage(controller.messageController.text);
        expect(msg, "message_is_required");
      });
      
      test('When Message fields data is not empty',(){
        controller.messageController.text = '123';
        String? msg = controller.validateMessage(controller.messageController.text);
        expect(msg, isNull);
      });

    });

    test('If attachment is attached, attachments list should not be empty', () {
      controller.attachments.add(AttachmentResourceModel(id: 1));
      expect(controller.attachments,isNotEmpty);
    });

    test('If attachment is removed, attachments list should be empty',(){
      controller.attachments.removeAt(0);
      expect(controller.attachments,isEmpty);
    });
}