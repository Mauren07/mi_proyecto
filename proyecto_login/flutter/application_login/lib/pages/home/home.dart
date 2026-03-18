import 'package:application_login/pages/user/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexActual = 0;

  Widget pantallaInicio() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil Usuario'),
              subtitle: const Text('Administrar informacion del usuario'),
              onTap: () {
                Navigator.pushNamed(context, '/form');
              },
            ),
          ),
          const SizedBox(height: 20),
          const Card(
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuracion'),
              subtitle: Text('Configuracion de la aplicacion'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = <Widget>[
      pantallaInicio(),
      const ProfilePage(),
      const Center(child: Text('Cliente')),
      const Center(child: Text('Configuracion')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Mauren Gonzalez'),
              accountEmail: Text('maurendayanna200@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromARGB(255, 50, 150, 213),
                    Color(0xFFA78BFA),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                setState(() {
                  indexActual = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                setState(() {
                  indexActual = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Cliente'),
              onTap: () {
                setState(() {
                  indexActual = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuracion'),
              onTap: () {
                setState(() {
                  indexActual = 3;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar Sesion',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: paginas[indexActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexActual,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            indexActual = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Cliente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuracion',
          ),
        ],
      ),
    );
  }
}
