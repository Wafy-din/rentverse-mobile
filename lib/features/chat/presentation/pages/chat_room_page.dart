import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/chat/domain/entity/chat_message_entity.dart';
import 'package:rentverse/features/chat/presentation/cubit/chat_room/chat_room_cubit.dart';
import 'package:rentverse/features/chat/presentation/cubit/chat_room/chat_room_state.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.roomId,
    required this.otherUserName,
    required this.propertyTitle,
    required this.currentUserId,
    this.otherUserAvatar,
  });

  final String roomId;
  final String otherUserName;
  final String propertyTitle;
  final String currentUserId;
  final String? otherUserAvatar;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatRoomCubit(sl(), sl(), currentUserId: widget.currentUserId)
            ..init(widget.roomId),
      child: Builder(
        builder: (context) {
          return BlocListener<ChatRoomCubit, ChatRoomState>(
            listenWhen: (previous, current) =>
                previous.messages.length != current.messages.length,
            listener: (_, __) => _scrollToBottom(),
            child: Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.otherUserName, maxLines: 1),
                    Text(
                      widget.propertyTitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
                      builder: (context, state) {
                        if (state.status == ChatRoomStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.status == ChatRoomStatus.failure) {
                          return Center(
                            child: Text(
                              state.error ?? 'Gagal memuat pesan, coba lagi',
                            ),
                          );
                        }

                        final messages = state.messages;
                        if (messages.isEmpty) {
                          return const Center(
                            child: Text('Mulai percakapan pertama'),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return _MessageBubble(message: message);
                          },
                        );
                      },
                    ),
                  ),
                  _ChatInput(
                    controller: _controller,
                    onSend: (text) {
                      context.read<ChatRoomCubit>().sendMessage(text);
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final timeLabel = DateFormat('HH:mm').format(message.createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1CD8D2) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12).copyWith(
            bottomRight: Radius.circular(isMe ? 0 : 12),
            bottomLeft: Radius.circular(isMe ? 12 : 0),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeLabel,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black45,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            BlocBuilder<ChatRoomCubit, ChatRoomState>(
              builder: (context, state) {
                final disabled = state.sending;
                return IconButton(
                  onPressed: disabled
                      ? null
                      : () {
                          final text = controller.text.trim();
                          if (text.isNotEmpty) onSend(text);
                        },
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF1CD8D2),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
