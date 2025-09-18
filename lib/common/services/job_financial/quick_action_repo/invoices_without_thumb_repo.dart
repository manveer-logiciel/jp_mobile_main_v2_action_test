import 'package:get/get_utils/src/extensions/export.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:url_launcher/url_launcher.dart';


class JobFinancialInvoicesWithoutThumbQuickActionRepo{

  static Future<void> print({required String url}) async {     
    String fileName = '${FileHelper.getFileName(url)}.pdf';
    await DownloadService.downloadFile(
      url,
      fileName,
      action: 'print',
    );
  }
  
  static Future<void> downloadView({required String url}) async {     
    String fileName = '${FileHelper.getFileName(url)}.pdf';
    await DownloadService.downloadFile(
      url, 
      fileName,
      action: 'open',
    );
  }

 static Future<void> downloadViewProposal({required String proposalUrl}) async {     
    String fileName = '${FileHelper.getFileName(proposalUrl)}.pdf';
    await DownloadService.downloadFile(
      proposalUrl, 
      fileName,
      action: 'open',
    );
  }

  static Future<dynamic> linkProposal({required int id , required int proposalId}) async { 
    final linkProposalParams = <String, dynamic>{
      'invoice_id': id,
      'proposal_id': proposalId,
      'include[0]': 'proposal',
    };
    await JobFinancialRepository().linkorUnlinkProposal(linkProposalParams);
    Helper.showToastMessage('proposal_linked'.tr);    
  }

   static Future<dynamic> unlinkProposal({required int id }) async { 
    final unlinkProposalParams = <String, dynamic>{
      'invoice_id': id,
      'proposal_id': null,
    };
    await JobFinancialRepository().linkorUnlinkProposal(unlinkProposalParams);
    Helper.showToastMessage('proposal_unlinked'.tr);    
  }

  static Future<dynamic> qbPay({required String shareUrl}) async { 
    final Uri url = Uri.parse(shareUrl);
    await launchUrl(url,mode: LaunchMode.externalApplication);
  }

  static Future<void> deleteInvoice({required String note, required String password, required int id}) async { 
    final deleteInvoiceParams = <String, dynamic>{
      'invoice_id': id,
      'password': password,
      'reason': note,
    };
    await JobFinancialRepository.removeFinancialInvoice(deleteInvoiceParams);
    Helper.showToastMessage('invoice_deleted'.tr);    
  }
}