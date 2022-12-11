import 'package:flutter/material.dart';
import 'package:productos/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos')
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index)  => ProductCardWidget()
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {},
      ),
    );
  }
}