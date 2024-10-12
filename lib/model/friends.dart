class Friend {
  final String id;
  final String name;
  final DateTime birthday;
  final List<ImportantDate> importantDates;
  final List<InteractionLog> interactionLog;

  Friend({
    required this.id,
    required this.name,
    required this.birthday,
    required this.importantDates,
    required this.interactionLog,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['_id'],
      name: json['name'],
      birthday: DateTime.parse(json['birthday']),
      importantDates: (json['importantDates'] as List)
          .map((item) => ImportantDate.fromJson(item))
          .toList(),
      interactionLog: (json['interactionLog'] as List)
          .map((item) => InteractionLog.fromJson(item))
          .toList(),
    );
  }
}

class ImportantDate {
  final String title;
  final DateTime date;

  ImportantDate({required this.title, required this.date});

  factory ImportantDate.fromJson(Map<String, dynamic> json) {
    return ImportantDate(
      title: json['title'],
      date: DateTime.parse(json['date']),
    );
  }
}

class InteractionLog {
  final String type;
  final DateTime date;

  InteractionLog({required this.type, required this.date});

  factory InteractionLog.fromJson(Map<String, dynamic> json) {
    return InteractionLog(
      type: json['type'],
      date: DateTime.parse(json['date']),
    );
  }
}
