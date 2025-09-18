import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/company_contacts_notes.dart';
import 'package:jobprogress/modules/company_contacts/detail/controller.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

void main() {
  final controller = CompanyContactViewController();
  List<dynamic> emailList = [];
  List<CompanyContactNoteModel> notes = [];
  test("Company Contacts view should be constructed with default values", () {
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.isNoteLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.email, '');
    expect(controller.emailList, emailList);
    expect(controller.fullName, '');
    expect(controller.firstLetterOfName, '');
    expect(controller.primeNumber, '');
    expect(controller.address, '');
    expect(controller.contactId, '');
    expect(controller.editNote, '');
    expect(controller.notes, notes);
    expect(controller.notesLength, 0);
    expect(controller.avatarColor, JPAppTheme.themeColors.warning);
  });

  test('Company Contacts view should loadMore used when api request for data', () {
    expect(controller.isLoadMore, false);
    expect(controller.noteListPage, 1);
  });
}
