import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-projects-6b114-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Product? selectedProduct;
  File? selectedProductFile;
  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future save( Product product ) async {

    isSaving = true;
    notifyListeners();

    if ( product.id == null ) {
      await insert(product);
    } else {
      await update(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> insert( Product product ) async {
    final url = Uri.https( _baseUrl, 'Products.json' , {
      'auth': await _storage.read(key: 'token') ?? ''
    });
    final resp = await http.post(url, body: json.encode(product.toMap()));
    
    product.id = json.decode(resp.body)['name'];
    products.add(product);

    return product.id!;
  }

  Future<String> update( Product product ) async {
    final url = Uri.https( _baseUrl, 'Products/${product.id}.json' , {
      'auth': await _storage.read(key: 'token') ?? ''
    });
    await http.put(url, body: json.encode(product.toMap()));

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    
    return product.id!;
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    
    final url = Uri.https( _baseUrl, 'Products.json', {
      'auth': await _storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url);
    final Map<String, dynamic> respMap = json.decode(resp.body);
    
    respMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;

      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future<String?> uploadImage() async {

    if (selectedProductFile == null) {
      return null;
    }

    isSaving = true;
    notifyListeners();
    
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dsh7zohms/image/upload?upload_preset=t5bvgovh');
    
    final request = http.MultipartRequest( 'POST', url );
    final requestFile = await http.MultipartFile.fromPath('file', selectedProductFile!.path );
    request.files.add(requestFile);
    
    final stream = await request.send();
    final response = await http.Response.fromStream(stream);

    if (response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }

    final entity = ProductImage.fromMap(json.decode(response.body));
    selectedProductFile = null;
    
    return entity.secureUrl;
  }

  void updateSelectedProductImage( String path ) {
    selectedProduct?.picture = path;
    selectedProductFile = File.fromUri( Uri(path: path) );

    notifyListeners();
  }
}