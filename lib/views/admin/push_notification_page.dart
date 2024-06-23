import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/push_notification_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/sent_notifications_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';

class PushNotificationPage extends ConsumerStatefulWidget {
  const PushNotificationPage({super.key});

  @override
  ConsumerState<PushNotificationPage> createState() =>
      _PushNotificationPageState();
}

class _PushNotificationPageState extends ConsumerState<PushNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  List<int> selectedUserIds = [];

  @override
  Widget build(BuildContext context) {
    var pushNotifications = ref.watch(sentNotificationsViewModelProvider);
    var users = ref.watch(usersProvider);
    var auth = ref.watch(authViewModelProvider).value;

    if (pushNotifications.isLoading || users.isLoading || auth == null) {
      return const LoadingWidget();
    }

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
                Text("Push Notifications",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                Text(
                  "Content",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid title'
                          : null,
                    ),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    TextFormField(
                      controller: bodyController,
                      textInputAction: TextInputAction.newline,
                      minLines: 3,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Body',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid body'
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                users.when(
                    data: (data) {
                      return Column(
                        children: [
                          CheckboxListTile(
                            value: data.length == selectedUserIds.length,
                            onChanged: (value) {
                              if (value == true) {
                                setState(() {
                                  selectedUserIds =
                                      data.map((u) => u.id).toList();
                                });
                              }
                              if (value == false) {
                                setState(() {
                                  selectedUserIds = [];
                                });
                              }
                            },
                            title: Text(
                              "Receivers",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Card(
                            child: Column(
                              children: ListTile.divideTiles(
                                context: context,
                                tiles: data
                                    .map((u) => CheckboxListTile(
                                          title: Text(u.fullName),
                                          subtitle: Text(u.email),
                                          value: selectedUserIds.contains(u.id),
                                          onChanged: (bool? value) {
                                            if (value == true) {
                                              setState(() {
                                                selectedUserIds =
                                                    selectedUserIds..add(u.id);
                                              });
                                            }

                                            if (value == false) {
                                              setState(() {
                                                selectedUserIds =
                                                    selectedUserIds
                                                      ..remove(u.id);
                                              });
                                            }
                                          },
                                        ))
                                    .toList(),
                              ).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (e, s) => const MessageWidget(),
                    loading: () => const LoadingWidget()),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final title = titleController.text.trim();
                      final body = bodyController.text.trim();

                      var isPuhed = await ref
                          .read(sentNotificationsViewModelProvider.notifier)
                          .pushNotification(
                            PushNotificationModel(
                              title: title,
                              body: body,
                              senderId: auth.userId,
                              userIds: selectedUserIds,
                            ),
                          );

                      try {
                        if (isPuhed) Navigator.pop(context);
                      } catch (e) {}
                    }
                  },
                  child: const Text('Send'),
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
