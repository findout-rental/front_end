import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/utils/photo_helper.dart';
import 'package:project/data/models/apartment_model.dart';

class ApartmentListItemWidget extends StatefulWidget {
  final Apartment apartment;
  final VoidCallback? onFavoriteToggle;

  const ApartmentListItemWidget({
    super.key,
    required this.apartment,
    this.onFavoriteToggle,
  });

  @override
  State<ApartmentListItemWidget> createState() => _ApartmentListItemWidgetState();
}

class _ApartmentListItemWidgetState extends State<ApartmentListItemWidget> {
  Uint8List? _bytes;
  String? _url;

  @override
  void initState() {
    super.initState();

    final raw = (widget.apartment.images.isNotEmpty)
        ? widget.apartment.images.first.toString().trim()
        : '';

    // ✅ 1) جرّب Base64 حتى لو كان ضمن URL
    _bytes = PhotoHelper.decodeFromAnything(raw);

    // ✅ 2) إذا مو Base64، اعتبره رابط/مسار عادي
    if (_bytes == null) {
      _url = _toAbsoluteUrl(raw);
    }
  }

  String? _toAbsoluteUrl(String raw) {
    var s = raw.trim();
    if (s.isEmpty) return null;

    // إذا كان URL كامل
    if (s.startsWith('http://') || s.startsWith('https://')) return s;

    // إذا كان /storage/... عادي
    final host = ApiEndpoints.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    if (s.startsWith('/')) return '$host$s';
    return '$host/$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.apartmentDetail,
        arguments: widget.apartment,
      ),
      borderRadius: BorderRadius.circular(15),
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: _buildImage(),
                ),

                if (widget.onFavoriteToggle != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      child: IconButton(
                        icon: Icon(
                          widget.apartment.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.apartment.isFavorited
                              ? Colors.redAccent
                              : Colors.white,
                        ),
                        onPressed: widget.onFavoriteToggle!,
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.apartment.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: theme.primaryColor, size: 16),
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
                  const SizedBox(height: 12),
                  Text(
                    widget.apartment.price,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // ✅ Base64
    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _placeholderImage(),
      );
    }

    // ✅ URL / storage path
    if (_url != null && _url!.isNotEmpty) {
      return Image.network(
        _url!,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, __, ___) => _placeholderImage(),
      );
    }

    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
