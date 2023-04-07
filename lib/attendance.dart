import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/attendance_model.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome({super.key});
  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  SubjectAttendance? subjects;
  // List<SubjectAttendance> subshd = await

  getdata() async {
    SharedPreferences sdpref = await SharedPreferences.getInstance();
    String? subsd = sdpref.getString("subjectAddendance");
    if (subsd != null) {
      subjects = subjectAttendanceFromJson(subsd);
    } else {
      List<Body> bdy;
      subjects = SubjectAttendance(
          body: bdy.add(Body(
              name: "name",
              targetPercentage: 66,
              presentCount: 6,
              absentCount: 6)));
    }
  }

  double attendancePercentage(presentCount, absentCount) {
    final totalClasses = presentCount + absentCount;
    return totalClasses == 0 ? 100 : (presentCount / totalClasses) * 100;
  }

  @override
  void initState() {
    // getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddSubjectDialogAttendance(context);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: subjects?.body.length,
        itemBuilder: (context, index) {
          final subject = subjects?.body[index];
          return Card(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: InkWell(
              onTap: () {
                _showAttendanceDialog(context, subjects!.body[index]);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subject!.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${attendancePercentage(1, 2).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: attendancePercentage(1, 2) <
                                    subject.targetPercentage
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              subjects?.body.removeAt(index);
                            });
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
      ),
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
              onPressed: () {
                final name = nameController.text;
                final targetPercentage =
                    int.tryParse(targetPercentageController.text);

                if (name.isNotEmpty && targetPercentage != null) {
                  setState(() {
                    subjects?.body.add(
                      Body(
                          name: name,
                          targetPercentage: targetPercentage,
                          absentCount: 2,
                          presentCount: 3),
                    );
                  });
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
              onPressed: () {
                setState(() {
                  subject.presentCount = presentCount;
                  subject.absentCount = absentCount;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
