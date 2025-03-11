import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mawy_dashboard/auth_provider.dart';
import 'package:mawy_dashboard/theme_provider.dart';
import 'package:mawy_dashboard/views/auth.dart';
import 'package:mawy_dashboard/views/home.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme provider.
    final themeMode = ref.watch(themeNotifierProvider);
    // Watch authentication state to decide which initial screen to display.
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routes: {
        '/':
            (ctx) =>
                authState.isLoggedIn
                    ? HomePage(tPY: '', loadStatic: true)
                    : LoginPage(),
      },
    );
  }
}
