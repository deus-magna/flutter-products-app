import 'package:formvalidation/src/services/products_service.dart';
import 'package:rxdart/subjects.dart';

import 'package:formvalidation/src/models/product_model.dart';

class ProductosBloc {


  final _productosController = new BehaviorSubject<List<ProductModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productService = new ProductsService();

  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }
}