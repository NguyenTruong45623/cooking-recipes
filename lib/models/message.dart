class Message {
  String messageId;
  Role role;
  StringBuffer message;
  List<String> imagesUrls;

  // constructor
  Message({
    required this.messageId,
    required this.role,
    required this.message,
    required this.imagesUrls,
  });

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'role': role.index,
      'message': message.toString(),
      'imagesUrls': imagesUrls,
    };
  }

  // from map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imagesUrls: List<String>.from(map['imagesUrls']),
    );
  }

  // copyWith
  Message copyWith({
    String? messageId,
    Role? role,
    StringBuffer? message,
    List<String>? imagesUrls,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      role: role ?? this.role,
      message: message ?? this.message,
      imagesUrls: imagesUrls ?? this.imagesUrls,
    );
  }
}

enum Role {
  user,
  assistant,
}
