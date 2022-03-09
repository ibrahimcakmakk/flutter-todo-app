
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_todo/data/local_storage.dart';
import 'package:flutter_application_todo/models/task_model.dart';
import 'package:flutter_application_todo/pages/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

final locator = GetIt.instance;

void setup(){
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}
Future<void> setupHive()async{
  await Hive.initFlutter();
  //Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  for (var task in taskBox.values) {
    if (task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task.id);
    }
   }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent));

      await Hive.initFlutter();
      Hive.registerAdapter(TaskAdapter());
      await setupHive();
      setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          )
        )
      ),
      home: const HomePage(),
    );
  }
}