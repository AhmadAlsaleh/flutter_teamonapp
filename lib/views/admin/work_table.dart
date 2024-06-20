import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/models/list_work_session.dart';

class WorkTable extends StatelessWidget {
  const WorkTable({super.key, required this.listWorkSession});

  final ListWorkSession listWorkSession;

  @override
  Widget build(BuildContext context) {
    var users = listWorkSession.getUsers();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Index')),
              DataColumn(label: Text('Employee')),
              DataColumn(label: Text('Work')),
              DataColumn(label: Text('Break')),
            ],
            rows: users
                .map(
                  (user) => DataRow(cells: [
                    DataCell(Text("${users.indexOf(user) + 1}")),
                    DataCell(Text(user.fullName)),
                    DataCell(Text(listWorkSession
                        .getUserWorkDuration(user)
                        .toString()
                        .split(".")[0])),
                    DataCell(Text(listWorkSession
                        .getUserBreakDuration(user)
                        .toString()
                        .split(".")[0])),
                  ]),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
