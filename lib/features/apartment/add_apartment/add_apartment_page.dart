import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:project/controllers/apartment_controller.dart';
import 'package:project/shared_widgets/custom_text_field.dart';

class AddApartmentPage extends StatefulWidget {
  const AddApartmentPage({super.key});

  @override
  State<AddApartmentPage> createState() => _AddApartmentPageState();
}

class _AddApartmentPageState extends State<AddApartmentPage> {
  int _currentStep = 0;
  final _picker = ImagePicker();
  final List<File> _apartmentImages = [];
  int _bedrooms = 1;
  int _bathrooms = 1;
  bool _hasBalcony = false;
  bool _hasAC = false;
  bool _hacInternet = false;

  // Merged: Removed duplicate/obsolete properties from HEAD branch.
  // The OTP branch's architecture is cleaner.

  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _personController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _personController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<FormData> _buildFormData() async {
    final amenities = <String>[];
    if (_hasBalcony) amenities.add('Balcony');
    if (_hasAC) amenities.add('Air Conditioning');
    if (_hacInternet) amenities.add('WiFi');

    final formData = FormData();
    // ---------- FIELDS ----------
    formData.fields.addAll([
      MapEntry('title', _titleController.text.trim()),
      MapEntry('description', _descriptionController.text.trim()),
      MapEntry('governorate', _governorateController.text.trim()),
      MapEntry('city', _cityController.text.trim()),
      MapEntry(
        'address',
        '${_governorateController.text.trim()}, ${_cityController.text.trim()}',
      ),
      MapEntry('nightly_price', _priceController.text.trim()),
      MapEntry(
        'monthly_price',
        ((double.tryParse(_priceController.text) ?? 0) * 30).toString(),
      ),
      MapEntry('living_rooms', '1'),
      MapEntry('size', _areaController.text.trim()),
      MapEntry('bedrooms', _bedrooms.toString()),
      MapEntry('bathrooms', _bathrooms.toString()),
      MapEntry('max_guests', (_bedrooms * 2).toString()),
    ]);
    // ---------- AMENITIES ARRAY ----------
    for (int i = 0; i < amenities.length; i++) {
      formData.fields.add(MapEntry('amenities[$i]', amenities[i]));
    }
    // ---------- PHOTOS ARRAY (STRINGS) ----------
    for (int i = 0; i < _apartmentImages.length; i++) {
      final bytes = await _apartmentImages[i].readAsBytes();
      final base64Image = base64Encode(bytes);
      formData.fields.add(MapEntry('photos[$i]', base64Image));
    }
    return formData;
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 80);
    if (pickedFiles.isEmpty) return;
    setState(() {
      final remaining = 10 - _apartmentImages.length;
      if (remaining <= 0) {
        Get.snackbar('تنبيه', 'مسموح بحد أقصى 10 صور فقط');
        return;
      }
      final toAdd = pickedFiles
          .take(remaining)
          .map((x) => File(x.path))
          .toList();
      _apartmentImages.addAll(toAdd);
      if (pickedFiles.length > remaining) {
        Get.snackbar('تنبيه', 'تم إضافة $remaining صور فقط لأن الحد الأقصى 10');
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      _apartmentImages.removeAt(index);
    });
  }

  // Merged: Removed the old _submitForm() function from HEAD.
  // The new logic is correctly placed in the Stepper's onStepContinue.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أضف شقتك')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep == 0) {
            if (_step1FormKey.currentState!.validate()) {
              setState(() => _currentStep += 1);
            }
          } else if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            // ✅ Last step: Validate and submit via controller
            if (_apartmentImages.isEmpty) {
              Get.snackbar('خطأ', 'لازم تضيف صورة واحدة على الأقل');
              return;
            }
            if (_apartmentImages.length > 10) {
              Get.snackbar('خطأ', 'الحد الأقصى 10 صور');
              return;
            }
            final controller = Get.find<ApartmentController>();
            final formData = await _buildFormData();
            final ok = await controller.addApartment(formData);
            if (ok) Navigator.pop(context);
          }
        },
        onStepCancel: _currentStep > 0
            ? () => setState(() => _currentStep -= 1)
            : null,
        steps: _buildSteps(),
      ),
    );
  }

  // ... All the _buildStep...() and other UI methods remain unchanged ...
  // (Paste the rest of your UI build methods here, they are not in conflict)
  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('المعلومات الأساسية'),
        content: _buildStep1(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('تفاصيل الشقة'),
        content: _buildStep2(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('صور الشقة'),
        content: _buildStep3(),
        isActive: _currentStep >= 2,
        state: _currentStep == 2 ? StepState.editing : StepState.indexed,
      ),
    ];
  }

  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _personController,
            hint: 'اسم المالك (مثال : أحمد محمد )',
            icon: Icons.person,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _titleController,
            hint: 'عنوان الإعلان (مثال: شقة فاخرة بحي الياسمين)',
            icon: Icons.title,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'الوصف',
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _governorateController,
            hint: 'عنوان المحافظة (مثال: سوريا)',
            icon: Icons.location_city,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _cityController,
            hint: 'عنوان المدينة (مثال: دمشق)',
            icon: Icons.location_city_rounded,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _priceController,
            hint: 'السعر / شهري (بالدولار)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final theme = Theme.of(context);
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('غرف النوم'),
              _stepper(
                value: _bedrooms,
                onUpdate: (newValue) => setState(() => _bedrooms = newValue),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('عدد الحمّامات'),
              _stepper(
                value: _bathrooms,
                onUpdate: (newValue) => setState(() => _bathrooms = newValue),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _areaController,
            hint: 'المساحة (م²)',
            icon: Icons.square_foot_outlined,
            keyboardType: TextInputType.number,
            validator: (v) => (v?.isEmpty ?? true) ? 'الحقل مطلوب' : null,
          ),
          const Divider(height: 24),
          const SizedBox(height: 16),
          Text('الميزات', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          CheckboxListTile(
            title: const Text('يوجد شرفة'),
            value: _hasBalcony,
            onChanged: (value) => setState(() => _hasBalcony = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            title: const Text('يوجد تكييف'),
            value: _hasAC,
            onChanged: (value) => setState(() => _hasAC = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            title: const Text('يوجد إنترنت'),
            value: _hacInternet,
            onChanged: (value) => setState(() => _hacInternet = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('اختر صورًا'),
        ),
        const SizedBox(height: 16),
        _apartmentImages.isEmpty
            ? const Text('لم يتم اختيار أي صور بعد.')
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _apartmentImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Image.file(
                        _apartmentImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _removeImage(index),
                      ),
                    ],
                  );
                },
              ),
      ],
    );
  }

  Widget _stepper({required int value, required ValueChanged<int> onUpdate}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: value > 1 ? () => onUpdate(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => onUpdate(value + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
