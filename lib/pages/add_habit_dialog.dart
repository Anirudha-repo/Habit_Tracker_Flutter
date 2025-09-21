import 'package:flutter/material.dart';
import '../models/habit.dart';

class AddHabitDialog extends StatefulWidget {
  final Function(Habit) onSave;
  const AddHabitDialog({super.key, required this.onSave});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _controller = TextEditingController();
  Color selectedColor = Colors.indigo;
  IconData selectedIcon = Icons.check_circle;
  bool reminder = false;

  final List<Color> colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  final List<IconData> iconOptions = [
    Icons.fitness_center,
    Icons.book,
    Icons.water_drop,
    Icons.self_improvement,
    Icons.brush,
    Icons.code,
    Icons.music_note,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Habit"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Habit name",
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
              ),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
            const SizedBox(height: 16),

            // Color picker
            Wrap(
              spacing: 8,
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: CircleAvatar(
                    backgroundColor: color,
                    child: selectedColor == color
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Icon picker
            Wrap(
              spacing: 8,
              children: iconOptions.map((icon) {
                return IconButton(
                  icon: Icon(
                    icon,
                    color: selectedIcon == icon
                        ? selectedColor
                        : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => setState(() => selectedIcon = icon),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Reminder toggle
            SwitchListTile(
              title: const Text("Enable Daily Reminder"),
              value: reminder,
              onChanged: (val) {
                setState(() => reminder = val);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () {
            if (_controller.text.isEmpty) return;
            final newHabit = Habit(
              name: _controller.text,
              completed: List.filled(7, false),
              color: selectedColor.value,
              iconCodePoint: selectedIcon.codePoint,
              reminder: reminder,
            );
            widget.onSave(newHabit);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
