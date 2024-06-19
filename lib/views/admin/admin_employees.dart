import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/add_employee_page.dart';
import 'package:flutter_teamonapp/widgets/admin/user_widget.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';

class AdminEmployees extends ConsumerWidget {
  const AdminEmployees({super.key});

  get error => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(
        title: const Text("Employees", style: TextStyle(fontSize: 22)),
        actions: [
          IconButton(
            onPressed: () => ref.read(usersProvider.notifier).fetchData(),
            icon: const Icon(CupertinoIcons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimens.BORDER_RADUIS)),
          ),
          backgroundColor: Colors.white,
          builder: (_) => const AddEmployeePage(),
        ),
        label: const Text(
          "Add Employee",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: Column(
          children: [
            TextFormField(
              onChanged: (q) => ref.read(usersProvider.notifier).search(q),
              decoration: const InputDecoration(
                  hintText: 'Search', prefixIcon: Icon(CupertinoIcons.search)),
            ),
            const SizedBox(height: AppDimens.MAIN_SPACE),
            users.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const MessageWidget(message: "No Data");
                  }

                  return Expanded(
                      child: ListView(
                          children: data
                              .map((user) => UserWidget(userModel: user))
                              .toList()));
                },
                error: (e, s) => const Expanded(child: MessageWidget()),
                loading: () => const LoadingWidget()),
          ],
        ),
      ),
    );
  }
}
