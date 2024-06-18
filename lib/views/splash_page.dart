import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';
import 'package:flutter_teamonapp/views/login_page.dart';
import 'package:flutter_teamonapp/views/main_page.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    return authViewModel.when(
      data: (data) => data == null ? LoginPage() : MainPage(),
      error: (e, s) => LoginPage(),
      loading: () => const Scaffold(body: LoadingWidget()),
    );
  }
}
