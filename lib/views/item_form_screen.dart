import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/item_controller.dart';
import '../models/item.dart';

/// شاشة النموذج (إضافة/تعديل):
/// - إذا استلمت Item عبر arguments -> تعديل
/// - خلاف ذلك -> إضافة
class ItemFormScreen extends StatefulWidget {
  final Object? itemArg;
  const ItemFormScreen({super.key, this.itemArg});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  Item? editing;

  @override
  void initState() {
    super.initState();
    if (widget.itemArg is Item) {
      editing = widget.itemArg as Item;
      titleCtrl.text = editing!.title;
      descCtrl.text = editing!.description ?? '';
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final itemCtrl = context.read<ItemController>();
    final title = titleCtrl.text.trim();
    final desc = descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim();

    if (editing != null) {
      // تعديل
      await itemCtrl.updateItem(editing!, title: title, desc: desc);
    } else {
      // إضافة
      await itemCtrl.add(title, desc);
    }

    if (mounted) Navigator.of(context).pop(); // رجوع بعد الحفظ
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل عنصر' : 'إضافة عنصر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'العنوان مطلوب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(isEditing ? 'تحديث' : 'إضافة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
