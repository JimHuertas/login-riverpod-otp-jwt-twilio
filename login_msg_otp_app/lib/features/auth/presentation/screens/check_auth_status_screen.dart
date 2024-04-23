import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:login_msg_otp_app/features/auth/presentation/providers/providers.dart';

class CheckStatusScreen extends ConsumerWidget {
  const CheckStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      next;
      context.go('/');
    });

    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    ));
  }
}
