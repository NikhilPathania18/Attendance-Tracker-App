import 'package:flutter/material.dart';
import 'package:trackacademia/academic.dart';
import 'package:trackacademia/attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TrackAcademia'),
        elevation: 10,
        backgroundColor: Colors.purple,
        // leading: Container(alignment: child),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttendanceHome()),
                );
              },
              child: Text('Attendance Tracker'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcademicHome()),
                );
              },
              child: Text('Academic Tracker'),
            ),
          ],
        ),
      ),
    );
  }
}
