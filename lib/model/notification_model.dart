import 'dart:convert';

class NotificationModel {
  final String id;
  final String visitorId;
  final String userId;
  final String securityId;
  final String notificationFor;
  String? acceptOrRejectBy;

  final DateTime createdAt;
  String updatedAt;
  // final EntryFormModel visitor;

  NotificationModel({
    required this.id,
    required this.visitorId,
    required this.userId,
    required this.securityId,
    required this.notificationFor,
    required this.createdAt,
    required this.updatedAt,
    // required this.visitor,
    this.acceptOrRejectBy,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['_id'],
        visitorId: json['visitorId'],
        userId: json['userId'],
        securityId: json['securityId'],
        notificationFor: json['notificationFor'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'],
        acceptOrRejectBy: json['acceptOrRejectBy'] ?? '');
//       visitor: json['visitor'] is String
//           ? EntryFormModel.fromJson(
//               jsonDecode(json['visitor']),
//             )
//           : EntryFormModel.fromJson(json['visitor']),
//     );
  }
}
