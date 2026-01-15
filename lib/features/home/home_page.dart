import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/apartment_controller.dart';
import 'package:project/controllers/home_controller.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/shared_widgets/filter_bottom_sheet.dart';
import 'package:project/features/my_apartments/presentation/screens/my_apartments_page.dart';
import 'package:project/features/profile/profile_page.dart';
import 'package:project/shared_widgets/apartment_list_item_widget.dart';
import 'package:project/shared_widgets/custom_text_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Merged: Using the correct Get.find() approach from OTP branch.
    final HomeController homeController = Get.find<HomeController>();
    final ApartmentController apartmentController =
        Get.find<ApartmentController>();

    final List<Widget> widgetOptions = <Widget>[
      _HomeContent(controller: apartmentController),
      _FavoritesContent(controller: apartmentController),
      MyApartmentsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: homeController.selectedIndex.value,
          children: widgetOptions,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRouter.addApartment),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Merged: Using the translatable keys from HEAD branch.
              _buildNavItem(context, Icons.home_filled, 'home'.tr, 0),
              _buildNavItem(context, Icons.favorite, 'favorites'.tr, 1),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(context, Icons.apartment, 'my_apartments'.tr, 2),
              _buildNavItem(context, Icons.person, 'profile'.tr, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final theme = Theme.of(context);
    final HomeController controller = Get.find<HomeController>();
    final bool isSelected = controller.selectedIndex.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => controller.onTabTapped(index),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

// -----------------------------------------------------------------------------
// Home tab
// -----------------------------------------------------------------------------
class _HomeContent extends StatelessWidget {
  final ApartmentController controller;
  const _HomeContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Get.toNamed(AppRouter.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Get.toNamed(AppRouter.chats),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: 'search_hint'.tr,
                    icon: Icons.search,
                    onChanged: controller.searchApartments, // Enabled search
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () async {
                    final filters =
                        await showModalBottomSheet<Map<String, dynamic>>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const FilterBottomSheet(),
                        );
                    if (filters != null) {
                      controller.fetchApartments(filters: filters);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredApartments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredApartments.isEmpty) {
                return Center(child: Text('no_apartments_found'.tr));
              }
              return ListView.builder(
                itemCount: controller.filteredApartments.length,
                itemBuilder: (context, index) {
                  final apartment = controller.filteredApartments[index];
                  return ApartmentListItemWidget(
                    apartment: apartment,
                    onFavoriteToggle: () =>
                        controller.toggleFavoriteStatus(apartment.id),
                  );
                },
              );
            }),
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
  final ApartmentController controller;
  const _FavoritesContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('favorites'.tr)),
      body: Obx(() {
        final favoritedApartments = controller.favoriteApartments;
        if (favoritedApartments.isEmpty) {
          // Merged: Using the translatable key from HEAD branch.
          return Center(child: Text('no_apartments_found'.tr));
        }
        return ListView.builder(
          itemCount: favoritedApartments.length,
          itemBuilder: (context, index) {
            final apartment = favoritedApartments[index];
            return ApartmentListItemWidget(
              apartment: apartment,
              onFavoriteToggle: () =>
                  controller.toggleFavoriteStatus(apartment.id),
            );
          },
        );
      }),
    );
  }
}
