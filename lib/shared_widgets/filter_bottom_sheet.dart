// lib/shared_widgets/filter_bottom_sheet.dart

import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // --- DATA MOCK ---
  // في تطبيق حقيقي، قد تأتي هذه من API
  final Map<String, List<String>> _governorateCityMap = {
    'الرياض': ['الرياض', 'الدرعية', 'الخرج'],
    'مكة المكرمة': ['مكة', 'جدة', 'الطائف'],
    'الشرقية': ['الدمام', 'الخبر', 'الجبيل'],
  };

  // --- LOCAL STATE for filters ---
  RangeValues? _priceRange;
  RangeValues? _areaRange;
  int? _bedrooms;
  int? _bathrooms;
  double? _rating;
  bool _hasBalcony = false;
  String? _selectedGovernorate;
  String? _selectedCity;
  List<String> _cities = [];

  // --- HELPER METHODS ---

  /// تحديث قائمة المدن عند اختيار محافظة
  void _updateCities(String newGovernorate) {
    setState(() {
      _selectedGovernorate = newGovernorate;
      _cities = _governorateCityMap[newGovernorate] ?? [];
      _selectedCity = null; // إعادة تعيين المدينة عند تغيير المحافظة
    });
  }

  /// إعادة تعيين جميع الفلاتر إلى قيمها الافتراضية
  void _resetFilters() {
    setState(() {
      _priceRange = null;
      _areaRange = null;
      _bedrooms = null;
      _bathrooms = null;
      _rating = null;
      _hasBalcony = false;
      _selectedGovernorate = null;
      _selectedCity = null;
      _cities = [];
    });
  }

  /// ✅ دالة جديدة لتجميع الفلاتر في Map
  Map<String, dynamic> _collectFilters() {
    final filters = <String, dynamic>{};

    if (_priceRange != null) {
      filters['min_price'] = _priceRange!.start.round();
      filters['max_price'] = _priceRange!.end.round();
    }
    if (_areaRange != null) {
      filters['min_area'] = _areaRange!.start.round();
      filters['max_area'] = _areaRange!.end.round();
    }
    if (_bedrooms != null) {
      filters['bedrooms'] = _bedrooms;
    }
    if (_bathrooms != null) {
      filters['bathrooms'] = _bathrooms;
    }
    if (_rating != null) {
      filters['min_rating'] = _rating!.round();
    }
    if (_hasBalcony) {
      filters['has_balcony'] = 1; // استخدام 1 لـ true
    }
    if (_selectedGovernorate != null) {
      filters['governorate'] = _selectedGovernorate;
    }
    if (_selectedCity != null) {
      filters['city'] = _selectedCity;
    }

    return filters;
  }

  /// التحقق مما إذا كان قد تم اختيار أي فلتر
  bool _isAnyFilterSelected() {
    return _priceRange != null ||
        _areaRange != null ||
        _bedrooms != null ||
        _bathrooms != null ||
        _rating != null ||
        _hasBalcony ||
        _selectedGovernorate != null ||
        _selectedCity != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // لتجنب تغطية الحقول عند ظهور لوحة المفاتيح
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
            // --- Header ---
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

            // --- Price Range ---
            _sectionTitle('السعر (ريال)'),
            _rangeInfo(
              _priceRange,
              defaultMin: 1000,
              defaultMax: 50000,
              unit: 'ريال',
            ),
            RangeSlider(
              values: _priceRange ?? const RangeValues(1000, 50000),
              min: 1000,
              max: 50000,
              divisions: 49,
              labels: RangeLabels(
                _priceRange?.start.round().toString() ?? '1000',
                _priceRange?.end.round().toString() ?? '50000',
              ),
              onChanged: (v) => setState(() => _priceRange = v),
            ),

            // --- Area Range ---
            _sectionTitle('المساحة (م²)'),
            _rangeInfo(_areaRange, defaultMin: 50, defaultMax: 400, unit: 'م²'),
            RangeSlider(
              values: _areaRange ?? const RangeValues(50, 400),
              min: 50,
              max: 400,
              divisions: 35,
              labels: RangeLabels(
                _areaRange?.start.round().toString() ?? '50',
                _areaRange?.end.round().toString() ?? '400',
              ),
              onChanged: (v) => setState(() => _areaRange = v),
            ),

            // --- Rooms ---
            _sectionTitle('عدد الغرف'),
            Row(
              children: [
                Expanded(
                  child: Text('غرف النوم', style: theme.textTheme.bodyMedium),
                ),
                _stepper(
                  value: _bedrooms,
                  onUpdate: (v) => setState(() => _bedrooms = v),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('الحمّامات', style: theme.textTheme.bodyMedium),
                ),
                _stepper(
                  value: _bathrooms,
                  onUpdate: (v) => setState(() => _bathrooms = v),
                ),
              ],
            ),

            // --- Rating ---
            _sectionTitle('التقييم'),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _rating ?? 0, // ابدأ من 0
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: (_rating ?? 0).round().toString(),
                    onChanged: (v) => setState(() => _rating = v),
                  ),
                ),
                Text(
                  (_rating ?? 0).round().toString(),
                  style: theme.textTheme.titleMedium,
                ),
                Icon(Icons.star, color: Colors.amber.shade700, size: 20),
              ],
            ),

            // --- Other Features ---
            CheckboxListTile(
              title: Text('يوجد شرفة', style: theme.textTheme.titleMedium),
              value: _hasBalcony,
              onChanged: (v) => setState(() => _hasBalcony = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // --- Location ---
            _sectionTitle('الموقع'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGovernorate,
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
                value: _selectedCity,
                hint: const Text('اختر المدينة'),
                items: _cities
                    .map(
                      (city) =>
                      DropdownMenuItem(value: city, child: Text(city)),
                )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCity = value),
                decoration: const InputDecoration(labelText: 'المدينة'),
              ),
            ],
            const SizedBox(height: 30),

            // --- Action Buttons ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('إعادة تعيين'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ تم تعديل هذا الجزء
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _rangeInfo(
      RangeValues? values, {
        required double defaultMin,
        required double defaultMax,
        required String unit,
      }) {
    final start = (values?.start ?? defaultMin).round();
    final end = (values?.end ?? defaultMax).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$start - $end $unit',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Widget _stepper({int? value, required ValueChanged<int> onUpdate}) {
    final currentValue = value ?? 0;
    return Row(
      children: [
        IconButton(
          onPressed: currentValue > 1 ? () => onUpdate(currentValue - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          currentValue.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => onUpdate(currentValue + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
