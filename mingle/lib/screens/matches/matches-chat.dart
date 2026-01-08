import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mingle/styles/Colors.dart';
import 'package:mingle/styles/widget-styles.dart';
import 'package:intl/intl.dart';

/// =======================
/// Message Model
/// =======================
class ChatMessageModel {
  final String id;
  final String content;
  final bool isMe;
  final MessageType type;
  final DateTime timestamp;
  final DateTime? dateTime; // optional for invites
  final String? location; // optional for invites
  final double? stake; // optional for invites
  final DateInviteStatus? inviteStatus; // null if not a date invite

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.isMe,
    required this.type,
    required this.timestamp,
    this.dateTime,
    this.location,
    this.stake,
    this.inviteStatus,
  });
}

enum MessageType { text, system, dateInvite }

enum DateInviteStatus { pending, accepted, declined }

/// =======================
/// Matches Chat Page
/// =======================
class MatchesChat extends StatefulWidget {
  final String matchName;
  final String matchAvatar;

  const MatchesChat({
    super.key,
    required this.matchName,
    required this.matchAvatar,
  });

  @override
  State<MatchesChat> createState() => _MatchesChatState();
}

class _MatchesChatState extends State<MatchesChat> {
  final TextEditingController _msgCtrl = TextEditingController();
  final List<ChatMessageModel> messages = [];

  @override
  void initState() {
    super.initState();

    /// Dating-app system intro
    messages.add(
      ChatMessageModel(
        id: _genId(),
        content: "✨ You matched with ${widget.matchName}!",
        isMe: false,
        type: MessageType.system,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessageModel(
          id: _genId(),
          content: text,
          isMe: true,
          type: MessageType.text,
          timestamp: DateTime.now(),
        ),
      );
    });

    _msgCtrl.clear();

    /// Fake reply for demo realism
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        messages.add(
          ChatMessageModel(
            id: _genId(),
            content: _autoReply(),
            isMe: false,
            type: MessageType.text,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  /// =======================
  /// Date Invite Feature
  /// =======================
  void _proposeDate() {
    final List<String> restaurants = [
      "Marina Bay Sands",
      "PS.Cafe",
      "Din Tai Fung",
      "Jamie’s Italian",
      "No Signboard Seafood",
      "Crystal Jade",
    ];

    String? selectedLocation = restaurants.first;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    double stake = 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Propose a Date",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // Dropdown for Location
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  items: restaurants
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setModalState(() {
                      selectedLocation = val!;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Date picker
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: selectedDate == null
                        ? "Select Date"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    border: const OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setModalState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Time picker
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: selectedTime == null
                        ? "Select Time"
                        : "${selectedTime!.format(context)}",
                    border: const OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setModalState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Spin box for stake (XRP)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Stake (XRP): ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove, size: 28),
                      onPressed: () {
                        setModalState(() {
                          if (stake > 0.01) stake -= 0.1;
                          stake = double.parse(stake.toStringAsFixed(2));
                        });
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: secondary, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        stake.toStringAsFixed(2), // 2 decimals
                        style: const TextStyle(
                          fontSize: 28, // bigger number
                          fontWeight: FontWeight.bold,
                          color: secondary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 28),
                      onPressed: () {
                        setModalState(() {
                          stake += 0.1;
                          stake = double.parse(stake.toStringAsFixed(2));
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (selectedLocation == null || selectedDate == null || selectedTime == null) return;

                    final combinedDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );

                    setState(() {
                      messages.add(
                        ChatMessageModel(
                          id: _genId(),
                          content:
                              "📅 Date proposed: $selectedLocation at ${selectedTime!.format(context)}, Stake: ${stake.toStringAsFixed(1)} XRP",
                          isMe: true,
                          type: MessageType.dateInvite,
                          timestamp: DateTime.now(),
                          location: selectedLocation,
                          dateTime: combinedDateTime,
                          inviteStatus: DateInviteStatus.pending,
                        ),
                      );
                    });

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Send Proposal",
                    style: TextStyle(
                      color: secondary, // text color to stand out on white
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _respondToDateInvite(int index, DateInviteStatus status) {
    setState(() {
      messages[index] = ChatMessageModel(
        id: messages[index].id,
        content: messages[index].content,
        isMe: messages[index].isMe,
        type: messages[index].type,
        timestamp: messages[index].timestamp,
        location: messages[index].location,
        dateTime: messages[index].dateTime,
        stake: messages[index].stake,
        inviteStatus: status,
      );

      // Add system message
      messages.add(ChatMessageModel(
        id: _genId(),
        content: status == DateInviteStatus.accepted
            ? "✅ You accepted the date invite!"
            : "❌ You declined the date invite.",
        isMe: false,
        type: MessageType.system,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.matchAvatar),
            ),
            const SizedBox(width: 10),
            Text(
              widget.matchName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _proposeDate,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                if (msg.type == MessageType.dateInvite &&
                    !msg.isMe &&
                    msg.inviteStatus == DateInviteStatus.pending) {
                  // show accept/decline buttons
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChatBubble(msg: msg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () =>
                                _respondToDateInvite(index, DateInviteStatus.accepted),
                            child: const Text("Accept"),
                          ),
                          TextButton(
                            onPressed: () =>
                                _respondToDateInvite(index, DateInviteStatus.declined),
                            child: const Text("Decline"),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return ChatBubble(msg: msg);
              },
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                decoration: textFieldDeco.copyWith(
                  hintText: "Send a message…",
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: secondary),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  String _genId() => Random().nextInt(9999999).toString();

  String _autoReply() {
    const replies = [
      "Haha that's cute 😂",
      "Tell me more 👀",
      "Omg same",
      "That sounds fun!",
      "I was thinking the same",
      "You’re funny ngl",
    ];
    return replies[Random().nextInt(replies.length)];
  }
}

/// =======================
/// Chat Bubble Widget
/// =======================
class ChatBubble extends StatelessWidget {
  final ChatMessageModel msg;

  const ChatBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    if (msg.type == MessageType.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            msg.content,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? secondary : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: msg.isMe ? secondary : const Color(0xFFD4C6FD),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.content,
              style: TextStyle(
                color: msg.isMe ? Colors.white : Colors.black,
              ),
            ),
            if (msg.type == MessageType.dateInvite && msg.inviteStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  msg.inviteStatus == DateInviteStatus.pending
                      ? "⏳ Pending"
                      : msg.inviteStatus == DateInviteStatus.accepted
                          ? "✅ Accepted"
                          : "❌ Declined",
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: msg.inviteStatus == DateInviteStatus.accepted
                        ? Colors.green
                        : msg.inviteStatus == DateInviteStatus.declined
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
              ),
            if (msg.stake != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  "Stake: ${msg.stake} XRP",
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
