import 'package:get/get.dart';
import 'package:gkrd/logic/reminder_task_controller.dart';

import '../themes_changer.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemModeChange());
    Get.put(TaskController());
    // Get.put(UserController());
  }
}
