
import 'package:get/get.dart';

class JPBottomSheetController extends GetxController{

  bool isLoading = false;

  bool switchValue = false;

  toggleIsLoading(){
    isLoading = !isLoading;
    update();
  }

  toggleSwitchValue(bool val){
    switchValue = val;
    update();
  }

}