import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            title: const Text('Online Medicine'),
            actions: [
              // notification icon
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
              // profile icon
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person),
              ),
            ],
          )),
      // Modern, production-grade drawer
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Main Content Area'),
      ),
    );
  }
}
