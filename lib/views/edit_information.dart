import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/user_viewmodel.dart';

class EditInformation extends ConsumerStatefulWidget {
  const EditInformation({super.key, required this.userModel});

  final UserModel userModel;

  @override
  ConsumerState<EditInformation> createState() => _EditInformationState();
}

class _EditInformationState extends ConsumerState<EditInformation> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final professionController = TextEditingController();

  @override
  void initState() {
    emailController.text = widget.userModel.email;
    nameController.text = widget.userModel.fullName;
    professionController.text = widget.userModel.profession;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Text("Edit Information",
                    style: Theme.of(context).textTheme.titleLarge),
                Text(widget.userModel.email,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid name'
                          : null,
                    ),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    TextFormField(
                      controller: professionController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Profession',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid profession'
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style:
                            Theme.of(context).textButtonTheme.style?.copyWith(
                                  foregroundColor:
                                      const WidgetStatePropertyAll<Color>(
                                          AppColors.RED),
                                ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final name = nameController.text.trim();
                          final profession = professionController.text.trim();

                          var updated =
                              await ref.read(usersProvider.notifier).updateUser(
                                    widget.userModel.copyWith(
                                      fullName: name,
                                      profession: profession,
                                    ),
                                  );

                          if (updated) {
                            // ignore: unused_result
                            ref.refresh(userViewModelProvider);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
