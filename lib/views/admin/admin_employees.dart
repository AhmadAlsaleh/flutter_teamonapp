import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/add_employee_page.dart';
import 'package:flutter_teamonapp/widgets/admin/user_widget.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/my_refresh_indicator.dart';

class AdminEmployees extends ConsumerStatefulWidget {
  const AdminEmployees({super.key});

  @override
  ConsumerState<AdminEmployees> createState() => _AdminEmployeesState();
}

class _AdminEmployeesState extends ConsumerState<AdminEmployees> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible == true) {
          setState(() => _isFabVisible = false);
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isFabVisible == false) {
            setState(() => _isFabVisible = true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(usersProvider);

    var data = users.valueOrNull ?? [];
    var isError = users.hasError;
    var isData = users.hasValue;

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(title: const Text("Employees")),
      floatingActionButton: Visibility(
        visible: _isFabVisible,
        child: FloatingActionButton.extended(
            onPressed: _openAddEmployeeScreen,
            label: const Text("Add Employee")),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
            child: TextFormField(
              onChanged: (q) => ref.read(usersProvider.notifier).search(q),
              decoration: const InputDecoration(
                  hintText: 'Search', prefixIcon: Icon(CupertinoIcons.search)),
            ),
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE),
          if (isError) const Expanded(child: MessageWidget()),
          Expanded(
            child: MyRefreshIndicator(
              action: () => ref.read(usersProvider.notifier).fetchData(),
              child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (isData && data.isEmpty)
                      MessageWidget(
                        message: "No Data!",
                        height: AppDimens.screenHeight(context),
                      ),
                    ...ListTile.divideTiles(
                        context: context,
                        tiles: data.map((user) => UserWidget(userModel: user)))
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddEmployeeScreen() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimens.BORDER_RADUIS)),
        ),
        backgroundColor: Colors.white,
        builder: (_) => const AddEmployeePage(),
      );
}
