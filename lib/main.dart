
import 'package:flutter/material.dart';

void main() {
  runApp(const AgamiLifeApp());
}

class AgamiLifeApp extends StatelessWidget {
  const AgamiLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agami Life',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class ReminderItem {
  final String title;
  final String type;
  final DateTime date;

  ReminderItem({
    required this.title,
    required this.type,
    required this.date,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ReminderItem> items = [];

  Future<void> addItem(String type) async {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                type == 'Appointment'
                    ? 'Add Appointment'
                    : 'Add Document',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: type == 'Appointment'
                          ? 'Appointment name'
                          : 'Document name',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      '${selectedDate.day}/'
                      '${selectedDate.month}/'
                      '${selectedDate.year}',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) return;

                    setState(() {
                      items.add(
                        ReminderItem(
                          title: title,
                          type: type,
                          date: selectedDate,
                        ),
                      );
                      items.sort(
                        (a, b) => a.date.compareTo(b.date),
                      );
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final nextWeek = today.add(const Duration(days: 7));

    final upcoming = items.where((item) {
      final date = DateUtils.dateOnly(item.date);
      return !date.isBefore(today) && date.isBefore(nextWeek);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agami Life',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Never Miss What Matters.',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'আপনার আগামী ৭ দিনের গুরুত্বপূর্ণ বিষয়',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Card(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.event_available, size: 42),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('আগামী ৭ দিন'),
                        Text(
                          '${upcoming.length}টি গুরুত্বপূর্ণ বিষয়',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'আপনার তালিকা',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (upcoming.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 44,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text('এখনো কোনো বিষয় যোগ করা হয়নি'),
                    Text('নিচের + বাটনে চাপ দিয়ে শুরু করুন।'),
                  ],
                ),
              ),
            ),
          ...upcoming.map((item) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    item.type == 'Appointment'
                        ? Icons.event
                        : Icons.description,
                  ),
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.type} • ${item.date.day}/'
                  '${item.date.month}/${item.date.year}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      items.remove(item);
                    });
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'দ্রুত যোগ করুন',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => addItem('Appointment'),
            icon: const Icon(Icons.event),
            label: const Text('Add Appointment'),
          ),
          OutlinedButton.icon(
            onPressed: () => addItem('Document'),
            icon: const Icon(Icons.description),
            label: const Text('Add Document'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet<void>(
            context: context,
            builder: (context) => SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Appointment'),
                    onTap: () {
                      Navigator.pop(context);
                      addItem('Appointment');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Document Expiry'),
                    onTap: () {
                      Navigator.pop(context);
                      addItem('Document');
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
