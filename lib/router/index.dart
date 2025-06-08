import 'package:go_router/go_router.dart';
import 'package:incident_tracker/views/add_incident_screen.dart';
import 'package:incident_tracker/views/home_screen.dart';
import 'package:incident_tracker/views/incident_details.dart';
import 'package:incident_tracker/views/login_screen.dart';
import 'package:incident_tracker/views/splash_screen.dart';
import 'package:incident_tracker/views/update_incident_screen.dart';

abstract class AppRoutes {
  static const String splashScreen = '/';
  static const String loginScreen = '/login-screen';
  static const String homeScreen = '/home-screen';
  static const String addIncidentScreen = '/add-incident-screen';
  static const String incidentDetailsScreen = '/incident-details-screen';
  static const String updateIncidentScreen = '/edit-incident-screen';
}

final routes = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.loginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.homeScreen,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.addIncidentScreen,
      builder: (context, state) => const AddIncidentScreen(),
    ),
    GoRoute(
      path: AppRoutes.incidentDetailsScreen,
      builder: (context, state) => const IncidentDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.updateIncidentScreen,
      builder: (context, state) => const UpdateIncidentScreen(),
    ),
  ],
);
