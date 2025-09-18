import 'dart:ui';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/templates/handwritten/page.dart';
import 'package:jobprogress/common/repositories/user.dart';
import 'package:jobprogress/common/services/email/handle_db_elements.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/templates.dart';
import 'package:jobprogress/core/constants/templates/classes.dart';
import 'package:jobprogress/core/constants/templates/functions.dart';
import 'package:jobprogress/core/constants/templates/size.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/template_editor/controller.dart';

class HandwrittenTemplateEditorController extends JPTemplateEditorController {

  HandwrittenTemplateEditorController({
    this.job,
    this.templatePage,
    this.pageType,
    this.isSavingForm = false,
  });

  JobModel? job; // helps in storing job details to fill out db elements
  HandwrittenTemplatePageModel? templatePage; // holds template data
  String? pageType; // used to set the page size of template
  bool isSavingForm;

  String jobName = ""; // holds the job name

  late Size editorSize; //  helps in manging the editor size
  late double aspectRatio; // helps in managing the frame size

  @override
  void onInit() {
    setUpEditorDimensions();
    super.onInit();
  }

  @override
  void onWebViewInitialized() {
    //Initial delay to avoid animation lags
    initTemplate();
    super.onInit();
  }

  void setUpEditorDimensions() {
    bool isA4Page = pageType == TemplateConstants.a4page;
    editorSize = isA4Page ? TemplateFormSize.a4 : TemplateFormSize.legal;
    aspectRatio = isA4Page ? TemplateFormSize.a4AspectRatio : TemplateFormSize.legalAspectRatio;
  }

  @override
  void onElementTapped(int index, String className) {}

  // [initTemplate] sets up template and it's data
  Future<void> initTemplate() async {
    try {
      html = templatePage?.content ?? "";

      await setHtmlContent();
      // filling in HTML elements
      await fillHtmlElements();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Network Calls -----------------------------------------------------------

  // [getSignature] helps in loading user signature and returns base64 string to fill in data
  Future<String?> getSignature(int? id) async {
    if (id == null) return null;

    try {
      final params = {"user_ids[]": id};
      final response = await UserRepository.viewSignature<String>(params, rawSignature: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// HTML Content Updaters -----------------------------------------------

  Future<void> setHtmlContent() async {
    scaleContent(scale: '1');
    await setHtml(pageType: pageType ?? "");
  }

  Future<void> fillHtmlElements() async {
    // hiding page end arrows
    executeJs(TemplateFunctionConstants.hidePageEnding);
    // filling in DB elements
    addDBElements();
    // filling in signatures
    await fillInSignature();
    // inserting toggles in HTML
    await setInitialHtml();
  }

  // [addDBElements] reads HTML content and fills in data elements
  void addDBElements() {
    String functionString = EmailDbElementService.setSoucreString(
      customer: job?.customer,
      job: job,
      content: html,
      type: DbElementType.formProposal,
    );
    webViewController?.evaluateJavascript(source: functionString);
  }

  // [fillInSignature] fills in signature elements with corresponding signatures
  Future<void> fillInSignature() async {
    // extracting necessary id's from job data
    int? jobEstimatorId = !Helper.isValueNullOrEmpty(job?.estimators) ? job!.estimators!.first.id : null;
    int? customerRepId = job?.customer?.rep != null ? job!.customer!.rep!.id : null;

    // binding signature (base64) with class name
    Map<String, dynamic> signaturesToFillIn = {
      TemplateClassConstants.jpSignatureJobEstimator : await getSignature(jobEstimatorId),
      TemplateClassConstants.jpSignatureCustomerRep : await getSignature(customerRepId)
    };

    // removing nullable or empty data
    signaturesToFillIn.removeWhere((key, value) => Helper.isValueNullOrEmpty(value));

    // filling in HTML elements with signature data
    signaturesToFillIn.forEach((key, signature) async {
      updateSignatureElement(signature, className: key);
    });
  }

  // [updateSignatureElement] updates signature HTML elements
  void updateSignatureElement(String signature, {String? className}) {
    if (signature.isEmpty) return;

    String date = DateTimeHelper.formatDate(DateTimeHelper.now().toString(), DateFormatConstants.dateOnlyFormat);

    executeJs(TemplateFunctionConstants.fillSignature, args: {
      "index": className == null ? selectedIndex : 0,
      "className": className ?? selectedClassName,
      "signature": signature,
      "date": date
    });
  }

}