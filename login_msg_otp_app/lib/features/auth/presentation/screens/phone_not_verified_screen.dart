import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:login_msg_otp_app/features/auth/presentation/providers/providers.dart';
import 'package:login_msg_otp_app/features/shared/shared.dart';

class PhoneNotVerifiedScreen extends ConsumerWidget {
  const PhoneNotVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.exit_to_app),
              onPressed: () =>
                  ref.read(authProvider.notifier).logout("deslogeado")),
          body: GeometricalBackground(
              child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Icon(
                  Icons.production_quantity_limits_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 80),
                Container(
                  height:
                      size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _CodePhoneForm(),
                )
              ],
            ),
          ))),
    );
  }
}

class _CodePhoneForm extends ConsumerWidget {
  const _CodePhoneForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
  
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    final isPhoneAutheticated = authState.authStatus;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            'El número NECESITA ser verificado',
            style: textStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            (isPhoneAutheticated == AuthStatus.phoneNotAuthenticated) ? authState.user!.numberPhone.toString() : "ERROR usuario no logeado",
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Verificar',
                buttonColor: Colors.black,
                onPressed: ()=> context.push('/phone-authenticator'), 
              )),
        ],
      ),
    );
  }
}
