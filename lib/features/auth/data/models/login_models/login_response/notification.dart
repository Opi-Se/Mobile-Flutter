import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String? message;
  final DateTime? date;
  final String? id;

  const Notification({this.message, this.date, this.id});

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        message: json['message'] as String?,
        date: json['date'] == null
            ? null
            : DateTime.parse(json['date'] as String),
        id: json['_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'date': date?.toIso8601String(),
        '_id': id,
      };

  @override
  List<Object?> get props => [message, date, id];
}
