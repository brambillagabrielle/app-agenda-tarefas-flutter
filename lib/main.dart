import 'package:flutter/material.dart';
import 'screens/tarefas/list_tarefas.dart';
import 'menu.dart';

void main() {
  runApp(MaterialApp(
      home: MenuOptions(),
      theme: ThemeData(
          colorScheme: ColorScheme.dark(),
          appBarTheme: AppBarTheme(backgroundColor: Colors.black12),
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
              titleMedium: TextStyle(fontSize: 20),
              labelMedium: TextStyle(fontSize: 16),
              bodyMedium: TextStyle(fontSize: 16)),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.black12,
              selectedItemColor: Color(0xFFbb86fc),
              unselectedItemColor: Colors.grey),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFFbb86fc))),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFbb86fc)))));
}
