import 'package:get/get.dart';

import '../themes_changer.dart';


class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemModeChange());
    // Get.put(UserController());
  }
}
