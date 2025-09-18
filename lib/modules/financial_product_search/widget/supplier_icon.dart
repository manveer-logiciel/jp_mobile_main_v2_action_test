import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';

import '../../../core/utils/helpers.dart';

class FinancialProductSupplierIcon extends StatelessWidget {
  const FinancialProductSupplierIcon({
    super.key,
    required this.product,
  });

  final FinancialProductModel product;

  @override
  Widget build(BuildContext context) {
    if (product.branchLogo != null) {
      return JPNetworkImage(
        src: product.branchLogo,
        height: 35,
        width: 70,
        placeHolder: Container(),
      );
    } else if (product.isBeaconProduct ?? false) {
      return Image.asset(
        AssetsFiles.qxoLogo,
        height: 22
      );
    } else if(Helper.isTrue(product.isAbcProduct)) {
      return Image.asset(
        AssetsFiles.abcLogo,
        height: 22,
      );
    }

    return const SizedBox();
  }
}
