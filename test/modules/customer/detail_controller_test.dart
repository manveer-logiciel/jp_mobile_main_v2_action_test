import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/customer/details/controller.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final controller = CustomerDetailController();

  test('fetchCustomer used when api request for customer data', () {
    controller.fetchCustomer(id: 30622);
    expect(controller.isLoading, true);
  });
  test('CustomerDetailController@getQueryParams should return correct query parameters map for given ID', () {
    int customerId = 123;
    
    Map<String, dynamic> result = controller.getQueryParams(customerId);

    Map<String, dynamic> expected = {
      "includes[0]": "address",
      "includes[1]": "billing",
      "includes[2]": "phones",
      "includes[3]": "rep",
      "includes[4]": "referred_by",
      "includes[5]": "flags",
      "includes[6]": "contacts",
      "includes[7]": "custom_fields.options.sub_options",
      "includes[8]": "canvasser",
      "includes[9]": "call_center_rep",
      "includes[10]": "flags.color",
      "includes[11]" : "appointments",
      "includes[12]" : "custom_fields.users",
      "id": customerId
    };

    expect(result, equals(expected));
  });
}
