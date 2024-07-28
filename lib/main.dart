import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api/api_config.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Для инициализации Supabase до запуска приложения
  await Supabase.initialize(
    url: ApiConfig.projectURL,
    anonKey: ApiConfig.projectKEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Используйте тему из вашего отдельного файла
      theme: AppTheme.getTheme(context, isDarkMode: false),
      title: 'ToDo',
      home: MyWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
