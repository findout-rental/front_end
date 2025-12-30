// lib/models/message_model.dart

class Message {
  final String text;
  final String time;
  final bool isMe;

  Message({
    required this.text,
    required this.time,
    required this.isMe,
  });
}

// بيانات وهمية للمحادثة
final List<Message> mockMessages = [
  Message(text: "أهلاً، كيف يمكنني مساعدتك اليوم؟", time: "10:30 ص", isMe: false),
  Message(text: "أهلاً بك، كنت أستفسر عن حالة الطلب رقم 12345", time: "10:31 ص", isMe: true),
  Message(text: "بالتأكيد، لحظة من فضلك لأتحقق من النظام.", time: "10:31 ص", isMe: false),
  Message(text: "لقد وجدت طلبك. يبدو أنه قيد التجهيز الآن.", time: "10:32 ص", isMe: false),
  Message(text: "ممتاز! متى تتوقعون أن يتم شحنه؟", time: "10:33 ص", isMe: true),
  Message(text: "من المفترض أن يتم شحنه غدًا صباحًا. ستصلك رسالة تأكيد.", time: "10:34 ص", isMe: false),
  Message(text: "شكرًا جزيلاً لك على المساعدة!", time: "10:35 ص", isMe: true),
];
