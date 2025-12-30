// lib/data/providers/mock_data_provider.dart

import 'package:project/data/models/apartment_model.dart' show Apartment;
import 'package:project/data/models/chat_model.dart' show Chat;
import 'package:project/data/models/message_model.dart' show Message;
import 'package:project/data/models/onbording_item.dart' show OnboardingItem;

class MockDataProvider {
  MockDataProvider._();

  static List<OnboardingItem> get onboardingItems => _onboardingItems;

  static List<Chat> get chats => _mockChats;

  static List<Message> get messages => _mockMessages;

  static List<Apartment> get apartments => _mockApartments;
}

final List<OnboardingItem> _onboardingItems = [
  OnboardingItem(
    image:
        'assets/images/splash1.jpg',
    title: 'اختر مكانك المثالي...',
    subtitle: 'ودع الراحة تبدأ بنقرة واحدة',
  ),
  OnboardingItem(
    image:
        'assets/images/splash2.jpg', 
    title: 'احجز على الفور',
    subtitle: 'وأدر حجوزاتك في أي وقت ومن أي مكان',
  ),
];

final List<Chat> _mockChats = [
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
];

final List<Message> _mockMessages = [
  Message(
    text: "أهلاً، كيف يمكنني مساعدتك اليوم؟",
    time: "10:30 ص",
    isMe: false,
  ),
  Message(
    text: "أهلاً بك، كنت أستفسر عن حالة الطلب رقم 12345",
    time: "10:31 ص",
    isMe: true,
  ),
  Message(
    text: "بالتأكيد، لحظة من فضلك لأتحقق من النظام.",
    time: "10:31 ص",
    isMe: false,
  ),
  Message(
    text: "لقد وجدت طلبك. يبدو أنه قيد التجهيز الآن.",
    time: "10:32 ص",
    isMe: false,
  ),
  Message(text: "ممتاز! متى تتوقعون أن يتم شحنه؟", time: "10:33 ص", isMe: true),
  Message(
    text: "من المفترض أن يتم شحنه غدًا صباحًا. ستصلك رسالة تأكيد.",
    time: "10:34 ص",
    isMe: false,
  ),
  Message(text: "شكرًا جزيلاً لك على المساعدة!", time: "10:35 ص", isMe: true),
];

final List<Apartment> _mockApartments = [
  Apartment(
    id: '1',
    title: 'شقة فاخرة بإطلالة على المدينة',
    location: 'الرياض، حي الياسمين',
    price: '5,000 ريال/شهري',
    isFavorited: true,
    isAvailable: true,
    imageUrl:
        'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    images: [
      'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/271795/pexels-photo-271795.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1668860/pexels-photo-1668860.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ],
    pricePerNight: 400,
  ),
  Apartment(
    id: '2',
    title: 'استوديو مودرن في قلب العاصمة',
    location: 'الدمام، حي الشاطئ',
    price: '2,500 ريال/شهري',
    isFavorited: false,
    isAvailable: false,
    imageUrl:
        'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    images: [
      'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1571458/pexels-photo-1571458.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ],
    pricePerNight: 400,
  ),
  Apartment(
    id: '1',
    title: 'شقة فاخرة بإطلالة على المدينة',
    location: 'الرياض، حي الياسمين',
    price: '5,000 ريال/شهري',
    isFavorited: true,
    isAvailable: true,
    imageUrl:
        'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    images: [
      'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/271795/pexels-photo-271795.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1668860/pexels-photo-1668860.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ],
    pricePerNight: 400,
  ),
  Apartment(
    id: '2',
    title: 'استوديو مودرن في قلب العاصمة',
    location: 'الدمام، حي الشاطئ',
    price: '2,500 ريال/شهري',
    isFavorited: false,
    isAvailable: false,
    imageUrl:
        'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    images: [
      'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1571458/pexels-photo-1571458.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ],
    pricePerNight: 400,
  ),
];
