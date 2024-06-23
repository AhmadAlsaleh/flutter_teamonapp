import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/list_work_session.dart';

class WorkTable extends StatelessWidget {
  const WorkTable({super.key, required this.listWorkSession});

  final ListWorkSession listWorkSession;

  @override
  Widget build(BuildContext context) {
    var users = listWorkSession.getUsers();

    return Column(
        children: ListTile.divideTiles(
            context: context,
            tiles: users.map((user) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppDimens.MAIN_SPACE),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Text(
                        "${users.indexOf(user) + 1}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(fontSize: 22),
                          ),
                          Text(
                            "Worked for ${listWorkSession.getUserWorkDuration(user).toString().split(".")[0]}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.PRIMARY_DARK,
                            ),
                          ),
                          Text(
                            "Break for ${listWorkSession.getUserBreakDuration(user).toString().split(".")[0]}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.SECONDARY,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })).toList());
  }
}
