import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos/providers/providers.dart';
import 'package:productos/services/services.dart';
import 'package:productos/themes/input_decorations.dart';
import 'package:productos/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct!),
      child: _ProductPageBody(productService: productService)
    );
  }
}

class _ProductPageBody extends StatelessWidget {
  const _ProductPageBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImageWidget(image: productService.selectedProduct?.picture ),

                Positioned(
                  top: 60,
                  left: 30,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, size: 40, color: Colors.white)
                  )
                ),

                Positioned(
                  top: 60,
                  right: 30,
                  child: IconButton(
                    onPressed: () async {

                      final picker = ImagePicker();
                      final XFile? file = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100
                      );
                      if (file?.path == null) {
                        return;
                      }
                      productService.updateSelectedProductImage(file!.path);
                    },
                    icon: const Icon(Icons.camera, size: 40, color: Colors.white)
                  )
                )
              ],
            ),

            _ProductForm(),

            const SizedBox(height: 100)
          ],
        ) 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: productService.isSaving
          ? null
          : () async {
              if ( !productFormProvider.isValidForm()) {
                return;
              }

              final url = await productService.uploadImage();
              if (url != null) {
                productFormProvider.product.picture = url;
              }

              await productService.save(productFormProvider.product);
            },
        
        child: productService.isSaving
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductFormProvider>(context);
    final product = productProvider.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 280,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:'
                ),
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '\$${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:'
                ),
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: product.available, 
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productProvider.updateAvailability
              ),
              const SizedBox(height: 30),
            ],
          ) 
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 5)
      )
    ]
  );
}