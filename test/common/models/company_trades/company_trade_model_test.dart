import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';

void main() {
  group('CompanyTradesModel.fromJson should parse id properly', () {
    test("In case id is not available, it should be null", () {
      final result = CompanyTradesModel.fromJson({});
      expect(result.id, null);
    });

    test("In case id is available, it should be parsed", () {
      final result = CompanyTradesModel.fromJson({
        "id": 1
      });
      expect(result.id, 1);
    });

    test("In case id is available with other data type, it should be parsed", () {
      final result = CompanyTradesModel.fromJson({
        "id": "1"
      });
      expect(result.id, 1);
    });

    test("In case id is available but is invalid, it should be null", () {
      final result = CompanyTradesModel.fromJson({
        "id": "invalid"
      });
      expect(result.id, null);
    });

    test("In case id is available but is null, it should be null", () {
      final result = CompanyTradesModel.fromJson({
        "id": null
      });
      expect(result.id, null);
    });
  });
}