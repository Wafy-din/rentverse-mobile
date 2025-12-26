import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/features/chat/domain/entity/chat_message_entity.dart';
import 'package:rentverse/features/chat/presentation/cubit/chat_room/chat_room_cubit.dart';
import 'package:rentverse/features/chat/presentation/cubit/chat_room/chat_room_state.dart';
import 'package:rentverse/features/chat/presentation/cubit/chat_room_view/cubit.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatRoomView extends StatelessWidget {
  const ChatRoomView({
    super.key,
    required this.otherUserName,
    required this.propertyTitle,
    this.otherUserAvatar,
  });

  final String otherUserName;
  final String propertyTitle;
  final String? otherUserAvatar;

  @override
  Widget build(BuildContext context) {
    final viewState = context.watch<ChatRoomViewCubit>().state;
    final viewCubit = context.read<ChatRoomViewCubit>();

    return BlocListener<ChatRoomCubit, ChatRoomState>(
      listenWhen: (previous, current) =>
          previous.messages.length != current.messages.length,
      listener: (_, __) => viewCubit.scrollToBottom(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              _InitialAvatar(name: otherUserName),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(otherUserName, maxLines: 1),
                    Text(
                      propertyTitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)]))])),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
                builder: (context, state) {
                  if (state.status == ChatRoomStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ChatRoomStatus.failure) {
                    return Center(
                      child: Text(
                        state.error ?? 'Gagal memuat pesan, coba lagi'));
                  }

                  final messages = state.messages;
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('Mulai percakapan pertama'));
                  }

                  final items = _buildChatItems(messages);

                  return ListView.builder(
                    controller: viewState.scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      if (item.isHeader) {
                        return _DateHeader(date: item.headerDate!);
                      }
                      return _MessageBubble(
                        message: item.message!,
                        otherUserName: otherUserName,
                        selfName: 'You');
                    });
                })),
            _ChatInput(
              controller: viewState.controller,
              onSend: (text) {
                context.read<ChatRoomCubit>().sendMessage(text);
                viewCubit.clearInput();
              })])));
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.otherUserName,
    required this.selfName,
  });

  final ChatMessageEntity message;
  final String otherUserName;
  final String selfName;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final timeLabel = DateFormat('HH:mm').format(message.createdAt);

    const bubbleColor = Color(0xFFE8F5FF);
    final textColor = Colors.black87;
    final radius = BorderRadius.circular(16);

    String initialFor(bool me) {
      final source = me ? selfName : otherUserName;
      return source.isNotEmpty ? source[0].toUpperCase() : '?';
    }

    Widget avatar(String initial) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey.shade300,
        child: Text(initial, style: const TextStyle(color: Colors.black87)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) avatar(initialFor(false)),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: isMe
                    ? radius.copyWith(topRight: Radius.circular(0))
                    : radius.copyWith(topLeft: Radius.circular(0))),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.3)),
                  const SizedBox(height: 4),
                  Text(
                    timeLabel,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11))]))),
          if (isMe) const SizedBox(width: 8),
          if (isMe) avatar(initialFor(true))]));
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey.shade300,
      child: Text(initial, style: const TextStyle(color: Colors.black87)));
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;
    final label = isToday ? 'Today' : DateFormat('dd MMM yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12)),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54)))));
  }
}

class _ChatListItem {
  final ChatMessageEntity? message;
  final DateTime? headerDate;
  final bool isHeader;

  _ChatListItem.header(this.headerDate) : message = null, isHeader = true;

  _ChatListItem.message(this.message) : headerDate = null, isHeader = false;
}

List<_ChatListItem> _buildChatItems(List<ChatMessageEntity> messages) {
  if (messages.isEmpty) return [];
  final sorted = List<ChatMessageEntity>.from(messages)
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  final items = <_ChatListItem>[];
  DateTime? currentDay;

  for (final msg in sorted) {
    final day = DateTime(
      msg.createdAt.year,
      msg.createdAt.month,
      msg.createdAt.day);
    if (currentDay == null || day.isAfter(currentDay)) {
      currentDay = day;
      items.add(_ChatListItem.header(day));
    }
    items.add(_ChatListItem.message(msg));
  }

  return items;
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
                    borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10)))),
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
                  icon: Icon(LucideIcons.send),
                  color: const Color(0xFF1CD8D2));
              })])));
  }
}
