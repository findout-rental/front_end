// lib/features/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/providers/mock_data_provider.dart';
import 'package:project/features/my_apartments/presentation/screens/my_apartments_page.dart';
import 'package:project/features/profile/profile_page.dart';
import 'package:project/shared_widgets/apartment_list_item_widget.dart';
import 'package:project/shared_widgets/custom_text_field.dart';
import 'package:project/shared_widgets/filter_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Apartment> _allApartments;

  @override
  void initState() {
    super.initState();
    _allApartments = MockDataProvider.apartments;
  }

  void _toggleFavoriteStatus(String apartmentId) {
    setState(() {
      final apartment = _allApartments.firstWhere(
        (apt) => apt.id == apartmentId,
      );
      apartment.isFavorited = !apartment.isFavorited;
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      _HomeContent(
        apartments: _allApartments,
        onFavoriteToggle: _toggleFavoriteStatus,
      ),
      _FavoritesContent(
        favoritedApartments: _allApartments
            .where((apt) => apt.isFavorited)
            .toList(),
        onFavoriteToggle: _toggleFavoriteStatus,
      ),
      const MyApartmentsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: widgetOptions),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.addApartment),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(icon: Icons.home_filled, label: 'الرئيسية', index: 0),
            _buildNavItem(icon: Icons.favorite, label: 'المفضلة', index: 1),
            const SizedBox(width: 48),
            _buildNavItem(icon: Icons.apartment, label: 'شققي', index: 2),
            _buildNavItem(icon: Icons.person, label: 'حسابي', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: isSelected ? theme.primaryColor : Colors.grey.shade500,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? theme.primaryColor : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _HomeContent extends StatelessWidget {
  final List<Apartment> apartments;
  final Function(String) onFavoriteToggle;
  const _HomeContent({
    required this.apartments,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.pushNamed(context, AppRouter.chats),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Row(
              children: [
                const Expanded(
                  child: CustomTextField(
                    hint: 'ابحث عن منطقة، مدينة...',
                    icon: Icons.search,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => const FilterBottomSheet(),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final apartment = apartments[index];
                return ApartmentListItemWidget(
                  apartment: apartment,
                  onFavoriteToggle: () => onFavoriteToggle(apartment.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesContent extends StatelessWidget {
  final List<Apartment> favoritedApartments;
  final Function(String) onFavoriteToggle;
  const _FavoritesContent({
    required this.favoritedApartments,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: favoritedApartments.isEmpty
          ? const Center(child: Text('قائمة المفضلة فارغة.'))
          : ListView.builder(
              itemBuilder: (context, index) {
                final apartment = favoritedApartments[index];
              
                return ApartmentListItemWidget(
                  apartment: apartment,
                  onFavoriteToggle: () => onFavoriteToggle(apartment.id),
                );
              },
            ),
    );
  }
}

// class _ApartmentListItem extends StatelessWidget {
//   final Apartment apartment;
//   final VoidCallback onFavoriteToggle;
//   const _ApartmentListItem({
//     required this.apartment,
//     required this.onFavoriteToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(
//           context,
//           AppRouter.apartmentDetail,
//           arguments: apartment,
//         );
//       },
//       borderRadius: BorderRadius.circular(15),
//       child: Card(
//         elevation: 2,
//         margin: const EdgeInsets.only(bottom: 20),
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Image.network(
//                   apartment.images.first,
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, progress) => progress == null
//                       ? child
//                       : const SizedBox(
//                           height: 180,
//                           child: Center(child: CircularProgressIndicator()),
//                         ),
//                   errorBuilder: (context, error, stack) => const SizedBox(
//                     height: 180,
//                     child: Icon(
//                       Icons.broken_image,
//                       size: 40,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.black.withOpacity(0.4),
//                     child: IconButton(
//                       icon: Icon(
//                         apartment.isFavorited
//                             ? Icons.favorite
//                             : Icons.favorite_border,
//                         color: apartment.isFavorited
//                             ? Colors.redAccent
//                             : Colors.white,
//                       ),
//                       onPressed: onFavoriteToggle,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     apartment.title,
//                     style: theme.textTheme.titleMedium,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on_outlined,
//                         color: theme.primaryColor,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           apartment.location,
//                           style: theme.textTheme.bodySmall,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     apartment.price,
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       color: theme.primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('محتوى صفحة $title', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
