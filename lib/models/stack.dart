import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stacker/utils/date_helper.dart';

class StackModel {
  String id;
  String shortId;
  String userId;
  String name;
  String address1;
  String address2;
  String city;
  int currentToken;
  String status;
  TimeOfDay openTime;
  TimeOfDay closeTime;
  double latitude;
  double longitude;
  String desc;
  String image;
  String userName;
  String userEmail;
  String userPhone;
  StackModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.address1,
    required this.address2,
    required this.city,
    required this.currentToken,
    required this.status,
    required this.openTime,
    required this.closeTime,
    required this.latitude,
    required this.longitude,
    required this.desc,
    required this.image,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.shortId,
  });

  StackModel copyWith({
    String? id,
    String? shortId,
    String? userId,
    String? name,
    String? address1,
    String? address2,
    String? city,
    int? currentToken,
    String? status,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    double? latitude,
    double? longitude,
    String? desc,
    String? image,
    String? userEmail,
    String? userName,
    String? userPhone,
  }) {
    return StackModel(
      id: id ?? this.id,
      shortId: shortId ?? this.shortId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      currentToken: currentToken ?? this.currentToken,
      status: status ?? this.status,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      desc: desc ?? this.desc,
      image: image ?? this.image,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
    );
  }

  void updateToken(int token) {
    currentToken = token;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'shortId': shortId,
      'name': name,
      'address1': address1,
      'address2': address2,
      'city': city,
      'currentToken': currentToken,
      'status': status,
      'openTime': DateHelper.convertTimeOfDayToPostgres(openTime),
      'closeTime': DateHelper.convertTimeOfDayToPostgres(closeTime),
      'latitude': latitude,
      'longitude': longitude,
      'desc': desc,
      'image': image,
      'userEmail': userEmail,
      'userName': userName,
      'userPhone': userPhone,
    };
  }

  factory StackModel.fromMap(Map<String, dynamic> map) {
    return StackModel(
      id: map['id'] ?? '',
      shortId: map['short_id'] ?? '',
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      address1: map['address_1'] ?? '',
      address2: map['address_2'] ?? '',
      city: map['city'] ?? '',
      currentToken: map['current_token']?.toInt() ?? 0,
      status: map['status'] ?? '',
      openTime: DateHelper.convertPostgresStringToTimeOfDay(map['open_time']),
      closeTime: DateHelper.convertPostgresStringToTimeOfDay(map['close_time']),
      latitude: map['location_lat']?.toDouble() ?? 0.0,
      longitude: map['location_lon']?.toDouble() ?? 0.0,
      desc: map['desc'] ?? '',
      image: map['image'] ?? '',
      userEmail: map['user_email'] ?? '',
      userName: map['user_name'] ?? '',
      userPhone: map['user_phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StackModel.fromJson(String source) =>
      StackModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Stack(id: $id, userId: $userId, name: $name, address1: $address1, address2: $address2, city: $city, currentToken: $currentToken, status: $status, openTime: $openTime, closeTime: $closeTime, latitude: $latitude, longitude: $longitude, desc: $desc, image: $image, userEmail: $userEmail, userName: $userName, userPhone: $userPhone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StackModel &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.city == city &&
        other.currentToken == currentToken &&
        other.status == status &&
        other.openTime == openTime &&
        other.closeTime == closeTime &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.desc == desc &&
        other.image == image &&
        other.userEmail == userEmail &&
        other.userName == userName &&
        other.userPhone == userPhone &&
        other.shortId == shortId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        city.hashCode ^
        currentToken.hashCode ^
        status.hashCode ^
        openTime.hashCode ^
        closeTime.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        desc.hashCode ^
        image.hashCode ^
        userEmail.hashCode ^
        userName.hashCode ^
        userPhone.hashCode ^
        shortId.hashCode;
  }
}
