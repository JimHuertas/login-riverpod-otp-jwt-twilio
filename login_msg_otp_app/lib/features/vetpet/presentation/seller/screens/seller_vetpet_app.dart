import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';

class SellerVetPetScreen extends ConsumerWidget {
  const SellerVetPetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authProviderRef = ref.watch(authProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(authProvider.notifier).logout(),
        child: const Icon(Icons.exit_to_app),
      ),
      body: const Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 150),
            Text("Vendedor View", style: TextStyle(fontSize: 30)),
            Text('estamos en VetPet...!'),
          ]
        )
      ),
    );
  }
}
