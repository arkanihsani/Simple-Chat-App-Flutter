import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/chat_message.dart';

class ChatService {
  late WebSocketChannel _channel;
  final String username;
  final Function(ChatMessage) onMessage;

  ChatService({required this.username, required this.onMessage}) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.18.42:8080'),
    );

    _channel.sink.add(jsonEncode({
      "type": "join",
      "sender": username,
    }));

    _channel.stream.listen((data) {
      final msg = jsonDecode(data);
      onMessage(ChatMessage.fromJson(msg, username));
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _channel.sink.add(jsonEncode({
      "type": "chat",
      "sender": username,
      "message": text,
    }));
  }

  void dispose() {
    _channel.sink.close();
  }
}
