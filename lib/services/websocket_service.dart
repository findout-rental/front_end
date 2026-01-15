// // lib/services/websocket_service.dart  (تم تغيير الاسم ليعكس التكنولوجيا)

// import 'package:get/get.dart';
// import 'package:project/core/storage/auth_storage.dart';
// import 'package:pusher_client/pusher_client.dart';


// class WebsocketService {
//   final AuthStorage _authStorage = Get.find<AuthStorage>();
//   PusherClient? _pusherClient;

//   // Channels a user is subscribed to
//   final Map<String, Channel> _channels = {};

//   PusherClient? get client => _pusherClient;

//   /// يقوم بتهيئة وتوصيل PusherClient
//   void connect() {
//     final String? token = _authStorage.token;
//     if (token == null) {
//       print("Pusher Error: Not authenticated, cannot connect.");
//       return;
//     }
//     if (_pusherClient != null && _pusherClient!.getSocketId() != null) {
//       print("Pusher Info: Already connected.");
//       return;
//     }

//     // 1. تحديد خيارات الاتصال
//     final options = PusherOptions(
//       // ⚠️ استبدل هذا بعنوان ومنفذ خادم laravel-websockets/Soketi
//       host: '192.168.1.105',
//       wsPort: 6001,
//       encrypted: false, // استخدم false للتطوير المحلي
//       auth: PusherAuth(
//         // ⚠️ تأكد من أن هذا هو مسار المصادقة الصحيح
//         'http://192.168.1.105:8000/api/broadcasting/auth',
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       ),
//     );



//     // 2. إنشاء وتوصيل العميل
//     _pusherClient = PusherClient(
//       // ⚠️ استبدل هذا بـ PUSHER_APP_KEY من ملف .env
//       'your_pusher_app_key',
//       options,
//       autoConnect: false, // سنتحكم بالاتصال يدويًا
//       enableLogging: true, // مفيد جدًا لتصحيح الأخطاء
//     );

//     // 3. الاتصال يدويًا
//     _pusherClient!.connect();

//     // 4. الاستماع لأحداث الاتصال
//     _pusherClient!.onConnectionStateChange((state) {
//       print("Pusher: connection state change: ${state?.currentState}");
//     });

//     _pusherClient!.onConnectionError((error) {
//       print("Pusher: connection error: ${error?.message}");
//     });
//   }

//   /// يشترك في قناة خاصة ويستمع لحدث معين
//   void listen(
//     String channelName,
//     String eventName,
//     Function(PusherEvent?) onEvent,
//   ) {
//     if (_pusherClient == null) {
//       print("Pusher Error: Client not initialized. Cannot listen to channel.");
//       return;
//     }

//     // إلغاء الاشتراك من القناة القديمة إذا كانت موجودة
//     if (_channels.containsKey(channelName)) {
//       _pusherClient!.unsubscribe(channelName);
//     }

//     // الاشتراك في القناة الجديدة
//     Channel channel = _pusherClient!.subscribe(channelName);
//     _channels[channelName] = channel;

//     // ربط الحدث بالدالة
//     channel.bind(eventName, onEvent);

//     print(
//       "Pusher: Subscribed to '$channelName' and listening for '$eventName'",
//     );
//   }

//   /// يرسل حدثًا من العميل إلى العميل (Whisper)
//   void whisper(String channelName, String eventName, dynamic data) {
//     if (_channels.containsKey(channelName)) {
//       _channels[channelName]!.trigger(eventName, data);
//     }
//   }

//   /// يقطع الاتصال
//   void disconnect() {
//     _pusherClient?.disconnect();
//     _channels.clear();
//     print("Pusher Disconnected.");
//   }
// }
