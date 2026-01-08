import 'package:flutter/material.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/apartment_model.dart';

class ApartmentListItemWidget extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback? onFavoriteToggle;

  const ApartmentListItemWidget({
    super.key,
    required this.apartment,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.apartmentDetail,
        arguments: apartment,
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
                Image.network(
                  apartment.images.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                  errorBuilder: (context, error, stack) => const SizedBox(
                    height: 180,
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
                if (onFavoriteToggle != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      child: IconButton(
                        icon: Icon(
                          apartment.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: apartment.isFavorited
                              ? Colors.redAccent
                              : Colors.white,
                        ),
                        onPressed: onFavoriteToggle!,
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
                    apartment.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: theme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          apartment.location,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    apartment.price,
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
}
