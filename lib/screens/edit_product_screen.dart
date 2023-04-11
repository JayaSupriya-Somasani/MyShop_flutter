import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgEditingController = TextEditingController();
  final _imgFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
  Product(
      id: '',
      title: '',
      description: '',
      price: 0,
      imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': ''
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imgFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute
          .of(context)
          ?.settings
          .arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'imageUrl': '',
          'price': _editedProduct.price.toString()
        };
        _imgEditingController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imgFocusNode.hasFocus) {
      if ((!_imgEditingController.text.startsWith('http') &&
          !_imgEditingController.text.startsWith('https')) ||
          (!_imgEditingController.text.endsWith('.jpg') &&
              !_imgEditingController.text.endsWith('.png') &&
              !_imgEditingController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    final productId = ModalRoute
        .of(context)
        ?.settings
        .arguments as String?;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (productId != null) {
     await Provider.of<Products>(context, listen: false)
          .updateProducts(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
       await showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: const Text("Error occurred"),
                  content: const Text("Something went wrong"),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: const Text("Okay"))
                  ],
                ));
      }

      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    print("product id ${_editedProduct.id}");
    print("product title ${_editedProduct.title}");
    print("product description ${_editedProduct.description}");
    print("product price ${_editedProduct.price}");
    print("product img url ${_editedProduct.imageUrl}");
  }

  @override
  void dispose() {
    _imgFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgEditingController.dispose();
    _imgFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: Form(
        key: _formKey,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: const InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value!,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter title";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(value.toString()),
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please Enter valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please Enter valid number";
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration:
                const InputDecoration(labelText: "Description"),
                textInputAction: TextInputAction.next,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imgFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value!,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Description";
                  }
                  if (value.length < 10) {
                    return "Data should be greater than 10 characters";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imgEditingController.text.isEmpty
                        ? const Text("Enter Image Url")
                        : FittedBox(
                      child: Image.network(
                        _imgEditingController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration:
                      const InputDecoration(labelText: 'ImageUrl'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imgEditingController,
                      focusNode: _imgFocusNode,
                      onFieldSubmitted: (_) => _saveForm,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value!,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (value) {
                        _updateImageUrl();
                        if (value!.isEmpty) {
                          return "Please enter image url";
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return "Please Enter valid URL";
                        }
                        if (!value.endsWith('.jpg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.jpeg')) {
                          return "Please Enter valid image url";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
