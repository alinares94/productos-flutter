import 'package:flutter/material.dart';
import 'package:productos/pages/pages.dart';
import 'package:productos/services/services.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await PushService.initializeApp();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const ProductosApp(),
    );
  }
}

class ProductosApp extends StatelessWidget {
  const ProductosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      scaffoldMessengerKey: NotificationService.messengerKey,
      routes: {
        'checkauth': (_) => const CheckAuthPage(),
        'home': (_) => const HomePage(),
        'login': (_) => const LoginPage(),
        'product': (_) => const ProductPage(),
        'register': (_) => const RegisterPage(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 5,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 5
        )
      ),
    );
  }
}