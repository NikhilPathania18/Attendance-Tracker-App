// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/academic_model.dart';

class AcademicHome extends StatefulWidget {
  const AcademicHome({super.key});

  @override
  State<AcademicHome> createState() => _AcademicHomeState();
}

class _AcademicHomeState extends State<AcademicHome> {
  SubjectAcademic subjects = SubjectAcademic(body: []);

  getdata() async {
    SharedPreferences sdpref = await SharedPreferences.getInstance();
    String? subsd = sdpref.getString("subjectAcademics");
    if (subsd != null) {
      subjects = subjectAcademicFromJson(subsd);
    } else {
      subjects.body = [];
    }
    return subjects;
  }

  double percentageObtained(totalMarks, obtainedMarks) {
    if (totalMarks == 0) {
      return 0;
    }
    return (obtainedMarks / totalMarks) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic Tracker'),
        shadowColor: Colors.blueGrey,
        elevation: 10,
        backgroundColor: Color.fromARGB(255, 158, 49, 109),
        leading: Container(child: Image.asset('assets/image/logo.png')),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddSubjectDialogAcademic(context);
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
              return ListView.builder(
                itemCount: subjects.body.length,
                itemBuilder: (context, index) {
                  final subject = subjects.body[index];
                  return Card(
                    margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: InkWell(
                      onTap: () {
                        _showUpdateSubjectDialogAcademic(context, subject);
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
                              '${subject.obtainedMarks} / ${subject.totalMarks}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${percentageObtained(subject.totalMarks, subject.obtainedMarks).toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: percentageObtained(subject.totalMarks,
                                            subject.obtainedMarks) <
                                        subject.targetPercentage
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Color.fromARGB(255, 110, 15, 36),
                              onPressed: () async {
                                SharedPreferences sdpref =
                                    await SharedPreferences.getInstance();
                                subjects.body.removeAt(index);
                                sdpref.setString("subjectAcademics",
                                    subjectAcademicToJson(subjects));
                                setState(() {});
                              },
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

  void _showAddSubjectDialogAcademic(BuildContext context) async {
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
                      obtainedMarks: 0,
                      totalMarks: 0,
                    ),
                  );
                  SharedPreferences sdpref =
                      await SharedPreferences.getInstance();
                  sdpref.setString(
                      "subjectAcademics", subjectAcademicToJson(subjects));
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

  void _showUpdateSubjectDialogAcademic(
      BuildContext context, Body subject) async {
    final obtainedMarksController =
        //     TextEditingController(text: subject.obtainedMarks.toString());
        TextEditingController(text: "");
    final totalMarksController = TextEditingController(text: "");

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(subject.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: obtainedMarksController,
                decoration: InputDecoration(
                  labelText: 'Marks obtained',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: totalMarksController,
                decoration: InputDecoration(
                  labelText: 'Total marks',
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
              child: Text('Update'),
              onPressed: () async {
                final obtainedMarks =
                    int.tryParse(obtainedMarksController.text);
                final totalMarks = int.tryParse(totalMarksController.text);

                if (obtainedMarks != null && totalMarks != null) {
                  final index = subjects.body.indexOf(subject);
                  final updatedSubject = Body(
                    name: subject.name,
                    targetPercentage: subject.targetPercentage,
                    obtainedMarks: subject.obtainedMarks + obtainedMarks,
                    totalMarks: subject.totalMarks + totalMarks,
                  );
                  subjects.body[index] = updatedSubject;
                  SharedPreferences sdpref =
                      await SharedPreferences.getInstance();
                  sdpref.setString(
                      "subjectAcademics", subjectAcademicToJson(subjects));
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
}
