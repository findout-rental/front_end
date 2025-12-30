// lib/models/chat_model.dart

class Chat {
  final String name;
  final String imageUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;

  Chat({
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });
} 
//داتا وهمية
final List<Chat> mockChats = [
  Chat(
    name: "علياء محمد",
    imageUrl: "https://i.pravatar.cc/150?img=1",
    lastMessage: "تمام، سأكون هناك في الموعد المحدد.",
    time: "11:30 ص",
    unreadCount: 2,
  ),
  Chat(
    name: "فريق العمل",
    imageUrl: "https://i.pravatar.cc/150?img=2",
    lastMessage: "أحمد: لا تنسوا اجتماع اليوم.",
    time: "10:45 ص",
    unreadCount: 5,
  ),
  Chat(
    name: "سارة عبدالله",
    imageUrl: "https://i.pravatar.cc/150?img=3",
    lastMessage: "شكراً جزيلاً لك!",
    time: "9:00 ص",
    unreadCount: 0,
  ),
  Chat(
    name: "محمد خالد",
    imageUrl: "https://i.pravatar.cc/150?img=4",
    lastMessage: "وصلتني الملفات، سأراجعها الآن.",
    time: "أمس",
    unreadCount: 0,
  ),
  Chat(
    name: "والدتي",
    imageUrl: "https://i.pravatar.cc/150?img=5",
    lastMessage: "هل ستأتي للعشاء اليوم؟",
    time: "أمس",
    unreadCount: 1,
  ),
];
