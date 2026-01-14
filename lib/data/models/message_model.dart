class Message {
  /// ID الرسالة (من السيرفر أو mock)
  final String id;

  /// نص الرسالة
  final String text;

  /// وقت الإرسال (يمكن لاحقًا تحويله إلى DateTime)
  final String time;

  /// معرف المرسل
  final String senderId;

  /// هل هذه الرسالة من المستخدم الحالي (للـ UI فقط)
  bool isMe;

  Message({
    required this.id,
    required this.text,
    required this.time,
    required this.senderId,
    this.isMe = false,
  });

  // ===============================
  // FACTORIES
  // ===============================
  factory Message.fromJson(
      Map<String, dynamic> json, {
        required String currentUserId,
      }) {
    final senderId = json['sender_id']?.toString() ?? '';

    return Message(
      id: json['id']?.toString() ?? '',
      text: json['text'] ?? '',
      time: json['time'] ?? '',
      senderId: senderId,
      isMe: senderId == currentUserId,
    );
  }

  // ===============================
  // SERIALIZATION
  // ===============================
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'time': time,
    'sender_id': senderId,
  };
}


final List<Message> mockMessages = [
  Message(
    id: '1',
    text: "أهلاً، كيف يمكنني مساعدتك اليوم؟",
    time: "10:30 ص",
    senderId: "support",
    isMe: false,
  ),
  Message(
    id: '2',
    text: "أهلاً بك، كنت أستفسر عن حالة الطلب رقم 12345",
    time: "10:31 ص",
    senderId: "user",
    isMe: true,
  ),
  Message(
    id: '3',
    text: "بالتأكيد، لحظة من فضلك لأتحقق من النظام.",
    time: "10:31 ص",
    senderId: "support",
    isMe: false,
  ),
  Message(
    id: '4',
    text: "لقد وجدت طلبك. يبدو أنه قيد التجهيز الآن.",
    time: "10:32 ص",
    senderId: "support",
    isMe: false,
  ),
  Message(
    id: '5',
    text: "ممتاز! متى تتوقعون أن يتم شحنه؟",
    time: "10:33 ص",
    senderId: "user",
    isMe: true,
  ),
  Message(
    id: '6',
    text: "من المفترض أن يتم شحنه غدًا صباحًا. ستصلك رسالة تأكيد.",
    time: "10:34 ص",
    senderId: "support",
    isMe: false,
  ),
  Message(
    id: '7',
    text: "شكرًا جزيلاً لك على المساعدة!",
    time: "10:35 ص",
    senderId: "user",
    isMe: true,
  ),
];
