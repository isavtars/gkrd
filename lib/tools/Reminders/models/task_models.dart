class ReminderTask {
  final int? id;
  final String title, date, startTime, note;
  final String reminder;

  final int? isComplited;

  ReminderTask(
      {required this.title,
      required this.note,
      required this.date,
      required this.startTime,
      required this.reminder,
      this.id,
      this.isComplited});

  //to jsons
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "note": note,
        "date": date,
        "startTime": startTime,
        "reminder": reminder,
        "isComplited": isComplited
      };

// jsonsDecodes
  factory ReminderTask.fromJson(Map<String, dynamic> map) {
    return ReminderTask(
        id: map['id'],
        title: map['title'],
        note: map['note'],
        date: map['date'],
        startTime: map['startTime'],
        reminder: map['reminder'],
        isComplited: map['isComplited']);
  }
}
