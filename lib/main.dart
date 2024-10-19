import 'package:flutter/material.dart' hide Stack;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:stacker/screens/create_stack.dart';
import 'package:stacker/screens/home.dart';
import 'package:stacker/screens/login.dart';
import 'package:stacker/screens/profile.dart';
import 'package:stacker/screens/signup.dart';
import 'package:stacker/screens/stack_details.dart';
import 'package:stacker/screens/view_bookings.dart';
import 'package:stacker/services/local.dart';
import 'package:stacker/store/home/home_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/.env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? "",
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? "",
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  bool signedIn = LocalService.isUserSignedIn();
  runApp(MyApp(signedIn: signedIn));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;
  const MyApp({super.key, bool? signedIn}) : isSignedIn = signedIn ?? false;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => HomeStore(),
      child: MaterialApp(
        builder: (context, child) =>
            FTheme(data: FThemes.green.light, child: child!),
        home: isSignedIn ? const HomeScreen() : const SignupScreen(),
        onGenerateRoute: _handleRoutes,
      ),
    );
  }

  Route<dynamic>? _handleRoutes(settings) {
    switch (settings.name) {
      case LoginScreen.route:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case HomeScreen.route:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case StackDetailsScreen.route:
        return MaterialPageRoute(
          builder: (context) => StackDetailsScreen(
            stack: settings.arguments['model'],
            isCreated: settings.arguments['created'],
          ),
        );
      case CreateStackScreen.route:
        return MaterialPageRoute<bool>(
          builder: (context) => const CreateStackScreen(),
        );
      case ProfileScreen.route:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );
      case SignupScreen.route:
        return MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        );
      case ViewBookingsScreen.route:
        return MaterialPageRoute(
          builder: (context) => const ViewBookingsScreen(),
        );
      default:
        throw UnimplementedError();
    }
  }
}
