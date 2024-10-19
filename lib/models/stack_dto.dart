import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacker/utils/date_helper.dart';

class StackDto {
  String userId;
  String name;
  String address1;
  String address2;
  String city;
  TimeOfDay openTime;
  TimeOfDay closeTime;
  double latitude;
  double longitude;
  String desc;
  String userName;
  String userEmail;
  String userPhone;
  StackDto({
    required this.userId,
    required this.name,
    required this.address1,
    required this.address2,
    required this.city,
    required this.openTime,
    required this.closeTime,
    required this.latitude,
    required this.longitude,
    required this.desc,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  StackDto copyWith({
    String? userId,
    String? name,
    String? address1,
    String? address2,
    String? city,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    double? latitude,
    double? longitude,
    String? desc,
    String? userName,
    String? userEmail,
    String? userPhone,
  }) {
    return StackDto(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      desc: desc ?? this.desc,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'open_time': DateHelper.convertTimeOfDayToPostgres(openTime),
      'close_time': DateHelper.convertTimeOfDayToPostgres(closeTime),
      'location': 'POINT($longitude $latitude)',
      'desc': desc,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'StackDto(userId: $userId, name: $name, address1: $address1, address2: $address2, city: $city, openTime: $openTime, closeTime: $closeTime, latitude: $latitude, longitude: $longitude, desc: $desc, userName: $userName, userEmail: $userEmail, userPhone: $userPhone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StackDto &&
        other.userId == userId &&
        other.name == name &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.city == city &&
        other.openTime == openTime &&
        other.closeTime == closeTime &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.desc == desc &&
        other.userName == userName &&
        other.userEmail == userEmail &&
        other.userPhone == userPhone;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        city.hashCode ^
        openTime.hashCode ^
        closeTime.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        desc.hashCode ^
        userName.hashCode ^
        userEmail.hashCode ^
        userPhone.hashCode;
  }
}
