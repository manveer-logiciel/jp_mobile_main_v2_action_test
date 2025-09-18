
// import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {

  final controller = JPInputBoxController();

  WorkFlowStageModel work = WorkFlowStageModel(name: '', color: '', code: '');

  JobModel job = JobModel(id: 123, customerId: 123, currentStage:work, altId: 'Alt143', name: 'Kabira', number: '123', divisionCode: '786');

  CustomerModel customer = CustomerModel(id: 11, fullName: 'Kabir Singh', additionalEmails: ['abc@test.com']);


  List<JPMultiSelectModel> tempUserList = [
    JPMultiSelectModel(label: 'User 1', id: '1', isSelect: true),
    JPMultiSelectModel(label: 'User 2', id: '2', isSelect: true),
    JPMultiSelectModel(label: 'User 3', id: '3', isSelect: false),
    JPMultiSelectModel(label: 'User 4', id: '4', isSelect: false),
    JPMultiSelectModel(label: 'User 5', id: '5', isSelect: false),
    JPMultiSelectModel(label: 'User 6', id: '6', isSelect: false),
  ];

  List<JPMultiSelectModel> tempUserListNoSelected = [
    JPMultiSelectModel(label: 'User 3', id: '3', isSelect: false),
    JPMultiSelectModel(label: 'User 4', id: '4', isSelect: false),
    JPMultiSelectModel(label: 'User 5', id: '5', isSelect: false),
    JPMultiSelectModel(label: 'User 6', id: '6', isSelect: false),
  ];

  group('FormValueSelectorService@parseMultiSelectData should parse multi-select data to text presentable form', () {

    test('When multiple objects are selected', () {
      FormValueSelectorService.parseMultiSelectData(tempUserList, controller);
      expect(controller.text, 'User 1, User 2');
    });

    test('When only one object is selected', () {
      tempUserList[1].isSelect = false;
      FormValueSelectorService.parseMultiSelectData(tempUserList, controller);
      expect(controller.text, 'User 1');
    });

    test('When no object is selected', () {
      FormValueSelectorService.parseMultiSelectData(tempUserListNoSelected, controller);
      expect(controller.text, '');
    });

  });

  group('FormValueSelectorService@getSelectedMultiSelectValues should return selected objects', () {

    test('When multiple objects are selected', () {
      tempUserList[1].isSelect = true;
      final result = FormValueSelectorService.getSelectedMultiSelectValues(tempUserList);
      expect(result, [tempUserList[0], tempUserList[1]]);
    });

    test('When only one object is selected', () {
      tempUserList[1].isSelect = false;
      final result = FormValueSelectorService.getSelectedMultiSelectValues(tempUserList);
      expect(result, [tempUserList[0]]);
    });

    test('When no object is selected', () {
      final result = FormValueSelectorService.getSelectedMultiSelectValues(tempUserListNoSelected);
      expect(result, <dynamic>[]);
    });
  });

  group('FormValueSelectorService@setJobName should give displayable job name', () {

    test('When customer name is not there', () {
      FormValueSelectorService.setJobName(jobModel: job, controller: controller);
      expect(controller.text, '123');
    });

    test('When customer name is there, but it\'s null', () {
      job.customer = CustomerModel(
        fullName: null
      );
      FormValueSelectorService.setJobName(jobModel: job, controller: controller);
      expect(controller.text, '123');
    });

    test('When customer name is there & is not null', () {
      job.customer = CustomerModel(
          fullName: 'Subhash'
      );
      FormValueSelectorService.setJobName(jobModel: job, controller: controller);
      expect(controller.text, 'Subhash / 123');
    });


  });

    group('FormValueSelectorService@setCustomerName should give displayable customer name', () {

    test('When customer name is there, but it\'s null', () {
      customer = CustomerModel(
        fullName: null
      );
      FormValueSelectorService.setCustomerName(controller: controller, customerModel: customer);
      expect(controller.text, '');
    });

    test('When customer name is there & is not null', () {
      customer = CustomerModel(
          fullName: 'Subhash'
      );
      FormValueSelectorService.setCustomerName(controller: controller, customerModel: customer);
      expect(controller.text, 'Subhash');
    });


  });

  group('FormValueSelectorService@parseMultiSelectData should parse multi-select data to text presentable form', () {

    test('When multiple objects are selected', () {
      tempUserList[1].isSelect = true;
      FormValueSelectorService.parseMultiSelectData(tempUserList, controller);
      expect(controller.text, 'User 1, User 2');
    });

    test('When only one object is selected', () {
      tempUserList[1].isSelect = false;
      FormValueSelectorService.parseMultiSelectData(tempUserList, controller);
      expect(controller.text, 'User 1');
    });

    test('When no object is selected', () {
      FormValueSelectorService.parseMultiSelectData(tempUserListNoSelected, controller);
      expect(controller.text, '');
    });

  });



}