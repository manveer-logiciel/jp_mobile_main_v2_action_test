import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/files_listing/srs/order_details.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jobprogress/modules/supplier_order_details/detail_tile/widgets/tracking_description_tile.dart';
import '../../../core/constants/order_status_constants.dart';
import '../controller.dart';
import 'shimmer.dart';
import 'widgets/bill_address_tile.dart';
import 'widgets/company_contact_tile.dart';
import 'widgets/invoice_detail.dart';
import 'widgets/po_detail_tile.dart';
import 'widgets/shipping_address_tile.dart';

class SrsOrderDetailView extends StatelessWidget {
  final SupplierOrderDetailController controller;
  const SrsOrderDetailView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if(controller.isLoading) {
      return const SrsOrderDetailViewShimmer();
    } else {
      SrsOrderDetailsModel? srsOrderDetail = controller.srsOrder?.orderDetails;
     return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SrsTrackingDetailTile(
              deliveryDate: controller.srsDeliveryDetail?.deliveryAt,
              expectedDeliveryDate: controller.srsDeliveryDetail?.expectedDeliveryDate,
              dateOrdered: controller.srsDeliveryDetail?.orderDate,
              trackingUrl: controller.trackingUrl,
              transactionNumber: controller.srsOrder?.orderId,
              isDeliveryCompleted: controller.srsOrder?.orderStatus == OrderStatusConstants.completed,
              onTapOfPdf: controller.downloadPdf,
            ),
            const SizedBox(height: 20),
            SRSCompanyContactTile(data : srsOrderDetail?.customerContactInfo),
            const SizedBox(height: 20),
            SRSShippingAddressTile(data : srsOrderDetail?.shipTo),
            const SizedBox(height: 20),
            SRSBillingAddressTile(data : srsOrderDetail?.billTo),
            const SizedBox(height: 20),
            SRSPoDetailTile(
              data : srsOrderDetail?.poDetails, 
              attachments:controller.srsOrder?.attachments,
            ),
            const SizedBox(height: 20),
            SRSInvoiceDetailTile(
              invoiceNumber: controller.srsOrder?.invoiceNumber,
              invoiceTotal: controller.srsInvoiceTotal,
              onTapOfAttachment: controller.onTapOfAttachment, 
            ),
            CustomMaterialCard(
              child: Visibility(
                visible: !Helper.isValueNullOrEmpty(controller.srsOrder?.attachments),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: JPAttachmentDetail(
                    paddingLeft: 14,
                    attachments: controller.srsOrder?.attachments ?? []
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }
 
  }
}
