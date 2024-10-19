import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacker/models/stack.dart';
import 'package:stacker/utils/date_helper.dart';

class Booking {
  String id;
  int token;
  TimeOfDay timeArrival;
  String userId;
  String stackId;
  String status;
  DateTime creationTime;

  StackModel stacks;
  Booking({
    required this.id,
    required this.token,
    required this.timeArrival,
    required this.userId,
    required this.stackId,
    required this.status,
    required this.creationTime,
    required this.stacks,
  });

  Booking copyWith({
    String? id,
    int? token,
    TimeOfDay? timeArrival,
    String? userId,
    String? stackId,
    String? status,
    DateTime? creationTime,
    StackModel? stacks,
  }) {
    return Booking(
      id: id ?? this.id,
      token: token ?? this.token,
      timeArrival: timeArrival ?? this.timeArrival,
      userId: userId ?? this.userId,
      stackId: stackId ?? this.stackId,
      status: status ?? this.status,
      creationTime: creationTime ?? this.creationTime,
      stacks: stacks ?? this.stacks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
      'timeArrival': timeArrival,
      'userId': userId,
      'stackId': stackId,
      'status': status,
      'creationTime': creationTime,
      'stacks': stacks,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      token: map['token']?.toInt() ?? 0,
      timeArrival:
          DateHelper.convertPostgresStringToTimeOfDay(map['time_arrival']),
      userId: map['user_id'] ?? '',
      stackId: map['stack_id'] ?? '',
      status: map['status'] ?? '',
      creationTime: DateTime.parse(map['time_creation']),
      stacks: StackModel.fromMap(map['stacks']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) =>
      Booking.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Booking(id: $id, token: $token, timeArrival: $timeArrival, userId: $userId, stackId: $stackId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Booking &&
        other.id == id &&
        other.token == token &&
        other.timeArrival == timeArrival &&
        other.userId == userId &&
        other.stackId == stackId &&
        other.status == status &&
        other.creationTime == creationTime &&
        other.stacks == stacks;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        token.hashCode ^
        timeArrival.hashCode ^
        userId.hashCode ^
        stackId.hashCode ^
        status.hashCode ^
        creationTime.hashCode ^
        stacks.hashCode;
  }
}
