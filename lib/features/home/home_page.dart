import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:project/controllers/apartment_controller.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/home_controller.dart';
import 'package:project/core/routing/app_router.dart';
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
  late final HomeController homeController;
  late final ApartmentController apartmentController;
  late final AuthController authController;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    homeController = Get.find<HomeController>();
    apartmentController = Get.find<ApartmentController>();
    authController = Get.find<AuthController>();

    pages = <Widget>[
      _HomeContent(controller: apartmentController),
      _FavoritesContent(controller: apartmentController),
      MyApartmentsPage(),
      const ProfilePage(),
    ];

    // Safe extra fetch (لن يضر لأن controller يمنع الطلب قبل login)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (apartmentController.allApartments.isEmpty &&
          !apartmentController.isLoading.value) {
        apartmentController.fetchApartments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: homeController.selectedIndex.value,
          children: pages,
        );
      }),

      // ✅ FAB يظهر فقط للـ Owner
      floatingActionButton: Obx(() {
        final isOwner = authController.currentUser.value?.isOwner == true;
        if (!isOwner) return const SizedBox.shrink();

        return FloatingActionButton(
          onPressed: () => Get.toNamed(AppRouter.addApartment),
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: SafeArea(
  top: false,
  child: BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,
    child: Obx(() {
      final current = homeController.selectedIndex.value;
      final isOwner = authController.currentUser.value?.isOwner == true;

      return LayoutBuilder(
        builder: (context, constraints) {
          // ✅ gap responsive لمكان الـ FAB (بين 64 و 96 حسب عرض الجهاز)
          final double gap = isOwner
              ? (constraints.maxWidth * 0.18).clamp(64.0, 96.0).toDouble()
              : 0.0;

          return Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  theme,
                  Icons.home_filled,
                  'الرئيسية',
                  0,
                  current == 0,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  theme,
                  Icons.favorite,
                  'المفضلة',
                  1,
                  current == 1,
                ),
              ),

              if (isOwner) SizedBox(width: gap),

              Expanded(
                child: _buildNavItem(
                  theme,
                  Icons.apartment,
                  'شققي',
                  2,
                  current == 2,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  theme,
                  Icons.person,
                  'حسابي',
                  3,
                  current == 3,
                ),
              ),
            ],
          );
        },
      );
    }),
  ),
),


    );
  }

  Widget _buildNavItem(
  ThemeData theme,
  IconData icon,
  String label,
  int index,
  bool isSelected,
) {
  return InkWell(
    onTap: () => homeController.onTabTapped(index),
    borderRadius: BorderRadius.circular(24),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6), // ✅ أقل لتجنب overflow
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? theme.primaryColor : Colors.grey.shade500,
          ),
          const SizedBox(height: 2),
          FittedBox( // ✅ يجعل النص responsive وما يعمل overflow
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? theme.primaryColor : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
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
                    onChanged: controller.searchApartments, // ✅ تفعيل البحث
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
  onLongPress: controller.clearFilters, // ✅ ضغط مطوّل يمسح الفلاتر
  child: IconButton(
    icon: const Icon(Icons.filter_list),
    onPressed: () async {
      final filters = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const FilterBottomSheet(),
      );

      if (filters != null) {
        controller.applyFilters(filters); // ✅ بدل fetchApartments
      }
    },
  ),
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
                    onFavoriteToggle: () => controller
                        .toggleFavoriteStatus(apartment.id.toString()),
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
        final favorites = controller.favoriteApartments;

        if (favorites.isEmpty) {
          return Center(child: Text('no_apartments_found'.tr));
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final apartment = favorites[index];
            return ApartmentListItemWidget(
              apartment: apartment,
              onFavoriteToggle: () =>
                  controller.toggleFavoriteStatus(apartment.id.toString()),
            );
          },
        );
      }),
    );
  }
}
