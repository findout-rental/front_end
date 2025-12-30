// lib/features/add_apartment/add_apartment_page.dart

import 'dart:io';

import 'package:flutter/material.dart'
    show
        StatefulWidget,
        State,
        FormState,
        GlobalKey,
        BuildContext,
        Widget,
        Text,
        Step,
        SizedBox,
        InputDecoration,
        Divider,
        Icon,
        NeverScrollableScrollPhysics,
        SliverGridDelegateWithFixedCrossAxisCount,
        ValueChanged,
        TextStyle,
        TextEditingController,
        AppBar,
        Navigator,
        Stepper,
        Scaffold,
        StepState,
        Icons,
        TextFormField,
        TextInputType,
        Column,
        Form,
        Theme,
        CrossAxisAlignment,
        MainAxisAlignment,
        Row,
        ListTileControlAffinity,
        EdgeInsets,
        CheckboxListTile,
        OutlinedButton,
        GridView,
        Alignment,
        Image,
        BoxFit,
        Colors,
        IconButton,
        Stack,
        MainAxisSize,
        FontWeight;
import 'package:image_picker/image_picker.dart';
import 'package:project/shared_widgets/custom_text_field.dart'
    show CustomTextField;

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

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      imageQuality: 80,
    );
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _apartmentImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _apartmentImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أضف شقتك')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_step1FormKey.currentState!.validate()) {
              setState(() => _currentStep += 1);
            }
          } else if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            // TODO: منطق إرسال كل البيانات إلى الخادم
            print('Form Submitted!');
            Navigator.pop(context);
          }
        },
        onStepCancel: _currentStep > 0
            ? () => setState(() => _currentStep -= 1)
            : null,
        steps: _buildSteps(),
      ),
    );
  }

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
            hint: 'عنوان المحافظة (مثال: الرياض)',
            icon: Icons.location_city,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _cityController,
            hint: 'عنوان المدينة (مثال: القصيم)',
            icon: Icons.location_city_rounded,
            validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _priceController,
            hint: 'السعر / شهري (بالريال)',
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
          Text('الميزات', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),

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

   
          CheckboxListTile(
            title: const Text('يوجد شرفة'),
            value: _hasBalcony,
            onChanged: (value) => setState(() => _hasBalcony = value ?? false),
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
