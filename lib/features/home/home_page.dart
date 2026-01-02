import 'package:flutter/material.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/shared_widgets/filter_bottom_sheet.dart';
import 'package:project/data/providers/mock_data_provider.dart';
import 'package:project/features/my_apartments/presentation/screens/my_apartments_page.dart';
import 'package:project/features/profile/profile_page.dart';
import 'package:project/shared_widgets/apartment_list_item_widget.dart';
import 'package:project/shared_widgets/custom_text_field.dart';

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
      final apartment =
          _allApartments.firstWhere((apt) => apt.id == apartmentId);
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
        favoritedApartments:
            _allApartments.where((apt) => apt.isFavorited).toList(),
        onFavoriteToggle: _toggleFavoriteStatus,
      ),
       MyApartmentsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: widgetOptions),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AppRouter.addApartment),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.home_filled, 'الرئيسية', 0),
            _buildNavItem(Icons.favorite, 'المفضلة', 1),
            const SizedBox(width: 48),
            _buildNavItem(Icons.apartment, 'شققي', 2),
            _buildNavItem(Icons.person, 'حسابي', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isSelected
                      ? theme.primaryColor
                      : Colors.grey.shade500),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.primaryColor
                      : Colors.grey.shade600,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Home tab
// -----------------------------------------------------------------------------
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
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.chats),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => const FilterBottomSheet(),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: apartments.length,
              itemBuilder: (context, index) {
                final apartment = apartments[index];
                return ApartmentListItemWidget(
                  apartment: apartment,
                  onFavoriteToggle: () =>
                      onFavoriteToggle(apartment.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Favorites tab
// -----------------------------------------------------------------------------
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
              itemCount: favoritedApartments.length,
              itemBuilder: (context, index) {
                final apartment = favoritedApartments[index];
                return ApartmentListItemWidget(
                  apartment: apartment,
                  onFavoriteToggle: () =>
                      onFavoriteToggle(apartment.id),
                );
              },
            ),
    );
  }
}
