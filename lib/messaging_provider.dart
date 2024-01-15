// messaging_provider.dart
import 'package:flutter/material.dart';

class MessagingProvider extends ChangeNotifier {
  List<String> messages = [];

  void addMessage(String message) {
    messages.add(message);
    notifyListeners();
  }
}
