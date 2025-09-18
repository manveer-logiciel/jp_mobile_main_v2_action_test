import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/services/auth.dart';

/// Controller for managing the division selection in the worksheet.
///
/// This controller handles the logic for selecting a division from the job or a favourite division.
/// It updates the selected division and manages the state of the apply button.
class WorksheetDivisionSelectorController extends GetxController {

  /// The division model for the job.
  final DivisionModel? jobDivision;

  /// The division model for the favourite division.
  final DivisionModel? favouriteDivision;

  /// The ID of the currently selected division.
  int? selectedDivisionId;

  /// Constructor for initializing the controller with the job and favourite divisions.
  WorksheetDivisionSelectorController({
    this.jobDivision,
    this.favouriteDivision,
  });

  /// Returns true if the apply button should be disabled, false otherwise.
  bool get isApplyButtonDisabled => selectedDivisionId == null;

  /// [defaultDivision] helps in setting the data (address, email, phone) of the division
  /// by picking it up from the company details
  DivisionModel get defaultDivision => DivisionModel(
    phone: AuthService.userDetails?.companyDetails?.phone,
    email: AuthService.userDetails?.companyDetails?.email,
    addressString: AuthService.userDetails?.companyDetails?.address,
  );

  /// Handles the tap event on a division tile.
  ///
  /// Updates the selected division ID and refreshes the UI.
  ///
  /// Params:
  /// - [divisionId]: The ID of the tapped division.
  void onTapDivision(dynamic divisionId) {
    selectedDivisionId = divisionId;
    update();
  }

  /// Handles the tap event on the cancel button.
  ///
  /// Closes the dialog without applying any changes.
  void onTapCancel() {
    Get.back();
  }

  /// Handles the tap event on the apply button.
  ///
  /// Closes the dialog and returns the selected division.
  void onTapApply() {
    Get.back(result: getSelectedDivision());
  }

  /// Returns the selected division model based on the selected division ID.
  ///
  /// If the selected division ID matches the job division ID, returns the job division.
  /// Otherwise, returns the favourite division.
  DivisionModel? getSelectedDivision() {
    if (selectedDivisionId == jobDivision?.id) {
      return jobDivision;
    } else {
      return favouriteDivision;
    }
  }
}