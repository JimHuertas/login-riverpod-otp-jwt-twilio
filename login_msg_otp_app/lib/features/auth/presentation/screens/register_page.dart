import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:login_msg_otp_app/features/auth/presentation/providers/providers.dart';
import 'package:login_msg_otp_app/features/auth/presentation/widgets/widgets.dart';
import 'package:login_msg_otp_app/features/shared/shared.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear cuenta',
                    style:
                        textStyles.titleLarge?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              height: size.height - 120, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _RegisterForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Nueva cuenta', style: textStyles.titleSmall),
          const SizedBox(height: 20),
          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.text,
            onChanged: ref.read(registerFormProvider.notifier).onFullNameChange,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Número de celular',
            keyboardType: TextInputType.number,
            onChanged:
                ref.read(registerFormProvider.notifier).onNumberPhoneChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.phoneNumber.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.email.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: (p0) {
              ref.read(registerFormProvider.notifier).onPasswordChange(p0);
              ref
                  .read(registerFormProvider.notifier)
                  .onConfirmPassword(registerForm.rewritedPassword.value);
            },
            errorMessage: registerForm.isFormPosted
                ? registerForm.password.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            onChanged: (p0) {
              ref.read(registerFormProvider.notifier).onConfirmPassword(p0);
              ref.read(registerFormProvider.notifier).onConfirmPasswordChange(p0);
            },
            errorMessage: registerForm.isFormPosted
                ? !registerForm.isPasswordsEquals
                    ? 'Las contraseñas no coinciden'
                    : null
                : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomFilledButton(
                text: 'Crear',
                buttonColor: Colors.black,
                onPressed: () {
                  registerForm.isPosting
                  ? null
                  : ref.read(registerFormProvider.notifier).onFormSubmit();
                  if(registerForm.isValid){
                    showDialog(
                    context: context,
                    builder: (_) => CustomConfirmationDialog(
                      content: Text("¿Estas segur@ que quieres registrarte con el número ${registerForm.phoneNumber.value}?"),
                      onConfirm: () {
                        ref.read(registerFormProvider.notifier).confirmPhone();
                        ref.read(registerFormProvider.notifier).onFormSubmit();
                        Navigator.of(context).pop();
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                  }
                  
                },
              )),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                    context.go('/login');
                  },
                  child: const Text('Ingresa aquí'))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
