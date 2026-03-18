import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Column(

        children: [

          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 42, 115, 154),
            padding: const EdgeInsets.symmetric(vertical: 20),

            child: const Column(
              children: [

                Text(
                  "Perfil de Usuario",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 20),

                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Card(

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: const [

                    Text(
                      "Usuario:  hnydt",
                      style: TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Email:  maurendayanna200@gmail.com",
                      style: TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Contraseña: 0725 caracteres)",
                      style: TextStyle(fontSize: 16),
                    ),

                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {},
            child: const Text("Editar Perfil"),
          ),

        ],
      ),
    );
  }
}