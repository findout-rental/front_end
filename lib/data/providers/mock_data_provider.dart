import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/chat_model.dart';
import 'package:project/data/models/message_model.dart';
import 'package:project/data/models/onbording_model.dart';

/// كلاس مساعد يوفر بيانات وهمية لجميع أنحاء التطبيق.
/// يعمل كقاعدة بيانات مؤقتة أثناء عملية التطوير.
class MockDataProvider {
  MockDataProvider._();

  static List<OnboardingModel> get onboardingItems => _onboardingItems;
  static List<Chat> get chats => _mockChats;
  static List<Message> get messages => _mockMessages;
  static List<Apartment> get apartments => _mockApartments;
}

// -----------------------------------------------------------------------------
// Onboarding
// -----------------------------------------------------------------------------
final List<OnboardingModel> _onboardingItems = [
  OnboardingModel(
    image: 'assets/images/splash1.jpg',
    title: 'اختر مكانك المثالي...',
    subtitle: 'ودع الراحة تبدأ بنقرة واحدة',
  ),
  OnboardingModel(
    image: 'assets/images/splash2.jpg',
    title: 'احجز على الفور',
    subtitle: 'وأدر حجوزاتك في أي وقت ومن أي مكان',
  ),
];

// -----------------------------------------------------------------------------
// Chats
// -----------------------------------------------------------------------------
final List<Chat> _mockChats = [
  Chat(
    userId: 'support_1',
    name: 'علياء محمد',
    imageUrl: 'https://i.pravatar.cc/150?img=1',
    lastMessage: 'تمام، سأكون هناك في الموعد المحدد.',
    time: '11:30 ص',
    unreadCount: 2,
  ),
  Chat(
    userId: 'group_1',
    name: 'فريق العمل',
    imageUrl: 'https://i.pravatar.cc/150?img=2',
    lastMessage: 'أحمد: لا تنسوا اجتماع اليوم.',
    time: '10:45 ص',
    unreadCount: 5,
  ),
  Chat(
    userId: 'support_2',
    name: 'سارة عبدالله',
    imageUrl: 'https://i.pravatar.cc/150?img=3',
    lastMessage: 'شكراً جزيلاً لك!',
    time: '9:00 ص',
    unreadCount: 0,
  ),
];

// -----------------------------------------------------------------------------
// Messages (Mock Conversation)
// -----------------------------------------------------------------------------
final String _currentUserId = 'user_1';

final List<Message> _mockMessages = [
  Message(
    id: 'm1',
    text: 'أهلاً، كيف يمكنني مساعدتك اليوم؟',
    time: '10:30 ص',
    senderId: 'support_1',
    isMe: false,
  ),
  Message(
    id: 'm2',
    text: 'أهلاً بك، كنت أستفسر عن حالة الطلب رقم 12345',
    time: '10:31 ص',
    senderId: _currentUserId,
    isMe: true,
  ),
  Message(
    id: 'm3',
    text: 'بالتأكيد، لحظة من فضلك لأتحقق من النظام.',
    time: '10:31 ص',
    senderId: 'support_1',
    isMe: false,
  ),
  Message(
    id: 'm4',
    text: 'لقد وجدت طلبك. يبدو أنه قيد التجهيز الآن.',
    time: '10:32 ص',
    senderId: 'support_1',
    isMe: false,
  ),
  Message(
    id: 'm5',
    text: 'ممتاز! متى تتوقعون أن يتم شحنه؟',
    time: '10:33 ص',
    senderId: _currentUserId,
    isMe: true,
  ),
  Message(
    id: 'm6',
    text: 'من المفترض أن يتم شحنه غدًا صباحًا. ستصلك رسالة تأكيد.',
    time: '10:34 ص',
    senderId: 'support_1',
    isMe: false,
  ),
  Message(
    id: 'm7',
    text: 'شكرًا جزيلاً لك على المساعدة!',
    time: '10:35 ص',
    senderId: _currentUserId,
    isMe: true,
  ),
];
// -----------------------------------------------------------------------------
// Apartments (Mock)
// -----------------------------------------------------------------------------
final List<Apartment> _mockApartments = [
  Apartment.fromJson({
    'id': 1,
    'governorate': 'دمشق',
    'city': 'دمشق',
    'address': 'المزة - شارع 123',
    'nightly_price': 50,
    'monthly_price': 1500,
    'amenities': ['WiFi', 'Air Conditioning', 'Balcony'],
    'photos': [
      'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg',
      'https://images.pexels.com/photos/271795/pexels-photo-271795.jpeg',
      'https://images.pexels.com/photos/1668860/pexels-photo-1668860.jpeg',
    ],
    'is_available': true,
    'is_favorited': true,
  }),
  Apartment.fromJson({
    'id': 2,
    'governorate': 'ريف دمشق',
    'city': 'جرمانا',
    'address': 'الشارع الرئيسي - بناء 5',
    'nightly_price': 30,
    'monthly_price': 900,
    'amenities': ['WiFi'],
    'photos': [
      'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg',
      'https://images.pexels.com/photos/1571458/pexels-photo-1571458.jpeg',
    ],
    'is_available': false,
    'is_favorited': false,
  }),
];
