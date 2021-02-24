import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  bool _isInit = true;

  var _initValues = {
    "title": "",
    "price": "",
    "desc": "",
    "imageUrl": "",
  };
  var _editedProduct = Products(
    id: null,
    title: "",
    desc: "",
    imageUrl: "",
    price: 0,
  );

  @override
  void initState() {
    _imageFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "price": _editedProduct.price.toString(),
          "desc": _editedProduct.desc,
          // "imageUrl": _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      } else {
        _imageUrlController.text =
            "https://static.thenounproject.com/png/2034632-200.png";
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // We need to dispose focus node because it will create memory leak
  // or end up taking memory even if app not running
  @override
  void dispose() {
    _imageFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValidate = _form.currentState.validate();
    if (isValidate) {
      _form.currentState.save();
      if (_editedProduct.id != null) {
        Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(_editedProduct);
      }
      Navigator.of(context).pop();
      /*print(_editedProduct.title);
      print(_editedProduct.price);
      print(_editedProduct.desc);
      print(_editedProduct.imageUrl);*/
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues["title"],
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please provide Title";
                  }
                  return null;
                },
                onSaved: (val) {
                  _editedProduct = Products(
                    id: _editedProduct.id,
                    title: val,
                    desc: _editedProduct.desc,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                  initialValue: _initValues["price"],
                  decoration: InputDecoration(
                    labelText: "Price",
                    prefix: Text(
                      "\₹ ",
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(_descFocusNode);
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please provide Price";
                    }
                    if (double.tryParse(val) == null) {
                      return "Enter Number";
                    }
                    if (double.tryParse(val) <= 0) {
                      return "Enter Number greater than 0";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _editedProduct = Products(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      desc: _editedProduct.desc,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(val),
                      isFavorite: _editedProduct.isFavorite,
                    );
                  }),
              TextFormField(
                initialValue: _initValues["desc"],
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                // textInputAction: TextInputAction.next,
                focusNode: _descFocusNode,
                keyboardType: TextInputType.multiline,
                onSaved: (val) {
                  _editedProduct = Products(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    desc: val,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please provide Description";
                  }
                  if (val.length <= 10) {
                    return "Enter description greater than 10 words";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(
                            child: Text(
                              'Enter a URL',
                            ),
                          )
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageFocusNode,
                      onFieldSubmitted: (val) {
                        print(val);
                        _saveForm();
                      },
                      onSaved: (val) {
                        _editedProduct = Products(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          desc: _editedProduct.desc,
                          imageUrl: val,
                          price: _editedProduct.price,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please provide Image Url";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: RaisedButton.icon(
                  onPressed: () {
                    _saveForm();
                  },
                  color: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Save Product",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
