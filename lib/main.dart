import 'package:flutter/material.dart';
import 'package:incident_tracker/controllers/incident_controller.dart';
import 'package:incident_tracker/controllers/user_controller.dart';
import 'package:incident_tracker/router/index.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => IncidentController(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Incident Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          scaffoldBackgroundColor: primaryGrey2,
          useMaterial3: true,
        ),
        routerDelegate: routes.routerDelegate,
        routeInformationParser: routes.routeInformationParser,
        routeInformationProvider: routes.routeInformationProvider,
      ),
    );
  }
}
