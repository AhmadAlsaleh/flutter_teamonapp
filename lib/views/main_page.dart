import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/work_step_model.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';
import 'package:flutter_teamonapp/views/home_page.dart';
import 'package:flutter_teamonapp/views/notifications_page.dart';
import 'package:flutter_teamonapp/views/profile_page.dart';
import 'package:flutter_teamonapp/widgets/work_session_step.dart';

class MainPage extends ConsumerWidget {
  MainPage({super.key});

  final _pages = [
    const HomePage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageIndex = ref.watch(selectedMainPageIndexProvider);
    final selectedDate = ref.watch(selectedMainDateProvider);
    final sessionsAsync = ref.watch(workSessionViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: _pages[selectedPageIndex],
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: (selectedPageIndex == 0 &&
              selectedDate.getDate() == DateTime.now().getDate())
          ? sessionsAsync.when(
              data: (data) {
                var session = data.firstOrNull;

                int workStarts = session?.workSteps
                        .where((step) => step.type == "start_work")
                        .length ??
                    0;
                int workEnds = session?.workSteps
                        .where((step) => step.type == "end_work")
                        .length ??
                    0;
                int breakStarts = session?.workSteps
                        .where((step) => step.type == "start_break")
                        .length ??
                    0;
                int breakEnds = session?.workSteps
                        .where((step) => step.type == "end_break")
                        .length ??
                    0;

                return ExpandableFab(
                  type: ExpandableFabType.fan,
                  overlayStyle: ExpandableFabOverlayStyle(blur: 5),
                  openButtonBuilder: RotateFloatingActionButtonBuilder(
                    child: const Icon(CupertinoIcons.list_dash),
                    fabSize: ExpandableFabSize.regular,
                    foregroundColor: AppColors.WHITE,
                    backgroundColor: AppColors.PRIMARY_DARK,
                  ),
                  closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                    child: const Icon(Icons.close),
                    fabSize: ExpandableFabSize.small,
                    foregroundColor: AppColors.PRIMARY_DARK,
                    backgroundColor: AppColors.WHITE,
                  ),
                  children: [
                    if (workStarts == workEnds &&
                        selectedDate.getDate() == DateTime.now().getDate())
                      FloatingActionButton.extended(
                        foregroundColor: AppColors.WHITE,
                        backgroundColor: AppColors.PRIMARY_DARK,
                        extendedTextStyle: const TextStyle(fontSize: 22),
                        label: const Text("Start Work"),
                        onPressed: () {
                          if (session == null) {
                            ref
                                .read(workSessionViewModelProvider.notifier)
                                .startSession();
                          } else {
                            ref
                                .read(workSessionViewModelProvider.notifier)
                                .addStep(
                                  WorkStepModel(
                                    id: 0,
                                    workSessionId: session.id,
                                    dateTime: DateTime.now(),
                                    type: WorkSessionStep.START_WORK,
                                  ),
                                );
                          }
                        },
                      ),
                    if ((workStarts > workEnds) && (breakStarts == breakEnds))
                      FloatingActionButton.extended(
                        foregroundColor: AppColors.WHITE,
                        backgroundColor: AppColors.PRIMARY_DARK,
                        extendedTextStyle: const TextStyle(fontSize: 22),
                        label: const Text("Start Break"),
                        onPressed: () {
                          ref
                              .read(workSessionViewModelProvider.notifier)
                              .addStep(
                                WorkStepModel(
                                  id: 0,
                                  workSessionId: session!.id,
                                  dateTime: DateTime.now(),
                                  type: WorkSessionStep.START_BREAK,
                                ),
                              );
                        },
                      ),
                    if ((workStarts > workEnds) && (breakStarts > breakEnds))
                      FloatingActionButton.extended(
                        foregroundColor: AppColors.WHITE,
                        backgroundColor: AppColors.PRIMARY_DARK,
                        extendedTextStyle: const TextStyle(fontSize: 22),
                        label: const Text("End Break"),
                        onPressed: () {
                          ref
                              .read(workSessionViewModelProvider.notifier)
                              .addStep(
                                WorkStepModel(
                                  id: 0,
                                  workSessionId: session!.id,
                                  dateTime: DateTime.now(),
                                  type: WorkSessionStep.END_BREAK,
                                ),
                              );
                        },
                      ),
                    if ((workStarts > workEnds) && (breakStarts == breakEnds))
                      FloatingActionButton.extended(
                        foregroundColor: AppColors.WHITE,
                        backgroundColor: AppColors.PRIMARY_DARK,
                        extendedTextStyle: const TextStyle(fontSize: 22),
                        label: const Text("End Work"),
                        onPressed: () {
                          ref
                              .read(workSessionViewModelProvider.notifier)
                              .addStep(
                                WorkStepModel(
                                  id: 0,
                                  workSessionId: session!.id,
                                  dateTime: DateTime.now(),
                                  type: WorkSessionStep.END_WORK,
                                ),
                              );
                        },
                      ),
                  ],
                );
              },
              error: (e, s) => Container(),
              loading: () => Container(),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.PRIMARY,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: selectedPageIndex,
        onTap: (index) =>
            ref.read(selectedMainPageIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
