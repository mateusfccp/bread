import 'package:bread/screens/gluten_calculator.dart';
import 'package:bread/screens/temperature_calculator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'domain/repositories/gluten_computation_repository.dart';

GoRouter createRouter({
  required GlutenComputationRepository glutenComputationRepository,
}) {
  return GoRouter(
    initialLocation: '/gluten',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return _NavigationScaffold(
            title: _routeTitle[state.fullPath]!,
            child: child,
          );
        },
        routes: [
          GoRoute(
              path: '/gluten',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: GlutenCalculatorScreen(
                    glutenComputationRepository: glutenComputationRepository,
                  ),
                );
              }),
          GoRoute(
            path: '/temperature',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: TemperatureCalculatorScreen(),
              );
            },
          ),
        ],
      ),
    ],
  );
}

const _routeTitle = {
  '/gluten': 'Calculadora de glúten',
  '/temperature': 'Calculadora de temperatura',
};

class _NavigationScaffold extends StatelessWidget {
  const _NavigationScaffold({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: Builder(builder: (context) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.breakfast_dining),
                title: const Text('Calculadora de glúten'),
                onTap: () {
                  context.go('/gluten');
                  Scaffold.of(context).closeDrawer();
                },
              ),
              ListTile(
                leading: const Icon(Icons.thermostat),
                title: const Text('Calculadora de temperatura'),
                onTap: () {
                  context.go('/temperature');
                  Scaffold.of(context).closeDrawer();
                },
              ),
            ],
          );
        }),
      ),
      body: child,
    );
  }
}
