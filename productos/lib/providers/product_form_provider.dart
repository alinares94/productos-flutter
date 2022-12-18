import 'package:flutter/material.dart';
import 'package:productos/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  
  ProductFormProvider( this.product );

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  Product product;

  void updateAvailability(bool available) {
    product.available = available;
    notifyListeners();
  }

  bool isValidForm() {

    return formKey.currentState?.validate() ?? false;
  }
}