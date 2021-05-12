import 'package:glider/model/chat/ChatModel.dart';
import 'package:glider/state/BaseState.dart';

class ChatState extends BaseState {
  final ChatModel chat;
  final String threadId;

  ChatState(this.chat, this.threadId);
}
