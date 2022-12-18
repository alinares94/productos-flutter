import 'package:flutter/material.dart';
import 'package:productos/pages/pages.dart';
import 'package:productos/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthPage extends StatelessWidget {
   
  const CheckAuthPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: authService.readToken(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Text('Espere');
            }

            Future.microtask(() {
               Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => snapshot.data == ''
                    ? const LoginPage()
                    : const HomePage(),
                  transitionDuration: const Duration( seconds: 0 )
                ));
            });

            return Container();
          },
         )
      ),
    );
  }
}