import 'dart:typed_data';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/utils/photo_helper.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/chat_model.dart';
import 'package:project/shared_widgets/primary_button.dart';

class ApartmentDetailPage extends StatefulWidget {
  final Apartment apartment;
  const ApartmentDetailPage({super.key, required this.apartment});

  @override
  State<ApartmentDetailPage> createState() => _ApartmentDetailPageState();
}

class _ApartmentDetailPageState extends State<ApartmentDetailPage> {
  int _currentImageIndex = 0;
  late double _userRating;
  late bool _isAvailable;

  bool _ratingSubmitted = false;

  void _submitRating() {
    if (_userRating <= 0) return;

    setState(() => _ratingSubmitted = true);

    Get.snackbar(
      'تم',
      'تم حفظ تقييمك (واجهة فقط حالياً)',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void initState() {
    super.initState();
    _userRating = 0.0;
    _isAvailable = widget.apartment.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
      body: CustomScrollView(
        slivers: [
          _buildImageGallery(),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSectionDivider(),
                    _buildDescription(),
                    _buildSectionDivider(),
                    _buildFeatures(),
                    _buildSectionDivider(),
                    _buildRatingSection(),
                    _buildSectionDivider(),
                    _buildOwnerInfo(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = widget.apartment.images;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      title: Text(widget.apartment.title, style: const TextStyle(fontSize: 16)),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (images.isEmpty)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 60,
                    color: Colors.white70,
                  ),
                ),
              )
            else
              PageView.builder(
                itemCount: images.length,
                onPageChanged: (i) => setState(() => _currentImageIndex = i),
                itemBuilder: (_, i) =>
                    _buildSmartImage(images[i], darkOverlay: true),
              ),

            if (images.length > 1) _buildImageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageIndicator() {
    final count = widget.apartment.images.length;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentImageIndex == i ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentImageIndex == i ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSmartImage(String raw, {bool darkOverlay = false}) {
    final s = raw.trim();
    if (s.isEmpty) return _brokenImage();

    final Uint8List? bytes = PhotoHelper.decodeFromAnything(s);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        color: darkOverlay ? Colors.black38 : null,
        colorBlendMode: darkOverlay ? BlendMode.darken : null,
        errorBuilder: (_, __, ___) => _brokenImage(),
      );
    }

    if (s.startsWith('http://') || s.startsWith('https://')) {
      return Image.network(
        s,
        fit: BoxFit.cover,
        color: darkOverlay ? Colors.black38 : null,
        colorBlendMode: darkOverlay ? BlendMode.darken : null,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
        errorBuilder: (_, __, ___) => _brokenImage(),
      );
    }

    final url = _toAbsoluteUrl(s);
    if (url == null) return _brokenImage();

    return Image.network(
      url,
      fit: BoxFit.cover,
      color: darkOverlay ? Colors.black38 : null,
      colorBlendMode: darkOverlay ? BlendMode.darken : null,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
      errorBuilder: (_, __, ___) => _brokenImage(),
    );
  }

  String? _toAbsoluteUrl(String raw) {
    final host = ApiEndpoints.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');

    var s = raw.trim();

    s = s.replaceFirst('/storage//', '/storage/');

    if (s.startsWith('/storage//9j/') || s.startsWith('/9j/')) return null;

    if (s.startsWith('/')) return '$host$s';
    return '$host/$s';
  }

  Widget _brokenImage() {
    return Container(
      color: Colors.black26,
      child: const Center(
        child: Icon(Icons.broken_image, size: 50, color: Colors.white60),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.apartment.title,
                style: theme.textTheme.titleLarge,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _isAvailable
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isAvailable ? 'متاحة الآن' : 'محجوزة',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _isAvailable
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber.shade700, size: 20),
            const SizedBox(width: 4),
            Text(
              '${widget.apartment.rating}',
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
            ),
            const SizedBox(width: 6),
            Text(
              '(${widget.apartment.reviewCount} تقييم)',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: theme.primaryColor,
              size: 18,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.apartment.location,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() => _section(
    'عن هذه الشقة',
    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة...',
  );

  Widget _buildFeatures() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الميزات', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFeatureIcon(Icons.bed_outlined, '3 غرف نوم'),
            _buildFeatureIcon(Icons.bathtub_outlined, '2 حمام'),
            _buildFeatureIcon(Icons.square_foot_outlined, '180 م²'),
            _buildFeatureIcon(Icons.balcony_outlined, 'شرفة'),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    final AuthController auth = Get.find<AuthController>();
    final BookingController bookingCtrl = Get.find<BookingController>();

    return Obx(() {
      final isTenant = auth.currentUser.value?.isTenant == true;
      final canRate =
          isTenant && bookingCtrl.canRateApartment(widget.apartment.id);

      String hint;
      if (!isTenant) {
        hint = 'التقييم متاح للمستأجر فقط.';
      } else if (!canRate) {
        hint =
            'يمكنك التقييم فقط بعد انتهاء مدة الحجز (بعد تاريخ الخروج) للحجز الموافق عليه.';
      } else {
        hint = 'قيّم تجربتك بعد انتهاء الإقامة.';
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('أضف تقييمك', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: canRate ? Colors.green.shade700 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: AbsorbPointer(
              absorbing: !canRate || _ratingSubmitted,
              child: Opacity(
                opacity: (!canRate || _ratingSubmitted) ? 0.45 : 1,
                child: AnimatedRatingStars(
                  initialRating: _userRating,
                  onChanged: (rating) => setState(() => _userRating = rating),
                  displayRatingValue: true,
                  interactiveTooltips: true,
                  customFilledIcon: Icons.star,
                  customHalfFilledIcon: Icons.star_half,
                  customEmptyIcon: Icons.star_border,
                  starSize: 40,
                  animationDuration: const Duration(milliseconds: 500),
                  animationCurve: Curves.easeInOut,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (canRate)
            PrimaryButton(
              text: _ratingSubmitted ? 'تم الإرسال' : 'إرسال التقييم',
              onPressed: (_ratingSubmitted || _userRating <= 0)
                  ? null
                  : _submitRating,
            ),
        ],
      );
    });
  }

  Widget _buildOwnerInfo() {
    final theme = Theme.of(context);
    const ownerName = 'شركة العقار الذهبي';
    const ownerImage = 'https://i.pravatar.cc/150?img=12';
    const ownerId = 'owner_1';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مقدمة من', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(ownerImage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ownerName,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  Text('عضو منذ 2021', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.message_outlined),
              color: theme.primaryColor,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.chatDetail,
                  arguments: Chat(
                    userId: ownerId,
                    name: ownerName,
                    imageUrl: ownerImage,
                    lastMessage: 'يمكنك بدء المحادثة الآن...',
                    time: '',
                    unreadCount: 0,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final theme = Theme.of(context);

    return Material(
      elevation: 10,
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SizedBox(
            height: 60,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'السعر\n',
                              style: theme.textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: widget.apartment.price,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 7,
                    child: SizedBox(
                      height: 80,
                      child: _isAvailable
                          ? PrimaryButton(
                              text: 'احجز الآن',
                              onPressed: _navigateToBooking,
                            )
                          : ElevatedButton(
                              onPressed: _cancelBooking,
                              child: const Text('إلغاء الحجز'),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToBooking() async {
    final result =
        await Navigator.pushNamed(
              context,
              AppRouter.booking,
              arguments: {'apartment': widget.apartment},
            )
            as bool?;

    if (result == true) {
      setState(() => _isAvailable = false);
    }
  }

  void _cancelBooking() => setState(() => _isAvailable = true);

  Widget _buildFeatureIcon(IconData icon, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 28, color: theme.textTheme.bodyMedium?.color),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _section(String title, String body) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(body, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildSectionDivider() => const Divider(height: 48, thickness: 0.8);
}
