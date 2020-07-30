import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/services/products_service.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final formKey = GlobalKey<FormState>();
  final scafoldKey = GlobalKey<ScaffoldState>();
  ProductModel product = ProductModel();
  final productsService = ProductsService();
  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual), onPressed: _selectPhoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePicture),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              _showPhoto(),
              _buildName(),
              _buildPrice(),
              _buildAvailable(),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => product.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPrice() {
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => product.valor = double.parse(value),
      validator: (value) {
        if (utils.isANumber(value)) {
          return null;
        } else {
          return 'Ingrese un numero';
        }
      },
    );
  }

  Widget _buildButton() {
    return RaisedButton.icon(
      onPressed: (_saving) ? null : _submit,
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      textColor: Colors.white,
    );
  }

  _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _saving = true;
    });

    if ( photo != null ) {
      product.fotoUrl = await productsService.uploadImage(photo);
    }

    if (product.id == null) {
      productsService.createproduct(product);
    } else {
      productsService.updateproduct(product);
    }
    _showSnack('Nuevo producto guardado');

    Future.delayed(Duration(milliseconds: 1500), () =>  Navigator.pop(context));
  }

  Widget _buildAvailable() {
    return SwitchListTile(
      title: Text('Disponible'),
      value: product.disponible,
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.disponible = value;
      }),
    );
  }

  _showSnack(String mensaje) {
    final snackbar = SnackBar(
        content: Text(mensaje), duration: Duration(milliseconds: 1500));

    scafoldKey.currentState.showSnackBar(snackbar);
  }

  _takePicture() async {
    photo = await ImagePicker.pickImage(
      source: ImageSource.camera
    );

    if ( photo != null ) {
      // limipeza
    }
    setState(() {});

  }

  Widget _showPhoto() {

    if( product.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage(product.fotoUrl),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _selectPhoto() async{
    photo = await ImagePicker.pickImage(
      source: ImageSource.gallery
    );

    if ( photo != null ) {
      product.fotoUrl = null;
    }
    setState(() {});
  }
}
