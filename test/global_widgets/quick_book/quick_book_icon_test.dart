import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/global_widgets/quick_book/index.dart';

void main() {

  Map<String, dynamic> quickBookList = {'quickbook': {'quickbook_company_id': 1, 'only_one_way_sync': false}, 'quickbook_pay': {'quickbooks_payments_connected': 0}, 'quickbook_desktop': false, 'quickmeasure': {'quickmeasure_account_id': 'gigi@gaf-uattigerteamroofing.com'}};
  
  Map<String, dynamic> quickBookListNull = {'quickbook': null, 'quickbook_pay': null, 'quickbook_desktop': false, 'quickmeasure': {'quickmeasure_account_id': 'gigi@gaf-uattigerteamroofing.com'}};

  const defaultQuickBookIcon = QuickBookIcon();

  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(home: Material(child: widget)));
  }

  testWidgets("QuickBookIcon widget must be found", (WidgetTester tester) async {
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
    await tester.pumpWidget(buildTestableWidget(defaultQuickBookIcon));
    expect(find.byWidget(defaultQuickBookIcon), findsOneWidget);
  });

  
  test("QuickBookIcon Should be constructed with default values", () {
    expect(defaultQuickBookIcon.height, 24);
    expect(defaultQuickBookIcon.width, 24);
    expect(defaultQuickBookIcon.ghostJob, null);
    expect(defaultQuickBookIcon.isSyncDisable, null);
    expect(defaultQuickBookIcon.origin, null);
    expect(defaultQuickBookIcon.quickbookId, null);
    expect(defaultQuickBookIcon.qbDesktopId, null);
    expect(defaultQuickBookIcon.status, null);    
  });

  test('QuickBookIcon@getPath should return qb-no-synced image if status is not given', () {

    ConnectedThirdPartyService.setConnectedParty(quickBookList);

    String? statusIcon = defaultQuickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-no-synced.png');
  });

  test('QuickBookIcon@getPath should return qb-process.png image if status = 0', () { 

    ConnectedThirdPartyService.setConnectedParty(quickBookList);
    
    const quickBookIcon =  QuickBookIcon(status: '0');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-process.png');
  });

  test('QuickBookIcon@getPath should return qb-process.png image if qbDesktopId = 1 and status = 0', () { 
    
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
    
    const quickBookIcon =  QuickBookIcon(qbDesktopId: '1', quickbookId: null, status: '0');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-process.png');
  });

  test('QuickBookIcon@getPath should return qb-process.png image if quickbookId = 1 and status = 0', () { 
    
    ConnectedThirdPartyService.setConnectedParty(quickBookList);

    const quickBookIcon =  QuickBookIcon(qbDesktopId: null, quickbookId: '1', status: '0');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-process.png');
  });

  test('QuickBookIcon@getPath should return qb.png image if status = 1', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(status: '1');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb.png');
  });

  test('QuickBookIcon@getPath should return qb.png image if qbDesktopId = 1 and status = 1', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);

    const quickBookIcon =  QuickBookIcon(qbDesktopId: '1', quickbookId: null, status: '1');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb.png');
  });

test('QuickBookIcon@getPath should return qb.png image if quickbookId = 1 and status = 1', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);

    const quickBookIcon =  QuickBookIcon(qbDesktopId: null, quickbookId: '1', status: '1');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb.png');
  });

test('QuickBookIcon@getPath should return qb-warning.png image if qbDesktopId = 1 and status = 2', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(qbDesktopId: '1', quickbookId: null, status: '2');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-warning.png');
  });

test('QuickBookIcon@getPath should return qb-warning.png image if status = 2', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(status: '2');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-warning.png');
  });

test('QuickBookIcon@getPath should return qb-ghost.png image if ghostJob = 1', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(ghostJob: '1');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-ghost.png');
  });

  test('QuickBookIcon@getPath should return qb-ghost.png image if qbDesktopId = 1 and ghostJob = 1', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(qbDesktopId: '1', quickbookId: null , ghostJob: '1');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-ghost.png');
  });

  test('QuickBookIcon@getPath should return qb-ghost.png image if quickbookId = 1 and ghostJob = 1', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(qbDesktopId: null, quickbookId: '1' , ghostJob: '1');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-ghost.png');
  });

   test('QuickBookIcon@getPath should return jp-qb.png image if origin = JobProgress', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(quickbookId: '1', origin: 'JobProgress');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/jp-qb.png');
  });

    test('QuickBookIcon@getPath should return qb-no-synced.png image if origin = QuickBookDesktop', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(origin: 'QuickBookDesktop');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-no-synced.png');
  });

  test('QuickBookIcon@getPath should return qb-no-synced.png image if qbDesktopId = 1 and origin = QuickBooks', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(qbDesktopId: '1', origin: 'QuickBooks');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-no-synced.png');
  });

  test('QuickBookIcon@getPath should return jp-qb.png image if quickbookId = 1 and origin = QuickBookDesktop', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(status: '1', quickbookId: '1', origin: 'QuickBookDesktop');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/jp-qb.png');
  });

  
  test('QuickBookIcon@getPath should return qb-jp.png image if quickbookId = 1 and origin = QuickBooks', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(status: '1', quickbookId: '1', origin: 'QuickBooks');

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, 'assets/images/qb/qb-jp.png');
  });

  test('QuickBookIcon@getPath should return null image if isSyncDisable = 1', () { 
  
    ConnectedThirdPartyService.setConnectedParty(quickBookList);
  
    const quickBookIcon =  QuickBookIcon(isSyncDisable: 1);

    String? statusIcon = quickBookIcon.getPath();

    expect(statusIcon, null);
  });

  test('QuickBookIcon@getPath should return null if quickBook is not connected', () {
    
    ConnectedThirdPartyService.setConnectedParty(quickBookListNull);

    String? statusIcon = defaultQuickBookIcon.getPath();

    expect(statusIcon, null);
  });
}
