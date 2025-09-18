import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/assets_files.dart';

class CustomerJobSourceTypeContent extends StatelessWidget {

  const CustomerJobSourceTypeContent({
    super.key,
    this.sourceType});

  final String? sourceType;
  
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: sourceType?.isNotEmpty ?? false,
      child: Column(
        children: [
          if(sourceType?.toLowerCase() == "zapier")
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: JPAvatar(
                  size: JPAvatarSize.small,
                  backgroundColor: JPAppTheme.themeColors.base,
                  borderWidth: 1,
                  child: Image.asset(AssetsFiles.zapierIcon, height: 22, width: 22,)
              ),
            ),

          if(sourceType?.toLowerCase() == "homeadvisor")
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: JPAvatar(
                  size: JPAvatarSize.small,
                  backgroundColor: JPAppTheme.themeColors.base,
                  borderWidth: 1,
                  child: Image.asset(AssetsFiles.homeAdvisorIcon)
              ),
            ),
        ],
      ),
    );
  }
}
