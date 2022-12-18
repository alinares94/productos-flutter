// To parse this JSON data, do
//
//     final productImage = productImageFromMap(jsonString);

import 'dart:convert';

ProductImage productImageFromMap(String str) => ProductImage.fromMap(json.decode(str));

String productImageToMap(ProductImage data) => json.encode(data.toMap());

class ProductImage {
    ProductImage({
        this.assetId,
        this.publicId,
        this.version,
        this.versionId,
        this.signature,
        this.width,
        this.height,
        this.format,
        this.resourceType,
        this.createdAt,
        this.tags,
        this.bytes,
        this.type,
        this.etag,
        this.placeholder,
        this.url,
        this.secureUrl,
        this.folder,
        this.accessMode,
        this.originalFilename,
    });

    String? assetId;
    String? publicId;
    int? version;
    String? versionId;
    String? signature;
    int? width;
    int? height;
    String? format;
    String? resourceType;
    DateTime? createdAt;
    List<dynamic>? tags;
    int? bytes;
    String? type;
    String? etag;
    bool? placeholder;
    String? url;
    String? secureUrl;
    String? folder;
    String? accessMode;
    String? originalFilename;

    factory ProductImage.fromMap(Map<String, dynamic> json) => ProductImage(
        assetId: json["asset_id"],
        publicId: json["public_id"],
        version: json["version"],
        versionId: json["version_id"],
        signature: json["signature"],
        width: json["width"],
        height: json["height"],
        format: json["format"],
        resourceType: json["resource_type"],
        createdAt: DateTime.parse(json["created_at"]),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        bytes: json["bytes"],
        type: json["type"],
        etag: json["etag"],
        placeholder: json["placeholder"],
        url: json["url"],
        secureUrl: json["secure_url"],
        folder: json["folder"],
        accessMode: json["access_mode"],
        originalFilename: json["original_filename"],
    );

    Map<String, dynamic> toMap() => {
        "asset_id": assetId,
        "public_id": publicId,
        "version": version,
        "version_id": versionId,
        "signature": signature,
        "width": width,
        "height": height,
        "format": format,
        "resource_type": resourceType,
        "created_at": createdAt?.toIso8601String(),
        "tags": tags == null ? List<dynamic>.from(tags!.map((x) => x)) : null,
        "bytes": bytes,
        "type": type,
        "etag": etag,
        "placeholder": placeholder,
        "url": url,
        "secure_url": secureUrl,
        "folder": folder,
        "access_mode": accessMode,
        "original_filename": originalFilename,
    };
}
