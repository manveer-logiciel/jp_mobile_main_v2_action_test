import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/options.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


void main() {
  CustomFormFieldsModel tempCustomFormField = CustomFormFieldsModel(id: 0, name: 'Field 1', controller: JPInputBoxController());

  group('For CustomFormFieldsModel@setDropdownDisplayOptionsLength method', () {
    test('should set dropDownOptionsLength to 1 when no options are available', () {
      tempCustomFormField.options = [];
      tempCustomFormField.setDropdownDisplayOptionsLength();

    expect(tempCustomFormField.dropDownOptionsLength, 1);
  });
    
    test('Increases dropDownOptionsLength when selectedItems is not empty', () {
      final options = [
        CustomFormFieldOption(id: 0, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "1", label: '', isSelect: true)],),
        CustomFormFieldOption(id: 1, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "2", label: '', isSelect: true)],),
      ];
      tempCustomFormField.options = options;
      tempCustomFormField.setDropdownDisplayOptionsLength();

      expect(tempCustomFormField.dropDownOptionsLength, 2);
    });

    test('Does not increase dropDownOptionsLength when selectedItems is empty', () {
      final options = [
        CustomFormFieldOption(id: 0, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "1", label: '', isSelect: false)],),
        CustomFormFieldOption(id: 1, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "2", label: '', isSelect: false)],),
      ];
      tempCustomFormField.options = options;
      tempCustomFormField.setDropdownDisplayOptionsLength();

      expect(tempCustomFormField.dropDownOptionsLength, 1);
    });

    test('Updates linkedOptions and items based on selectedItems', () {
        final options = [
          CustomFormFieldOption(id: 0, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "1", label: '', isSelect: true)],),
          CustomFormFieldOption(id: 1, controller: JPInputBoxController(), items: [
              JPMultiSelectModel(id: "2", label: '', isSelect: true, additionData: [1]),
              JPMultiSelectModel(id: "3", label: '', isSelect: true, additionData: [2]),
              JPMultiSelectModel(id: "4", label: '', isSelect: true, additionData: [3]),
            ]),
          CustomFormFieldOption(id: 2, controller: JPInputBoxController(), items: [
              JPMultiSelectModel(id: "5", label: '', isSelect: true, additionData: [2]),
              JPMultiSelectModel(id: "6", label: '', isSelect: true, additionData: [3]),
              JPMultiSelectModel(id: "7", label: '', isSelect: true, additionData: [4]),
            ]),
      ];

      tempCustomFormField.options = options;
      tempCustomFormField.setDropdownDisplayOptionsLength();

      expect(tempCustomFormField.options![1].linkedOptions?.length, 1);
      expect(tempCustomFormField.options![1].linkedOptions?[0], 1);
      expect(tempCustomFormField.options![1].items.length, 1);
      expect(tempCustomFormField.options![1].items[0].additionData.length, 1);
      expect(tempCustomFormField.options![1].items[0].additionData[0], 1);
      expect(tempCustomFormField.options![2].linkedOptions?.length, 1);
      expect(tempCustomFormField.options![2].linkedOptions?[0], 2);
      expect(tempCustomFormField.options![2].items.length, 1);
      expect(tempCustomFormField.options![2].items[0].additionData.length, 1);
      expect(tempCustomFormField.options![2].items[0].additionData[0], 2);
    });
  });

  group('For CustomFormFieldsModel@removeDropdownItems method', () {
    test('Clears items and linkedOptions when selectedItems is empty', () {
      final options = [
        CustomFormFieldOption(id: 0, controller: JPInputBoxController(), items: [],),
        CustomFormFieldOption(id: 1, controller: JPInputBoxController(), items: [],),
        CustomFormFieldOption(id: 2, controller: JPInputBoxController(), items: [],),
      ];
      tempCustomFormField.options = options;

      tempCustomFormField.removeDropdownItems(0);

      expect(tempCustomFormField.options![0].items, isEmpty);
      expect(tempCustomFormField.options![0].linkedOptions, isEmpty);
      expect(tempCustomFormField.options![1].items, isEmpty);
      expect(tempCustomFormField.options![1].linkedOptions, isEmpty);
      expect(tempCustomFormField.options![2].items, isEmpty);
      expect(tempCustomFormField.options![2].linkedOptions, isEmpty);
    });

    test('Removes items based on removeItemsIds', () {
      final options = [
        CustomFormFieldOption(id: 0, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "1", label: '', isSelect: true)]),
        CustomFormFieldOption(id: 1, controller: JPInputBoxController(), items: [
          JPMultiSelectModel(id: "2", label: '', isSelect: false),
          JPMultiSelectModel(id: "3", label: '', isSelect: true),
        ]),
        CustomFormFieldOption(id: 2, controller: JPInputBoxController(), items: [
          JPMultiSelectModel(id: "4", label: '', isSelect: true, additionData: [1]),
          JPMultiSelectModel(id: "5", label: '', isSelect: false, additionData: [2]),
          JPMultiSelectModel(id: "6", label: '', isSelect: true, additionData: [3]),
        ]),
      ];

      tempCustomFormField.options = options;

      tempCustomFormField.removeDropdownItems(0);

      expect(tempCustomFormField.options![0].items.length, 1);
      expect(tempCustomFormField.options![0].selectedItems.length, 1);
      expect(tempCustomFormField.options![0].selectedItems[0].id, "1");
      expect(tempCustomFormField.options![1].items.length, 2);
      expect(tempCustomFormField.options![1].selectedItems.length, 1);
      expect(tempCustomFormField.options![1].selectedItems[0].id, "3");
      expect(tempCustomFormField.options![2].items.length, 3);
      expect(tempCustomFormField.options![2].selectedItems.length, 2);
      expect(tempCustomFormField.options![2].selectedItems[0].id, "4");
      expect(tempCustomFormField.options![2].selectedItems[1].id, "6");
    });

    test('Handles null additionData without errors', () {
      final options = [
        CustomFormFieldOption(id: 0, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "1", label: '', isSelect: true)]),
        CustomFormFieldOption(id: 1, controller: JPInputBoxController(), items: [
          JPMultiSelectModel(id: "2", label: '', isSelect: false),
          JPMultiSelectModel(id: "3", label: '', isSelect: true, additionData: null),
        ]),
        CustomFormFieldOption(id: 2, controller: JPInputBoxController(), items: [
          JPMultiSelectModel(id: "4", label: '', isSelect: true, additionData: [1]),
          JPMultiSelectModel(id: "5", label: '', isSelect: false, additionData: [2]),
          JPMultiSelectModel(id: "6", label: '', isSelect: true, additionData: [3]),
        ]),
      ];

      tempCustomFormField.options = options;

      expect(() => tempCustomFormField.removeDropdownItems(0), returnsNormally);
    });

    test('Does not remove items when index is greater than or equal to 2', () {
      final options = [
        CustomFormFieldOption(id: 0, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "1", label: '', isSelect: true)]),
        CustomFormFieldOption(id: 1, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "2", label: '', isSelect: false)]),
        CustomFormFieldOption(id: 2, controller: JPInputBoxController(), items: [
          JPMultiSelectModel(id: "2", label: '', isSelect: true, additionData: 1),
          JPMultiSelectModel(id: "3", label: '', isSelect: false, additionData: 2),
          JPMultiSelectModel(id: "4", label: '', isSelect: false, additionData: 3),
        ]
        ),
        CustomFormFieldOption(id: 9, controller: JPInputBoxController(), items: [JPMultiSelectModel(id: "2", label: '', isSelect: false)]),
      ];

      tempCustomFormField.options = options;

      tempCustomFormField.removeDropdownItems(2);

      expect(tempCustomFormField.options![2].items.length, 3);
      expect(tempCustomFormField.options![2].selectedItems.length, 1);
      expect(tempCustomFormField.options![2].selectedItems[0].id, "2");
    });
  });
}