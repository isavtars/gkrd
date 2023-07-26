import 'package:get/get.dart';
import 'package:gkrd/tools/Reminders/models/task_models.dart';
import 'package:gkrd/tools/Reminders/sql/sql_lite_helper.dart';

class TaskController extends GetxController {
  var taskList = <ReminderTask>[].obs;
  var taskbyid = <ReminderTask>[].obs;
//add to task
  Future<int> addToTask({required ReminderTask task}) {
    return SQLHelper.createTask(task);
  }

  //getTasks from users
  getTasks() async {
    List<Map<String, dynamic>> task = await SQLHelper.getItems();
    // reactive managers toassigned to list
    taskList
        .assignAll(task.map((data) => ReminderTask.fromJson(data)).toList());
  }

//delete by id
  deleteTask(ReminderTask task) {
    return SQLHelper.deleteItem(task);
  }

  //getitem by id;
  getTasksById(ReminderTask task) async {
    List<Map<String, dynamic>> taskis = await SQLHelper.getItem(task);
    // reactive managers toassigned to list
    taskbyid
        .assignAll(taskis.map((data) => ReminderTask.fromJson(data)).toList());
  }

  makeTaskCompleted(int id) {
    return SQLHelper.updateCompleted(id);
  }
}
