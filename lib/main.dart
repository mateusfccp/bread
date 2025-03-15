import 'package:bread/domain/repositories/gluten_computation_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferencesWithCache.create(
    cacheOptions: SharedPreferencesWithCacheOptions(),
  );

  final glutenComputationRepository = DefaultGlutenComputationRepository(
    sharedPreferences: sharedPreferences,
  );

  final router = createRouter(
    glutenComputationRepository: glutenComputationRepository,
  );

  runApp(App(router: router));
}

final class App extends StatelessWidget {
  const App({super.key, required this.router});

  final RouterConfig<Object> router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bread',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
