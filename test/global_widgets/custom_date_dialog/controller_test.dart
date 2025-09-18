import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/files_listing/instant_photo_gallery_filter.dart';
import 'package:jobprogress/global_widgets/custom_date_dialog/controller.dart';

void main(){
  InstantPhotoGalleryFilterModel filters =InstantPhotoGalleryFilterModel();
  final controller = CustomDateController(filters);
  
  String value;

  test("CustomDateController should initilaized with these value ", (){
    expect(controller.isValidate, false);
  });
  
  group('Check validateStartDate function cases', () {
    test('Should return '' if enter a  value',() {
      value = controller.validateStartDate('22-3-2020');
      expect(value,'');
    });
    test('Should return please-provide_start_date if value is not provided',(){
      value = controller.validateStartDate('');
      expect(value,'please_provide_start_date');
    });

  });
  group('Check validateEndDate function cases', () {
    test('Should return '' if enter a  value',() {
      value = controller.validateEndDate('22-3-2020');
      expect(value,'');
    });
    test('Should return please_provide_end_date if value is not provided',(){
      value = controller.validateEndDate('');
      expect(value,'please_provide_end_date');
    });

  });

}