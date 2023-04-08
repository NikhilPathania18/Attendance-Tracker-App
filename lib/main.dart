import 'package:flutter/material.dart';
import 'package:trackacademia/academic.dart';
import 'package:trackacademia/attendance.dart';
import 'package:trackacademia/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // home: HomeScreen(),
      home: SplashScreen(),
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
        shadowColor: Colors.blueGrey,
        elevation: 10,
        backgroundColor: Color.fromARGB(255, 158, 49, 109),
        leading: Container(child: Image.asset('assets/image/logo.png')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage('assets/image/attendance.png'),
              size: 100, // set the size of the icon
              color: Color.fromARGB(
                  255, 190, 25, 190), // set the color of the icon
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 162, 65, 165),
                  fixedSize: const Size(300, 100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  textStyle: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttendanceHome()),
                );
              },
              child: Text('Attendance Tracker'),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 162, 65, 165),
                  fixedSize: const Size(300, 100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  textStyle: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcademicHome()),
                );
              },
              child: Text('Academic Tracker'),
            ),
            SizedBox(
              height: 10,
            ),
            ImageIcon(
              AssetImage('assets/image/academic.png'),
              size: 100, // set the size of the icon
              color: Color.fromARGB(
                  255, 190, 25, 190), // set the color of the icon
            )
          ],
        ),
      ),
    );
  }
}
