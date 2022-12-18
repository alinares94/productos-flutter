import 'package:flutter/material.dart';
import 'package:productos/models/models.dart';
import 'package:productos/pages/pages.dart';
import 'package:productos/services/services.dart';
import 'package:productos/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productService.isLoading) return const LoadingPage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: () async {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            }, 
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, int index)  => GestureDetector(
          onTap: () {
            productService.selectedProduct = productService.products[index].clone();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCardWidget(
            product: productService.products[index],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.selectedProduct = Product(
            available: true, 
            name: '', 
            price: 0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}