import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/add_employee_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/employees/add_employee_account.dart';
import 'package:flutter_teamonapp/views/admin/employees/add_employee_personal.dart';
import 'package:flutter_teamonapp/views/admin/employees/add_employee_summary.dart';
import 'package:flutter_teamonapp/views/admin/employees/add_employee_work.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';

class AddEmployee extends ConsumerStatefulWidget {
  const AddEmployee({super.key});

  @override
  ConsumerState<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends ConsumerState<AddEmployee> {
  final PageController _pageController = PageController();
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  void _nextPage() {
    final currentPage = ref.read(currentPageProvider);

    if (_formKeys[currentPage].currentState?.validate() ?? false) {
      if (currentPage < _formKeys.length) {
        ref.read(currentPageProvider.notifier).state = currentPage + 1;

        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    }
  }

  void _previousPage() {
    final currentPage = ref.read(currentPageProvider);

    if (currentPage == 0) Navigator.pop(context);

    if (currentPage > 0) {
      ref.read(currentPageProvider.notifier).state = currentPage - 1;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(usersProvider);

    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(title: const Text("Add Emplyee")),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Checkbox(value: currentPage > 0, onChanged: null),
                      const Text("Account"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Checkbox(value: currentPage > 1, onChanged: null),
                      const Text("Personal"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Checkbox(value: currentPage > 2, onChanged: null),
                      const Text("Work"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.MAIN_SPACE),
            const Divider(),
            const SizedBox(height: AppDimens.MAIN_SPACE),
            if (users.isLoading)
              const Expanded(child: LoadingWidget())
            else
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Form(key: _formKeys[0], child: const AddEmployeeAccount()),
                    Form(key: _formKeys[1], child: const AddEmployeePersonal()),
                    Form(key: _formKeys[2], child: const AddEmployeeWork()),
                    const AddEmployeeSummary(),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _previousPage(),
                    child: const Text('Back'),
                  ),
                  if (currentPage < _formKeys.length)
                    ElevatedButton(
                      onPressed: () => _nextPage(),
                      child: const Text('Next'),
                    ),
                  if (currentPage == _formKeys.length)
                    ElevatedButton(
                      onPressed: () async {
                        AddUserModel addEmpModel =
                            ref.read(addEmployeeProvider.notifier).state!;

                        var isAdded = await ref
                            .read(usersProvider.notifier)
                            .addUser(addEmpModel);

                        try {
                          if (isAdded) {
                            ref.read(addEmployeeProvider.notifier).state = null;
                            ref.read(currentPageProvider.notifier).state = 0;
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                          // ignore: empty_catches
                        } catch (e) {}
                      },
                      child: const Text('Save'),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
