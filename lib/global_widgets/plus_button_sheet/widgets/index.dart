import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/job/job.dart';
import 'tile.dart';

class JPPlusButtonSheet extends StatelessWidget {
  const JPPlusButtonSheet({
    super.key,
    required this.onTapOption,
    required this.options,
    this.job,
    required  void Function(String action) onActionComplete,
    this.hasFourColumnInTablet = false,
  });

  final Function(String) onTapOption;
  final JobModel? job;
  final List<JPQuickActionModel> options;
  final bool hasFourColumnInTablet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(20),
      child: JPSafeArea(
        child: Container(
          constraints: BoxConstraints(maxHeight: JPScreen.height * 0.56),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(JPScreen.isMobile ? 20 : 30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:  hasFourColumnInTablet ? (JPScreen.isMobile ? 3 : 4) : 3,
                crossAxisSpacing: JPScreen.isMobile ? 10 : 15,
                mainAxisSpacing: JPScreen.isMobile ? 10 : 15,
                childAspectRatio: JPScreen.isMobile ? 1.2 : hasFourColumnInTablet ? 1.2 : 1.5,
              ),
              itemCount: options.length,
              itemBuilder: (_, index) {
                return JPPlusButtonSheetTile(
                  key: Key(options[index].label),
                  data: options[index],
                  onTap: () {
                    onTapOption.call(options[index].id);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
