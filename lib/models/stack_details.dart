import 'dart:convert';

class StackDetails {
  String? stackId;
  int averageDuration;
  int breakDuration;
  int maxTokens;
  bool manualAccept;
  StackDetails({
    this.stackId,
    required this.averageDuration,
    required this.breakDuration,
    required this.maxTokens,
    required this.manualAccept,
  });

  StackDetails.withoutId({
    required this.averageDuration,
    required this.breakDuration,
    required this.maxTokens,
    required this.manualAccept,
  });

  StackDetails copyWith({
    String? stackId,
    int? averageDuration,
    int? breakDuration,
    int? maxTokens,
    bool? manualAccept,
  }) {
    return StackDetails(
      stackId: stackId ?? this.stackId,
      averageDuration: averageDuration ?? this.averageDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      maxTokens: maxTokens ?? this.maxTokens,
      manualAccept: manualAccept ?? this.manualAccept,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stack_id': stackId,
      'avg_duration': averageDuration,
      'break_duration': breakDuration,
      'max_tokens': maxTokens,
      'manual_accept': manualAccept,
    };
  }

  factory StackDetails.fromMap(Map<String, dynamic> map) {
    return StackDetails(
      stackId: map['stack_id'] ?? '',
      averageDuration: map['avg_duration']?.toInt() ?? 0,
      breakDuration: map['break_duration']?.toInt() ?? 0,
      maxTokens: map['max_tokens']?.toInt() ?? 0,
      manualAccept: map['manual_accept'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory StackDetails.fromJson(String source) =>
      StackDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StackDetails(stackId: $stackId, averageDuration: $averageDuration, breakDuration: $breakDuration, maxTokens: $maxTokens, manualAccept: $manualAccept)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StackDetails &&
        other.stackId == stackId &&
        other.averageDuration == averageDuration &&
        other.breakDuration == breakDuration &&
        other.maxTokens == maxTokens &&
        other.manualAccept == manualAccept;
  }

  @override
  int get hashCode {
    return stackId.hashCode ^
        averageDuration.hashCode ^
        breakDuration.hashCode ^
        maxTokens.hashCode ^
        manualAccept.hashCode;
  }
}
