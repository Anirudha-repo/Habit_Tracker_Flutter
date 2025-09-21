// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'add_habit_dialog.dart';
import '../widgets/progress_chart.dart';

class HomePage extends StatelessWidget {
  final List<Habit> habits;
  final void Function(Habit) onAddHabit;
  final void Function(int, int) onToggleDay;
  final void Function(int) onDeleteHabit;
  final VoidCallback onToggleTheme;
  final bool darkMode;

  const HomePage({
    Key? key,
    required this.habits,
    required this.onAddHabit,
    required this.onToggleDay,
    required this.onDeleteHabit,
    required this.onToggleTheme,
    required this.darkMode,
  }) : super(key: key);

  int _streak(Habit habit) {
    int count = 0;
    for (int i = habit.completed.length - 1; i >= 0; i--) {
      if (habit.completed[i]) count++;
      else break;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final days = ['M','T','W','T','F','S','S'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(darkMode ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined),
            tooltip: 'Toggle theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: habits.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'No habits yet. Tap + to add your first habit.\nTap a day to mark it completed.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, idx) {
                      final habit = habits[idx];
                      return Dismissible(
                        key: Key(habit.name + idx.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => onDeleteHabit(idx),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Color(habit.color),
                                      child: Icon(habit.icon, color: Colors.white),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(habit.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                    Text('${_streak(habit)} streak', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(7, (d) {
                                    final done = habit.completed.length > d ? habit.completed[d] : false;
                                    return GestureDetector(
                                      onTap: () => onToggleDay(idx, d),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 250),
                                        decoration: BoxDecoration(
                                          color: done ? Color(habit.color) : Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: done ? [BoxShadow(color: Color(habit.color).withOpacity(0.35), blurRadius: 4, offset: const Offset(0,2))] : [],
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Text(days[d], style: TextStyle(color: done ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(done ? '✓' : '', style: const TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          ProgressChart(habits: habits),
          const SizedBox(height: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddHabitDialog(onSave: (habit) => onAddHabit(habit)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
