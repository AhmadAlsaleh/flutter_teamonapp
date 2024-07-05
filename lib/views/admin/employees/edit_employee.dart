import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/add_employee_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/employees/add_employee_personal.dart';
import 'package:flutter_teamonapp/views/admin/employees/add_employee_work.dart';
import 'package:flutter_teamonapp/views/admin/employees/edit_employee_summary.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';

class EditEmployee extends ConsumerStatefulWidget {
  const EditEmployee({super.key, required this.userModel});

  final UserModel userModel;

  @override
  ConsumerState<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends ConsumerState<EditEmployee> {
  final PageController _pageController = PageController();
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addEmployeeProvider.notifier).state = AddUserModel().copyWith(
        fullName: widget.userModel.fullName,
        email: widget.userModel.email,
        role: widget.userModel.role,
        profession: widget.userModel.profession,
        salary: widget.userModel.salary,
        workHours: widget.userModel.workHours,
        breakHours: widget.userModel.breakHours,
        workdays: widget.userModel.workdays,
      );
    });
  }

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
      appBar: AppBar(
        title: Text(widget.userModel.email),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    children: [
                      Checkbox(value: true, onChanged: null),
                      Text("Account"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Checkbox(value: currentPage > 0, onChanged: null),
                      const Text("Personal"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Checkbox(value: currentPage > 1, onChanged: null),
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
                    Form(key: _formKeys[0], child: const AddEmployeePersonal()),
                    Form(key: _formKeys[1], child: const AddEmployeeWork()),
                    const EditEmployeeSummary(),
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

                        var isUpdated =
                            await ref.read(usersProvider.notifier).updateUser(
                                  widget.userModel.copyWith(
                                    fullName: addEmpModel.fullName,
                                    email: addEmpModel.email,
                                    role: addEmpModel.role,
                                    profession: addEmpModel.profession,
                                    salary: addEmpModel.salary,
                                    workHours: addEmpModel.workHours,
                                    breakHours: addEmpModel.breakHours,
                                    workdays: addEmpModel.workdays,
                                  ),
                                );

                        try {
                          if (isUpdated) {
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
