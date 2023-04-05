import 'package:flutter/material.dart';

class AcademicHome extends StatefulWidget {
  const AcademicHome({super.key});

  @override
  State<AcademicHome> createState() => _AcademicHomeState();
}

class _AcademicHomeState extends State<AcademicHome> {
  List<Subject> subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddSubjectDialog(context);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return Card(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: InkWell(
              onTap: () {
                _showUpdateSubjectDialog(context, subject);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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
                      '${subject.percentageObtained().toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: subject.percentageObtained() <
                                subject.targetPercentage
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          subjects.remove(subject);
                        });
                      },
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

  void _showAddSubjectDialog(BuildContext context) async {
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
                    subjects.add(
                      Subject(
                        name: name,
                        targetPercentage: targetPercentage,
                      ),
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

  void _showUpdateSubjectDialog(BuildContext context, Subject subject) async {
    final obtainedMarksController = TextEditingController();
    final totalMarksController = TextEditingController();

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
              onPressed: () {
                final obtainedMarks =
                    int.tryParse(obtainedMarksController.text);
                final totalMarks = int.tryParse(totalMarksController.text);

                if (obtainedMarks != null && totalMarks != null) {
                  setState(() {
                    final index = subjects.indexOf(subject);
                    final updatedSubject = Subject(
                      name: subject.name,
                      targetPercentage: subject.targetPercentage,
                      obtainedMarks: subject.obtainedMarks + obtainedMarks,
                      totalMarks: subject.totalMarks + totalMarks,
                    );
                    subjects[index] = updatedSubject;
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
}

class Subject {
  final String name;
  final int targetPercentage;
  int obtainedMarks;
  int totalMarks;

  Subject({
    required this.name,
    required this.targetPercentage,
    this.obtainedMarks = 0,
    this.totalMarks = 0,
  });

  double percentageObtained() {
    if (totalMarks == 0) {
      return 0;
    }
    return (obtainedMarks / totalMarks) * 100;
  }
}
