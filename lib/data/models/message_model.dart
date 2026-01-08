class Message {
  final String text;
  final String time;
  final String senderId;
  bool isMe; // لتحديد هل الرسالة مني أم من الطرف الآخر

  Message({
    required this.text,
    required this.time,
    required this.senderId,
    this.isMe = false,
    required String id,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] ?? '',
      time: json['time'] ?? '',
      senderId: json['sender_id'] ?? '',
      isMe: json['is_me'] ?? false,
      id: '',
    );
  }

  get id => null;
  Map<String, dynamic> toJson() => {
    'text': text,
    'time': time,
    'sender_id': senderId,
    'is_me': isMe,
  };
}

// بيانات وهمية للمحادثة
// في تطبيق حقيقي، ستأتي هذه من قاعدة بيانات لكل محادثة
final List<Message> mockMessages = [
  Message(
    text: "أهلاً، كيف يمكنني مساعدتك اليوم؟",
    time: "10:30 ص",
    senderId: "1",
    isMe: false,
    id: '',
  ),
  Message(
    text: "أهلاً بك، كنت أستفسر عن حالة الطلب رقم 12345",
    time: "10:31 ص",
    senderId: "2",
    isMe: true,
    id: '',
  ),
  Message(
    text: "بالتأكيد، لحظة من فضلك لأتحقق من النظام.",
    time: "10:31 ص",
    senderId: "1",
    isMe: false,
    id: '',
  ),
  Message(
    text: "لقد وجدت طلبك. يبدو أنه قيد التجهيز الآن.",
    time: "10:32 ص",
    senderId: "1",
    isMe: false,
    id: '',
  ),
  Message(
    text: "ممتاز! متى تتوقعون أن يتم شحنه؟",
    time: "10:33 ص",
    senderId: "2",
    isMe: true,
    id: '',
  ),
  Message(
    text: "من المفترض أن يتم شحنه غدًا صباحًا. ستصلك رسالة تأكيد.",
    time: "10:34 ص",
    senderId: "1",
    isMe: false,
    id: '',
  ),
  Message(
    text: "شكرًا جزيلاً لك على المساعدة!",
    time: "10:35 ص",
    senderId: "2",
    isMe: true,
    id: '',
  ),
];
