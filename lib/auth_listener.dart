// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mawy_dashboard/auth_provider.dart';

// class AuthListener extends ConsumerStatefulWidget {
//   const AuthListener({super.key});

//   @override
//   ConsumerState<AuthListener> createState() => _AuthListenerState();
// }

// class _AuthListenerState extends ConsumerState<AuthListener> {
//   @override
//   void initState() {
//     super.initState();
//     // Listen to auth state changes.
//     ref.listen<AuthState>(authNotifierProvider, (previous, next) {
//       if (previous?.isLoggedIn == false && next.isLoggedIn == true) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else if (previous?.isLoggedIn == true && next.isLoggedIn == false) {
//         Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); // This widget exists solely for side effects.
//   }
// }
