


import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/preferences/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ProductsService {

    final String _url = 'FIREBASE_URL';
    final _prefs = PreferenciasUsuario(); 

    Future<bool> createproduct( ProductModel product) async {


      final url = '$_url/productos.json?auth=${_prefs.token}';

      final response = await http.post(url, body: productoModelToJson(product) );

      final decodedData = json.decode(response.body);

      print(decodedData);
      return true;
    } 

     Future<List<ProductModel>> loadProductos() async {
      
      final url = '$_url/productos.json?auth=${_prefs.token}';
      final response = await http.get( url );

      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List<ProductModel> products = List();

       if (decodedData == null) return [];

       decodedData.forEach((key, value) { 
         
         final prodTemp = ProductModel.fromJson(value);
         prodTemp.id = key;

         products.add( prodTemp);

       });

       return products;
    }

    Future<int> deleteProduct(String id) async {

      final url = '$_url/productos/$id.json?auth=${_prefs.token}';
      final response = await http.delete( url );

      final decodedData = json.decode(response.body);

      print(decodedData);

      return 1;
    }

    Future<bool> updateproduct( ProductModel product) async {


      final url = '$_url/productos/${product.id}.json?auth=${_prefs.token}';

      final response = await http.put(url, body: productoModelToJson(product) );

      final decodedData = json.decode(response.body);

      print(decodedData);
      return true;
    }

    Future<String> uploadImage(File image) async {

      final url = Uri.parse('CLOUDINARY_URL');
      final mimeType = mime(image.path).split('/');

      final imageUploadRequest = http.MultipartRequest(
        'POST',
        url
      );

      final file = await http.MultipartFile.fromPath(
        'file', 
        image.path, 
        contentType: MediaType( mimeType[0], mimeType[1] )
      );

      // Se pueden adjuntar varios archivos usando varios add()
      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
        print('Algo salio mal');
        print(resp.body);
        return null;
      }

      final respData = json.decode(resp.body);
      print(respData);
      return respData['secure_url'];
    } 
}