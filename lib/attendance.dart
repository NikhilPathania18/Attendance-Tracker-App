// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/attendance_model.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome({super.key});
  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  SubjectAttendance subjects = SubjectAttendance(body: []);

  getdata() async {
    SharedPreferences sdpref = await SharedPreferences.getInstance();
    String? subsd = sdpref.getString("subjectAddendance");
    if (subsd != null) {
      subjects = subjectAttendanceFromJson(subsd);
    } else {
      subjects.body = [];
    }
    return subjects;
  }

  double attendancePercentage(presentCount, absentCount) {
    final totalClasses = presentCount + absentCount;
    return totalClasses == 0 ? 100 : (presentCount / totalClasses) * 100;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Tracker'),
        shadowColor: Colors.blueGrey,
        elevation: 10,
        backgroundColor: Color.fromARGB(255, 158, 49, 109),
        leading: Container(child: Image.asset('assets/image/logo.png')),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddSubjectDialogAttendance(context);
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              print(snapshot.data);
              return ListView.builder(
                itemCount: subjects.body.length,
                itemBuilder: (context, index) {
                  final subject = subjects.body[index];
                  return Card(
                    margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: InkWell(
                      onTap: () {
                        _showAttendanceDialog(context, subjects.body[index]);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subject.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${subject.presentCount} / ${subject.presentCount + subject.absentCount}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${attendancePercentage(subject.presentCount, subject.absentCount).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: attendancePercentage(
                                                subject.presentCount,
                                                subject.absentCount) <
                                            subject.targetPercentage
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    SharedPreferences sdpref =
                                        await SharedPreferences.getInstance();
                                    subjects.body.removeAt(index);
                                    sdpref.setString("subjectAddendance",
                                        subjectAttendanceToJson(subjects));
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: Text("No Data!!!"),
            );
          }),
    );
  }

  void _showAddSubjectDialogAttendance(BuildContext context) async {
    final nameController = TextEditingController();
    final targetPercentageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                ),
              ),
              TextField(
                controller: targetPercentageController,
                decoration: InputDecoration(
                  labelText: 'Target Percentage',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                final name = nameController.text;
                final targetPercentage =
                    int.tryParse(targetPercentageController.text);

                if (name.isNotEmpty && targetPercentage != null) {
                  subjects.body.add(
                    Body(
                        name: name,
                        targetPercentage: targetPercentage,
                        absentCount: 0,
                        presentCount: 0),
                  );
                  SharedPreferences sdpref =
                      await SharedPreferences.getInstance();
                  sdpref.setString(
                      "subjectAddendance", subjectAttendanceToJson(subjects));
                  setState(() {});
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAttendanceDialog(BuildContext context, Body subject) async {
    int presentCount = subject.presentCount;
    int absentCount = subject.absentCount;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(subject.name),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Present:',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (presentCount > 0) {
                                  presentCount--;
                                }
                              });
                            },
                          ),
                          Text(
                            presentCount.toString(),
                            style: TextStyle(fontSize: 18.0),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                presentCount++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Absent:',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (absentCount > 0) {
                                  absentCount--;
                                }
                              });
                            },
                          ),
                          Text(
                            absentCount.toString(),
                            style: TextStyle(fontSize: 18.0),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                absentCount++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Total Classes: ${presentCount + absentCount}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                SharedPreferences sdpref =
                    await SharedPreferences.getInstance();
                subject.presentCount = presentCount;
                subject.absentCount = absentCount;
                sdpref.setString(
                    "subjectAddendance", subjectAttendanceToJson(subjects));
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
