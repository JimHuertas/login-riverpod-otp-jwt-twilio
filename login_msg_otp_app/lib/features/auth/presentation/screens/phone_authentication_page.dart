import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:login_msg_otp_app/features/auth/presentation/providers/providers.dart';
import 'package:login_msg_otp_app/features/shared/shared.dart';

class PhoneAuthenticatorScreen extends ConsumerWidget {
  const PhoneAuthenticatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    Future<void> _asyncFunction(WidgetRef ref) async {
      if(!ref.watch(phoneAuthenticatorProvider).isCodeSMSsended){
        await ref.watch(phoneAuthenticatorProvider.notifier).sendMsm();
      }
    }
    _asyncFunction(ref);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                // Icon Banner
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
    final codePhoneForm = ref.watch(phoneAuthenticatorProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            'Verificacion de Número',
            style: textStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
          
          (codePhoneForm.isCodeSMSsended)
          ? Text(
            'Codigo de verificacion enviado a +51 ${ref.read(authProvider).user!.numberPhone}, tienes 60 segundos para digitar el código',
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          )
          : Text(
            'Enviando mensaje...',
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          CustomTextFormField(
            fontSize: 35,
            label: 'Código de verificación',
            keyboardType: TextInputType.number,
            onChanged:
                ref.read(phoneAuthenticatorProvider.notifier).onCodeChange,
            errorMessage: codePhoneForm.isFormPosted
                ? codePhoneForm.codeSMSVerificator.errorMessage
                : null,
          ),
          const SizedBox(height: 40),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Verificar',
                buttonColor: Colors.black,
                onPressed: () {
                  ref.read(phoneAuthenticatorProvider.notifier).onFormSubmit();
                },
              )),
        ],
      ),
    );
  }
}
