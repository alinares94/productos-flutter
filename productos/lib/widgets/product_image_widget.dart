import 'dart:io';

import 'package:flutter/material.dart';

class ProductImageWidget extends StatelessWidget {
  
  final String? image;

  const ProductImageWidget({
    super.key,
    this.image
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Container(
        decoration: _buildBoxDecoration(),
        height: 450,
        width: double.infinity,
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            child: getImage(image),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.black,
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 5)
      )
    ]
  );  

  Widget getImage( String? url ) {
    if (url == null) {
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover
      );
    }

    if (url.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(image!),
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(url),
      fit: BoxFit.cover
    );
  }
}