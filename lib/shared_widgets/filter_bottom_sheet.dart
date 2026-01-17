import 'package:flutter/material.dart';

enum PriceType { nightly, monthly }

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Mock data
  final Map<String, List<String>> _governorateCityMap = {
    'الرياض': ['الرياض', 'الدرعية', 'الخرج'],
    'مكة المكرمة': ['مكة', 'جدة', 'الطائف'],
    'الشرقية': ['الدمام', 'الخبر', 'الجبيل'],
  };

  // state
  PriceType _priceType = PriceType.nightly;
  RangeValues? _priceRange;

  int? _bedrooms;
  int? _bathrooms;

  String? _selectedGovernorate;
  String? _selectedCity;
  List<String> _cities = [];

  // ✅ amenities (لازم القيم تطابق اللي مخزنة بالباك داخل JSON)
  final Map<String, String> _amenities = const {
    'balcony': 'شرفة',
    'wifi': 'واي فاي',
    'parking': 'موقف سيارة',
    'ac': 'مكيف',
  };
  final Set<String> _selectedAmenities = {};

  // sorting supported by backend: price_low, price_high, rating, newest, oldest
  String _sortBy = 'newest';

  void _updateCities(String newGovernorate) {
    setState(() {
      _selectedGovernorate = newGovernorate;
      _cities = _governorateCityMap[newGovernorate] ?? [];
      _selectedCity = null;
    });
  }

  void _resetFilters() {
    setState(() {
      _priceType = PriceType.nightly;
      _priceRange = null;
      _bedrooms = null;
      _bathrooms = null;
      _selectedGovernorate = null;
      _selectedCity = null;
      _cities = [];
      _selectedAmenities.clear();
      _sortBy = 'newest';
    });
  }

Map<String, dynamic> _collectFilters() {
  final filters = <String, dynamic>{};

  // ✅ الموقع
  if (_selectedGovernorate != null && _selectedGovernorate!.trim().isNotEmpty) {
    filters['governorate'] = _selectedGovernorate!.trim();
  }
  if (_selectedCity != null && _selectedCity!.trim().isNotEmpty) {
    filters['city'] = _selectedCity!.trim();
  }

  // ✅ السعر حسب النوع المختار (ليلي/شهري)
  if (_priceRange != null) {
    final min = _priceRange!.start.round();
    final max = _priceRange!.end.round();

    if (_priceType == PriceType.nightly) {
      filters['min_nightly_price'] = min;
      filters['max_nightly_price'] = max;
    } else {
      filters['min_monthly_price'] = min;
      filters['max_monthly_price'] = max;
    }
  }

  // ✅ غرف/حمامات
  if (_bedrooms != null && _bedrooms! > 0) {
    filters['bedrooms'] = _bedrooms;
  }
  if (_bathrooms != null && _bathrooms! > 0) {
    filters['bathrooms'] = _bathrooms;
  }

  // ✅ amenities[] (مثل اللي ظهر معك باللوغ تبع owner)
  if (_selectedAmenities.isNotEmpty) {
    filters['amenities[]'] = _selectedAmenities.toList();
  }

  // ✅ sort
  if (_sortBy.trim().isNotEmpty) {
    filters['sort_by'] = _sortBy.trim();
  }

  return filters;
}



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('فلترة', style: theme.textTheme.titleLarge),

            // ---------------- Price type ----------------
            const SizedBox(height: 16),
            Text('نوع السعر', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<PriceType>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('ليلي'),
                    value: PriceType.nightly,
                    groupValue: _priceType,
                    onChanged: (v) => setState(() => _priceType = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<PriceType>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('شهري'),
                    value: PriceType.monthly,
                    groupValue: _priceType,
                    onChanged: (v) => setState(() => _priceType = v!),
                  ),
                ),
              ],
            ),

            // ---------------- Price range ----------------
            const SizedBox(height: 8),
            Text('السعر', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              _priceRange == null
                  ? 'بدون فلترة سعر'
                  : '${_priceRange!.start.round()} - ${_priceRange!.end.round()}',
              style: theme.textTheme.bodySmall,
            ),
            RangeSlider(
              values: _priceRange ?? const RangeValues(1000, 50000),
              min: 1000,
              max: 50000,
              divisions: 49,
              labels: RangeLabels(
                (_priceRange?.start.round() ?? 1000).toString(),
                (_priceRange?.end.round() ?? 50000).toString(),
              ),
              onChanged: (v) => setState(() => _priceRange = v),
            ),

            const SizedBox(height: 12),
            Text('الغرف', style: theme.textTheme.titleMedium),
            Row(
              children: [
                Expanded(child: Text('غرف النوم', style: theme.textTheme.bodyMedium)),
                _stepper(
                  value: _bedrooms,
                  onUpdate: (v) => setState(() => _bedrooms = v),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('الحمّامات', style: theme.textTheme.bodyMedium)),
                _stepper(
                  value: _bathrooms,
                  onUpdate: (v) => setState(() => _bathrooms = v),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text('الموقع', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedGovernorate,
              hint: const Text('اختر المحافظة'),
              items: _governorateCityMap.keys
                  .map((gov) => DropdownMenuItem(value: gov, child: Text(gov)))
                  .toList(),
              onChanged: (value) {
                if (value != null) _updateCities(value);
              },
              decoration: const InputDecoration(labelText: 'المحافظة'),
            ),
            if (_cities.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                hint: const Text('اختر المدينة'),
                items: _cities
                    .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCity = value),
                decoration: const InputDecoration(labelText: 'المدينة'),
              ),
            ],

            const SizedBox(height: 16),
            Text('المرافق', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._amenities.entries.map((e) {
              final key = e.key;
              final label = e.value;
              final checked = _selectedAmenities.contains(key);

              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(label),
                value: checked,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedAmenities.add(key);
                    } else {
                      _selectedAmenities.remove(key);
                    }
                  });
                },
              );
            }),

            const Divider(height: 32),
            Text('الترتيب', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _sortBy,
              items: const [
                DropdownMenuItem(value: 'newest', child: Text('الأحدث')),
                DropdownMenuItem(value: 'oldest', child: Text('الأقدم')),
                DropdownMenuItem(value: 'price_low', child: Text('السعر: من الأقل')),
                DropdownMenuItem(value: 'price_high', child: Text('السعر: من الأعلى')),
                DropdownMenuItem(value: 'rating', child: Text('الأعلى تقييمًا')),
              ],
              onChanged: (v) => setState(() => _sortBy = v ?? 'newest'),
              decoration: const InputDecoration(labelText: 'Sort by'),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('إعادة تعيين'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final filters = _collectFilters();
                      Navigator.pop(context, filters);
                    },
                    child: const Text('تطبيق'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepper({required int? value, required ValueChanged<int?> onUpdate}) {
    final current = value ?? 0;

    return Row(
      children: [
        IconButton(
          tooltip: 'مسح',
          onPressed: value == null ? null : () => onUpdate(null),
          icon: const Icon(Icons.clear),
        ),
        IconButton(
          onPressed: (value == null || current <= 1) ? null : () => onUpdate(current - 1),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 44,
          child: Center(
            child: Text(
              value?.toString() ?? 'الكل',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        IconButton(
          onPressed: () => onUpdate((value ?? 0) + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
