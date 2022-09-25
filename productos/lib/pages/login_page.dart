import 'package:flutter/material.dart';
import 'package:productos/providers/login_form_provider.dart';
import 'package:productos/themes/input_decorations.dart';
import 'package:productos/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackgroundWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 200),
              CardContainerWidget(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 20),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                  ]
                )
              ),
              const SizedBox(height: 50),
              const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 50),
            ])
          )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();


  @override
  Widget build(BuildContext context) {

    final loginProvider = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginProvider.formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => loginProvider.email = value,
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? null 
                : 'El formato del correo no es correcto';
            },
            decoration: InputDecorations.authInputDecoration(labelText: 'Email', hintText: 'nombre@dominio.com', prefixIcon: Icons.alternate_email_outlined),
          ),

          const SizedBox(height: 20),

          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            onChanged: (value) => loginProvider.pwd = value,
            validator: (value) {
              
              return value != null && value.length >= 6
                ? null
                : 'Debe contener al menos 6 caractéres';
            },
            decoration: InputDecorations.authInputDecoration(labelText: 'Contraseña', hintText: '*****', prefixIcon: Icons.lock_outline),
          ),

          const SizedBox(height: 20),

          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            disabledColor: Colors.grey,
            color: Colors.deepPurple,
            onPressed: loginProvider.isLoading ? null : () async {
              FocusScope.of(context).unfocus();
              if (!loginProvider.isValidForm()) {
                return;
              }
              loginProvider.isLoading = true;
              await Future.delayed(const Duration(seconds: 2));
              loginProvider.isLoading = false;
              // ignore: use_build_context_synchronously
              await Navigator.pushReplacementNamed(context, 'home');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: const Text('Ingresar', style: TextStyle(color: Colors.white))
            )
          )
        ]
      )
    );
  }
}