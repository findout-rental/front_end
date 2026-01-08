class Chat {
  final String name;
  final String imageUrl;
  final String lastMessage;
  final String userId;
  final String time;
  final int unreadCount;

  Chat({
    required this.name,
    required this.imageUrl,
    required this.userId, // added
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      userId: json['user_id'] ?? '',
      lastMessage: json['last_message'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'image_url': imageUrl,
    'user_id': userId,
    'last_message': lastMessage,
    'time': time,
    'unread_count': unreadCount,
  };
}

// البيانات الوهمية التي ستعرضها الواجهة
// في مكان واحد يسهل تعديلها
final List<Chat> mockChats = [
  Chat(
    name: "علياء محمد",
    imageUrl: "https://i.pravatar.cc/150?img=1",
    userId: "1",
    lastMessage: "تمام، سأكون هناك في الموعد المحدد.",
    time: "11:30 ص",
    unreadCount: 2,
  ),
  Chat(
    name: "فريق العمل",
    imageUrl: "https://i.pravatar.cc/150?img=2",
    userId: "2",
    lastMessage: "أحمد: لا تنسوا اجتماع اليوم.",
    time: "10:45 ص",
    unreadCount: 5,
  ),
  Chat(
    name: "سارة عبدالله",
    imageUrl: "https://i.pravatar.cc/150?img=3",
    userId: "3",
    lastMessage: "شكراً جزيلاً لك!",
    time: "9:00 ص",
    unreadCount: 0,
  ),
  Chat(
    name: "محمد خالد",
    imageUrl: "https://i.pravatar.cc/150?img=4",
    userId: "4",
    lastMessage: "وصلتني الملفات، سأراجعها الآن.",
    time: "أمس",
    unreadCount: 0,
  ),
  Chat(
    name: "والدتي",
    imageUrl: "https://i.pravatar.cc/150?img=5",
    userId: "5",
    lastMessage: "هل ستأتي للعشاء اليوم؟",
    time: "أمس",
    unreadCount: 1,
  ),
];
