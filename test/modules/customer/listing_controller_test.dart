import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/customer/appointments.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/customer_list/customer_listing_filter.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/modules/customer/listing/controller.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final controller = CustomerListingController();

  final customer = CustomerModel(
    id: 1,
    jobsCount: 0,
    appointmentDate: '2023-01-01',
    appointments: CustomerAppointments(
      todayFirst: AppointmentModel(),
      upcomingFirst: AppointmentModel(),
    ),
    phones: [
      PhoneModel(number: '1234567890'),
    ],
  );

  final customerMeta = CustomerModel(
    id: 1,
    jobsCount: 5,
    appointmentDate: '2023-10-01',
    appointments: CustomerAppointments(
      todayFirst: AppointmentModel(),
      upcomingFirst: AppointmentModel(),
    ),
    phoneConsents: [
      PhoneConsentModel(
        phoneNumber: '1234567890',
        status: 'consented',
        createdAt: '2023-09-01',
        email: 'test@example.com',
      ),
    ],
  );

  test('CustomerListing@fetchCustomers should load customers from server with default/initial params', () {
    controller.fetchCustomers();
    expect(controller.filterKeys.page, 1);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.metaDataCount, 0);
  });

  test('CustomerListing@refresh should be called to refresh list without shimmer and interrupting filters', () {
    controller.refreshList();
    expect(controller.filterKeys.page, 1);
    expect(controller.isLoading, false);
  });

  test('CustomerListing@refresh, case refresh from main drawer and show shimmer - refresh() should be called with argument showShimmer as true', () {
    controller.refreshList(showShimmer: true);
    expect(controller.filterKeys.page, 1);
    expect(controller.isLoading, true);
  });

  test('CustomerListing@loadMore should be called to fetch more customer data from server', () {
    int currentPage = controller.filterKeys.page;
    controller.loadMore();
    expect(controller.filterKeys.page, ++currentPage);
    expect(controller.isLoading, true);
  });

  /////////////////////////////    SORT BY    //////////////////////////////////

  group("CustomerListing@applySortFilters", () {
    test('CustomerListing@applySortFilters should set filter-keys/request-params for created_at filter', () {
    controller.applySortFilters("created_at");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.isLoading, true);
  });

    test('CustomerListing@applySortFilters should set filter-keys/request-params for updated_at filter', () {
    controller.applySortFilters("updated_at");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.isLoading, true);
  });

    test('CustomerListing@applySortFilters should set filter-keys/request-params for last_name filter', () {
    controller.applySortFilters("last_name");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.isLoading, true);
  });

    test('CustomerListing@applySortFilters should set filter-keys/request-params for distance 1/4 mile filter', () {
    controller.location = Position(
        altitudeAccuracy: 10,
        headingAccuracy: 10,
        latitude: 30.7333, longitude: 76.7794, accuracy: 1, altitude: 0,
        speed: 0, speedAccuracy: 0, heading: 0, timestamp: DateTime.now());
    controller.applySortFilters("distance_0_25");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'distance');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0.25);
    expect(controller.isLoading, true);
  });

    test('CustomerListing@applySortFilters should set filter-keys/request-params for distance 1/2 mile filter', () {
    controller.location = Position(
        altitudeAccuracy: 10,
        headingAccuracy: 10,
        latitude: 30.7333, longitude: 76.7794, accuracy: 1, altitude: 0,
        speed: 0, speedAccuracy: 0, heading: 0, timestamp: DateTime.now());
    controller.applySortFilters("distance_0_5");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'distance');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0.5);
    expect(controller.isLoading, true);
  });

    test('CustomerListing@applySortFilters should set filter-keys/request-params for distance 1 mile filter', () {
    controller.location = Position(
        altitudeAccuracy: 10,
        headingAccuracy: 10,
        latitude: 30.7333, longitude: 76.7794, accuracy: 1, altitude: 0,
        speed: 0, speedAccuracy: 0, heading: 0, timestamp: DateTime.now());
    controller.applySortFilters("distance_1");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'distance');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 1);
    expect(controller.isLoading, true);
  });

    test('CustomerListing@applySortFilters should set filter-keys/request-params for distance 5 mile filter', () {
    controller.location = Position(
        altitudeAccuracy: 10,
        headingAccuracy: 10,
        latitude: 30.7333, longitude: 76.7794, accuracy: 1, altitude: 0,
        speed: 0, speedAccuracy: 0, heading: 0, timestamp: DateTime.now());
    controller.applySortFilters("distance_5");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'distance');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 5);
    expect(controller.isLoading, true);
  });

    test('CustomerListing@applySortFilters should set filter-keys/request-params for distance 10 mile filter', () {
    controller.location = Position(
        altitudeAccuracy: 10,
        headingAccuracy: 10,
        latitude: 30.7333, longitude: 76.7794, accuracy: 1, altitude: 0,
        speed: 0, speedAccuracy: 0, heading: 0, timestamp: DateTime.now());
    controller.applySortFilters("distance_10");
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'distance');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 10);
    expect(controller.isLoading, true);
  });
  });
  //////////////////////////////    FILTER    //////////////////////////////////

  group("CustomerListing@applyFilters", () {
    test("CustomerListing@applyFilters should set filter-params for 'assigned to' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      repIds: [244],
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.repIds, [244]);
    expect(controller.isLoading, true);
  });

    test("CustomerListing@applyFilters should set filter-params for 'name' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      name: "jaswinder",
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.name, "jaswinder");
    expect(controller.isLoading, true);
  });

    test("CustomerListing@applyFilters should set filter-params for 'phone no.' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      phone: "788848362",
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.phone, "788848362");
    expect(controller.isLoading, true);
  });

    test("CustomerListing@applyFilters should set filter-params for 'email' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      email: "jaswinder@gmax.cu.in",
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.email, "jaswinder@gmax.cu.in");
    expect(controller.isLoading, true);
  });

    test("CustomerListing@applyFilters should set filter-params for 'address' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      address: "1480 old",
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.address, "1480 old");
    expect(controller.isLoading, true);
  });

    test("CustomerListing@applyFilters should set filter-params for 'states' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      stateIds: [3,4],
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.stateIds, [3,4]);
    expect(controller.isLoading, true);
  });

    test("CustomerListing@applyFilters should set filter-params for 'zipCode' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      zipCode: "60070",
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.zipCode, "60070");
    expect(controller.isLoading, true);
  });

    test("CustomerListing@applyFilters should set filter-params for 'customerNote' to filter customers", () {
    CustomerListingFilterModel filterKeys = CustomerListingFilterModel(
      customerNote: "Ths is test",
    );
    controller.applyFilters(filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'created_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.customerNote, "Ths is test");
    expect(controller.isLoading, true);
  });
  });

  ///////////    SORT BY 'updated_at' WITH DIFFERENT FILTERS     ///////////////

  group("sort by 'updated_at' with different filters", () {
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'assigned to' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.repIds = [244];
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.repIds, [244]);
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'name' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.name = "Arun";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.name, "Arun");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'phone no.' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.phone = "788848362";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.phone, "788848362");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'email' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.email = "jaswinder@gmax.cu.in";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.email, "jaswinder@gmax.cu.in");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'address' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.address = "1480 old";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.address, "1480 old");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'states' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.stateIds = [3,4];
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.stateIds, [3,4]);
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'zipCode' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.zipCode = "60070";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.zipCode, "60070");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'updated_at' and 'customerNote' for filtering", () {
    controller.applySortFilters("updated_at");
    controller.filterKeys.customerNote = "Ths is test";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'updated_at');
    expect(controller.filterKeys.sortOrder, "desc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.customerNote, "Ths is test");
    expect(controller.isLoading, true);
  });
  });

  ////////////    SORT BY 'last_name' WITH DIFFERENT FILTERS     ///////////////

  group("sort by 'last_name' with different filters", () {
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'assigned' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.repIds = [244];
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.repIds, [244]);
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'name' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.name = "Arun";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.name, "Arun");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'phone no.' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.phone = "788848362";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.phone, "788848362");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'email' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.email = "jaswinder@gmax.cu.in";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.email, "jaswinder@gmax.cu.in");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'address' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.address = "1480 old";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.address, "1480 old");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'states' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.stateIds = [3,4];
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.stateIds, [3,4]);
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'zipCode' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.zipCode = "60070";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.zipCode, "60070");
    expect(controller.isLoading, true);
  });
    test("CustomerListing@applyFilters should set filter-keys/request-params to 'last_name' and 'customerNote' for filtering", () {
    controller.applySortFilters("last_name");
    controller.filterKeys.customerNote = "Ths is test";
    controller.applyFilters(controller.filterKeys);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortBy, 'last_name');
    expect(controller.filterKeys.sortOrder, "asc");
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.distance, 0);
    expect(controller.filterKeys.customerNote, "Ths is test");
    expect(controller.isLoading, true);
  });
  });

  test("CustomerListing@updateCustomerMeta should update customer details with Meta", () {
    controller.updateCustomerMeta(customer, customerMeta);
    expect(customer.jobsCount, 5);
    expect(customer.appointmentDate, '2023-10-01');
    expect(customer.appointments, customerMeta.appointments);
    expect(customer.phones![0].consentStatus, 'consented');
    expect(customer.phones![0].consentCreatedAt, '2023-09-01');
    expect(customer.phones![0].consentEmail, 'test@example.com');
  });
}