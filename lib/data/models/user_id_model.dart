const String userIdsTable = 'user_ids';

class UserIdFields {
  static final List<String> values = [userId];

  static const String userId = 'user_id';
}

class UserIdModel {
  final String? userId;

  const UserIdModel({this.userId});

  Map<String, Object?> toJson() => {
    UserIdFields.userId: userId,
  };

  static UserIdModel fromJson(Map<String, dynamic> json) => UserIdModel(
    userId: json[UserIdFields.userId]?.toString(),
  );

  UserIdModel copy({String? userId}) => UserIdModel(
    userId: userId ?? this.userId,
  );
}
