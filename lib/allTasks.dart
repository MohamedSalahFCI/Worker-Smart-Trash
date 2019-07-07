import 'package:a_smart_trash/properties.dart';

class AllTasks {
  final List<Properties> myData;

  AllTasks({
    this.myData,
  });

  factory AllTasks.fromJson(Map<String, dynamic> json) {
    return new AllTasks(
      myData:
          (json['data'] as List).map((e) => Properties.fromJson(e)).toList(),
    );
  }
}
