import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/notification_service.dart';
import 'pages/home_page.dart';
import 'models/habit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationService.init();

  // Show a simple notification when app starts
  await NotificationService.showNotification(
    title: "Habit Tracker",
    body: "Welcome back! Don’t forget to check your habits.",
  );

  runApp(const HabitApp());
}

class HabitApp extends StatefulWidget {
  const HabitApp({Key? key}) : super(key: key);

  @override
  State<HabitApp> createState() => _HabitAppState();
}

class _HabitAppState extends State<HabitApp> {
  ThemeMode _themeMode = ThemeMode.system;
  List<Habit> habits = [];

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _addHabit(Habit habit) {
    setState(() {
      habits.add(habit);
    });
  }

  void _toggleDay(int habitIndex, int dayIndex) {
    setState(() {
      final h = habits[habitIndex];
      if (dayIndex >= 0 && dayIndex < h.completed.length) {
        h.completed[dayIndex] = !h.completed[dayIndex];
      }
    });
  }

  void _deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.black54),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: HomePage(
        habits: habits,
        onAddHabit: _addHabit,
        onToggleDay: _toggleDay,
        onDeleteHabit: _deleteHabit,
        onToggleTheme: _toggleTheme,
        darkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
