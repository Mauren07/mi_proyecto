import 'package:flutter/material.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool estadoUsuario = false;

  String resultado = "";

  void guardarUsuario() {

    String estado = estadoUsuario ? "Activo" : "Inactivo";

    setState(() {

      resultado =
          "Nombre: ${nameController.text}\nEmail: ${emailController.text}\nEstado: $estado";

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Formulario Usuario"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nombre",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 20),

            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  "Estado del Usuario",
                  style: TextStyle(fontSize: 16),
                ),

                Switch(
                  value: estadoUsuario,

                  onChanged: (value) {

                    setState(() {

                      estadoUsuario = value;

                    });

                  },
                ),

              ],

            ),

            Text(
              estadoUsuario ? "Activo" : "Inactivo",
              style: TextStyle(
                fontSize: 16,
                color: estadoUsuario ? Colors.lightBlueAccent : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(

              onPressed: guardarUsuario,

              child: const Text("Guardar Usuario"),

            ),

            const SizedBox(height: 20),

            Text(
              resultado,
              style: const TextStyle(fontSize: 18),
            )

          ],

        ),
      ),

    );
  }
}