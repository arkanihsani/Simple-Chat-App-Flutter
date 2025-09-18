class ChatMessage {
  final String text;
  final String sender;
  final String type;
  final bool isMe;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.type,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUser) {
    return ChatMessage(
      text: json["message"] ?? "",
      sender: json["sender"] ?? "Unknown",
      type: json["type"] ?? "chat",
      isMe: json["sender"] == currentUser,
    );
  }
}
