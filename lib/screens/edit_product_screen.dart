import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = "/editProduct";

  EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _savedProducrt =
      Product(id: "", title: "", description: "", imageUrl: "", price: 00.00);

  var _init = true;
  var _isLoading = false;
  var _intiState = {
    "title": "",
    "description": "",
    "imageUrl": "",
    "price": "0.00",
  };

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith("http") ||
          !_imageUrlController.text.startsWith("https") ||
          !_imageUrlController.text.endsWith("jpg") ||
          !_imageUrlController.text.startsWith("png") ||
          !_imageUrlController.text.startsWith("jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null && productId != "") {
        _savedProducrt =
            Provider.of<Products>(context).findByID(productId.toString());

        _intiState = {
          "title": _savedProducrt.title,
          "description": _savedProducrt.description,
          "price": _savedProducrt.price.toString(),
          // "imageUrl": _savedProducrt.imageUrl
        };
        _imageUrlController.text = _savedProducrt.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    var valid = _formKey.currentState!.validate();
    if (!valid) {
      return null;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_savedProducrt.id != null && _savedProducrt.id != "") {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_savedProducrt.id, _savedProducrt);

      Navigator.of(context).pushNamed(UserProductScreen.routeName);
      setState(() {
        _isLoading = false;
      });
    } else {
      var p = Product(
        id: DateTime.now().toString(),
        title: _savedProducrt.title,
        description: _savedProducrt.description,
        imageUrl: _savedProducrt.imageUrl,
        price: _savedProducrt.price,
      );
      Provider.of<Products>(context, listen: false)
          .addProduct(_savedProducrt)
          .catchError((err) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error Occured!"),
            content: Text("Something went wrong"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        ).then((value) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushNamed(UserProductScreen.routeName);
        });
      });
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      drawer: AppDrawer(),
      body: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _intiState["title"],
                        decoration: const InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null) {
                            return "Please provide a valid title";
                          }
                          if (value != null && value.isEmpty) {
                            return "Please provide a valid title";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _savedProducrt = Product(
                              id: _savedProducrt.id,
                              title: value as String,
                              description: _savedProducrt.description,
                              imageUrl: _savedProducrt.imageUrl,
                              price: _savedProducrt.price,
                            );
                          }
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                      TextFormField(
                        initialValue: _intiState["price"],
                        decoration: const InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value == null &&
                              (value != null && value.isEmpty)) {
                            return "Please provide a valid price";
                          }
                          if (double.tryParse(value!) == null) {
                            return "Please provide a valid Price";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please provide a value greater than zero";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _savedProducrt = Product(
                              id: _savedProducrt.id,
                              title: _savedProducrt.title,
                              description: _savedProducrt.description,
                              imageUrl: _savedProducrt.imageUrl,
                              price: double.parse(value),
                            );
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: _intiState["description"],
                        decoration:
                            const InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null &&
                              (value != null && value.isEmpty)) {
                            return "Please provide a valid Value";
                          }

                          if (value!.length < 10) {
                            return "Please provide description greater than 10";
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _savedProducrt = Product(
                                id: _savedProducrt.id,
                                title: _savedProducrt.title,
                                description: value,
                                imageUrl: _savedProducrt.imageUrl,
                                price: _savedProducrt.price);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Container(
                              child: _imageUrlController.text.isEmpty
                                  ? Text("No image added.")
                                  : FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _intiState["imageUrl"],
                              focusNode: _imageUrlFocusNode,
                              decoration: const InputDecoration(
                                labelText: "ImageUrl",
                              ),
                              controller: _imageUrlController,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                setState(() {
                                  _imageUrlController.text;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  _imageUrlController.text;
                                });
                              },
                              validator: (value) {
                                if (value == null &&
                                    (value != null && value.isEmpty)) {
                                  return "Please provide a valid Value";
                                }

                                if (value != null) {
                                  if (!value.startsWith("http") &&
                                      !value.startsWith("https")) {
                                    return "Please provide valid URL";
                                  }

                                  if (value.endsWith("jpg")) {
                                  } else if (value.endsWith("png")) {
                                  } else if (value.endsWith("jpeg")) {
                                  } else {
                                    return "Please provide valid image type";
                                  }
                                }

                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  _savedProducrt = Product(
                                    id: _savedProducrt.id,
                                    title: _savedProducrt.title,
                                    description: _savedProducrt.description,
                                    imageUrl: value,
                                    price: _savedProducrt.price,
                                  );
                                }
                              },
                              onFieldSubmitted: (value) => {_saveForm()},
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
    );
  }
}
