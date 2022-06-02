import 'package:equatable/equatable.dart';

import 'package:handover/core/enums.dart';

class UserData extends Equatable {
  final String id;
  final String fullName;
  final AccountType accountType;
  final List tokens;

  UserData({
    required this.id,
    required this.fullName,
    required this.accountType,
    this.tokens = const [],
  });

  @override
  List<Object> get props => [id, fullName, accountType];

  UserData copyWith({
    String? id,
    String? fullName,
    AccountType? accountType,
    List? tokens,
  }) {
    return UserData(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      accountType: accountType ?? this.accountType,
      tokens: tokens ?? this.tokens,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'accountType': accountType.name,
      'tokens': tokens,
    };
  }

  factory UserData.fromJson(Map map) {
    return UserData(
      id: map['id'],
      fullName: map['fullName'],
      accountType: AccountType.values
          .firstWhere((value) => value.name == map['accountType']),
      tokens: map['tokens'],
    );
  }
}
