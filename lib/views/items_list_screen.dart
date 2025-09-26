import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/item_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/item.dart';
import '../routes.dart';

/// شاشة قائمة العناصر (قراءة/حذف + الذهاب للنموذج لإضافة/تعديل).
class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل العناصر عند الدخول
    Future.microtask(() => context.read<ItemController>().load());
  }

  @override
  Widget build(BuildContext context) {
    final itemsCtrl = context.watch<ItemController>();
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('العناصر'),
        actions: [
          IconButton(
            tooltip: 'تسجيل الخروج',
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: itemsCtrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : itemsCtrl.error != null
          ? Center(child: Text(itemsCtrl.error!))
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: itemsCtrl.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final Item item = itemsCtrl.items[index];
          return Card(
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.description ?? '—'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'تعديل',
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.itemForm, arguments: item);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    tooltip: 'حذف',
                    onPressed: () => _confirmDelete(context, item),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, Routes.itemForm),
        icon: const Icon(Icons.add),
        label: const Text('إضافة'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Item item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف "${item.title}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok == true && mounted) {
      await context.read<ItemController>().remove(item.id!);
    }
  }
}
