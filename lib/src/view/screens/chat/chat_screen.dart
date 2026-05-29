import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rinex/src/controller/firebase_services/chat_services.dart';
import 'package:rinex/src/view/screens/chat/contact_masking.dart';

const _kPrimary = Color(0xFF1A6FE8);
const _kPrimaryLight = Color(0xFFE8F0FD);
const _kBg = Color(0xFFF4F7FE);
const _kWhite = Colors.white;
const _kTextDark = Color(0xFF0D1B3E);
const _kTextMid = Color(0xFF8A9BB5);
const _kDivider = Color(0xFFEDF1F9);

// ─────────────────────────────────────────────────────────────────────────────
// INBOX PAGE
// ─────────────────────────────────────────────────────────────────────────────

class ChatInboxPage extends StatelessWidget {
  const ChatInboxPage({super.key});

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kWhite,
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Messages',
              style: TextStyle(
                color: _kTextDark,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Your conversations',
              style: TextStyle(color: _kTextMid, fontSize: 12),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _kDivider),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where('participants', arrayContains: _uid)
            .orderBy('lastMessageAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _kPrimary),
            );
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return _emptyInbox();
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _InboxTile(
              conversationId: docs[i].id,
              data: docs[i].data() as Map<String, dynamic>,
              currentUserId: _uid,
            ),
          );
        },
      ),
    );
  }

  Widget _emptyInbox() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: _kPrimaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: _kPrimary,
            size: 36,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No conversations yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _kTextDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Message a property owner to start chatting.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// INBOX TILE
// ─────────────────────────────────────────────────────────────────────────────

class _InboxTile extends StatelessWidget {
  final String conversationId;
  final Map<String, dynamic> data;
  final String currentUserId;

  const _InboxTile({
    required this.conversationId,
    required this.data,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final participants = List<String>.from(data['participants'] ?? []);
    final otherUserId = participants.firstWhere(
      (p) => p != currentUserId,
      orElse: () => '',
    );
    final lastMessage = data['lastMessage'] as String? ?? '';
    final propertyId = data['propertyId'] as String? ?? '';
    final ts = data['lastMessageAt'] as Timestamp?;

    final unreadStream = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .snapshots();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: conversationId,
            propertyId: propertyId,
            otherUserId: otherUserId,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _kPrimary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _Avatar(userId: otherUserId),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _UserName(userId: otherUserId)),
                      Text(
                        _relTime(ts),
                        style: const TextStyle(fontSize: 11, color: _kTextMid),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lastMessage.isEmpty ? 'Tap to start chatting' : lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StreamBuilder<QuerySnapshot>(
              stream: unreadStream,
              builder: (_, snap) {
                final count = snap.data?.docs.length ?? 0;
                if (count == 0)
                  return const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFB0BDD0),
                    size: 20,
                  );
                return Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: _kPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: _kWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _relTime(Timestamp? ts) {
    if (ts == null) return '';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 1) return 'Now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${ts.toDate().day}/${ts.toDate().month}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CHAT SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String propertyId;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.propertyId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _chatService = ChatService();
  bool _isSending = false;
  bool _showWarning = false;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final raw = _msgCtrl.text.trim();
    if (raw.isEmpty || _isSending) return;

    final sanitised = ContactMaskService.sanitise(raw);
    final hadContact = ContactMaskService.containsContact(raw);

    setState(() {
      _isSending = true;
      _showWarning = hadContact;
    });
    _msgCtrl.clear();

    try {
      await _chatService.sendMessage(
        conversationId: widget.conversationId,
        senderId: _uid,
        message: sanitised,
      );
      _scrollToBottom();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send: $e')));
    } finally {
      if (mounted) setState(() => _isSending = false);
      if (hadContact)
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) setState(() => _showWarning = false);
        });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _markRead(List<QueryDocumentSnapshot> docs) {
    for (final doc in docs) {
      final d = doc.data() as Map<String, dynamic>;
      if (d['senderId'] != _uid && d['read'] == false) {
        doc.reference.update({'read': true});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: _kTextDark,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            _Avatar(userId: widget.otherUserId, size: 38),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UserName(
                  userId: widget.otherUserId,
                  style: const TextStyle(
                    color: _kTextDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xFF34C759),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _kDivider),
        ),
      ),
      body: Column(
        children: [
          if (widget.propertyId.isNotEmpty) _propertyBanner(),
          if (_showWarning) _warningBanner(),
          Expanded(child: _messageList()),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _propertyBanner() => Container(
    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: _kPrimaryLight,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _kPrimary.withOpacity(0.15)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _kPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.home_outlined, color: _kWhite, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Property Inquiry',
                style: TextStyle(
                  color: _kPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'ID: ${widget.propertyId}',
                style: const TextStyle(color: Color(0xFF5A7DB5), fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _warningBanner() => Container(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF3CD),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFFFCC00).withOpacity(0.5)),
    ),
    child: const Row(
      children: [
        Icon(Icons.shield_outlined, color: Color(0xFFB8860B), size: 18),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Contact info detected and hidden to protect both parties.',
            style: TextStyle(
              color: Color(0xFF7A5800),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _messageList() => StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots(),
    builder: (context, snap) {
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator(color: _kPrimary));
      }
      final docs = snap.data?.docs ?? [];
      _markRead(docs);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      if (docs.isEmpty) return _emptyChat();
      return ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        itemCount: docs.length,
        itemBuilder: (_, i) {
          final d = docs[i].data() as Map<String, dynamic>;
          final isMe = d['senderId'] == _uid;
          final showDate =
              i == 0 ||
              _diffDay(
                (docs[i - 1].data() as Map)['createdAt'] as Timestamp?,
                d['createdAt'] as Timestamp?,
              );
          return Column(
            children: [
              if (showDate) _dateDivider(d['createdAt'] as Timestamp?),
              _Bubble(
                message: d['message'] ?? '',
                isMe: isMe,
                time: d['createdAt'] as Timestamp?,
                read: d['read'] as bool? ?? false,
              ),
            ],
          );
        },
      );
    },
  );

  bool _diffDay(Timestamp? a, Timestamp? b) {
    if (a == null || b == null) return false;
    final da = a.toDate(), db = b.toDate();
    return da.day != db.day || da.month != db.month || da.year != db.year;
  }

  Widget _dateDivider(Timestamp? ts) {
    final dt = ts?.toDate();
    final now = DateTime.now();
    final lbl = dt == null
        ? ''
        : dt.day == now.day
        ? 'Today'
        : dt.day == now.day - 1
        ? 'Yesterday'
        : '${dt.day}/${dt.month}/${dt.year}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              lbl,
              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _emptyChat() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: _kPrimaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.waving_hand_outlined,
            color: _kPrimary,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Say hello!',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _kTextDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ask anything about this property.',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ],
    ),
  );

  Widget _inputBar() => Container(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      top: 12,
      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
    ),
    decoration: BoxDecoration(
      color: _kWhite,
      boxShadow: [
        BoxShadow(
          color: _kPrimary.withOpacity(0.07),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: _kBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFDDE5F5)),
            ),
            child: TextField(
              controller: _msgCtrl,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 14, color: _kTextDark),
              decoration: InputDecoration(
                hintText: 'Type a message…',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _send,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isSending ? _kPrimary.withOpacity(0.6) : _kPrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _kPrimary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isSending
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: CircularProgressIndicator(
                      color: _kWhite,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send_rounded, color: _kWhite, size: 20),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// BUBBLE
// ─────────────────────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp? time;
  final bool read;

  const _Bubble({
    required this.message,
    required this.isMe,
    this.time,
    this.read = false,
  });

  @override
  Widget build(BuildContext context) {
    final dt = time?.toDate();
    final tStr = dt != null
        ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
        : '';
    final isMasked = message.contains('******************');

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isMe ? _kPrimary : _kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isMe
                        ? _kPrimary.withOpacity(0.25)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isMasked
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.block,
                          size: 14,
                          color: isMe
                              ? _kWhite.withOpacity(0.7)
                              : Colors.orange[400],
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            message,
                            style: TextStyle(
                              color: isMe
                                  ? _kWhite.withOpacity(0.85)
                                  : Colors.orange[700],
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      message,
                      style: TextStyle(
                        color: isMe ? _kWhite : _kTextDark,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tStr,
                  style: const TextStyle(fontSize: 10, color: _kTextMid),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    read ? Icons.done_all : Icons.done,
                    size: 12,
                    color: read ? _kPrimary : _kTextMid,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED: Avatar + UserName
// ─────────────────────────────────────────────────────────────────────────────

class _UserName extends StatelessWidget {
  final String userId;
  final TextStyle? style;
  const _UserName({required this.userId, this.style});

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) return Text('Unknown', style: style ?? _def);
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (_, snap) {
        final data = snap.data?.data() as Map<String, dynamic>?;
        return Text(
          data?['name'] as String? ?? 'User',
          style: style ?? _def,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  static const _def = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: _kTextDark,
  );
}

class _Avatar extends StatelessWidget {
  final String userId;
  final double size;
  const _Avatar({required this.userId, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (_, snap) {
        final data = snap.data?.data() as Map<String, dynamic>?;
        final photoUrl = data?['photoUrl'] as String?;
        if (photoUrl != null && photoUrl.isNotEmpty) {
          return CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(photoUrl),
          );
        }
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: _kPrimaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline, color: _kPrimary, size: size * 0.5),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// START CONVERSATION — call from property detail page
// ─────────────────────────────────────────────────────────────────────────────

Future<void> startConversation({
  required BuildContext context,
  required String propertyId,
  required String ownerId,
}) async {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  if (currentUserId.isEmpty || currentUserId == ownerId) return;

  final chatService = ChatService();

  final existing = await FirebaseFirestore.instance
      .collection('conversations')
      .where('propertyId', isEqualTo: propertyId)
      .where('participants', arrayContains: currentUserId)
      .get();

  String conversationId;
  final match = existing.docs.where(
    (doc) => List<String>.from(doc['participants'] ?? []).contains(ownerId),
  );

  if (match.isNotEmpty) {
    conversationId = match.first.id;
  } else {
    conversationId = await chatService.createConversation(
      participants: [currentUserId, ownerId],
      propertyId: propertyId,
    );
  }

  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: conversationId,
          propertyId: propertyId,
          otherUserId: ownerId,
        ),
      ),
    );
  }
}
