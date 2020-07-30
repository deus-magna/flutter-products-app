import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/services/products_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productService = ProductsService();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _buildList(),
      floatingActionButton: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.of(context).pushNamed('product'));
  }

  Widget _buildList() {
    return FutureBuilder(
      future: productService.loadProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        final products = snapshot.data;

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) {
              return _buildItem(context, products[i]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productService.deleteProduct(product.id);
      },
      child: Card(
          child: Column(
        children: <Widget>[
          (product.fotoUrl == null)
              ? Image(
                  image: AssetImage('assets/no-image.png'),
                )
              : FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(product.fotoUrl),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
          ListTile(
            title: Text('${product.titulo} - ${product.valor}'),
            subtitle: Text(product.id),
            onTap: () =>
                Navigator.pushNamed(context, 'product', arguments: product)
                    .then((value) => setState(() {})),
          ),
        ],
      )),
    );
  }
}
