import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _showMessageSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _login() async {
    final String user = userController.text.trim();
    final String pass = passController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      _showMessageSnackBar('Por favor, completa todos los campos', false);
      return;
    }

    if (user.length < 3) {
      _showMessageSnackBar(
        'El usuario debe tener al menos 3 caracteres',
        false,
      );
      return;
    }

    if (pass.length < 6) {
      _showMessageSnackBar(
        'La contrasena debe tener al menos 6 caracteres',
        false,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> loginResponse = await ApiService.login(
        user,
        pass,
      );

      if (!mounted) {
        return;
      }

      if (loginResponse['success'] != true) {
        _showMessageSnackBar(
          loginResponse['message'] as String? ?? 'No fue posible iniciar sesion',
          false,
        );
        return;
      }

      _showMessageSnackBar(
        loginResponse['message'] as String? ?? 'Login exitoso',
        true,
      );

      userController.clear();
      passController.clear();

      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, '/user-statuses');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessageSnackBar('Error inesperado: $error', false);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Image.asset(
                'assets/img/logos/dart.png',
                height: 96,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: userController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: 'Usuario *',
                  hintText: 'Ingresa tu usuario',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passController,
                enabled: !isLoading,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contrasena *',
                  hintText: 'Ingresa tu contrasena',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Ingresar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
