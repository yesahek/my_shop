import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditProdutScreen extends StatefulWidget {
  const EditProdutScreen({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProdutScreen> createState() => _EditProdutScreenState();
}

class _EditProdutScreenState extends State<EditProdutScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptonFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptonFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))
          // ||
          // (!_imageUrlController.text.endsWith('.png') &&
          //     !_imageUrlController.text.endsWith('.jpg') &&
          //     !_imageUrlController.text.endsWith('.jpeg'))
          ) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            IconButton(
              onPressed: _saveForm,
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                        id: null.toString(),
                        title: newValue.toString(),
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descriptonFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price.';
                      }
                      if (double.tryParse(value.toString()) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.tryParse(value.toString())! <= 0) {
                        return 'Please enter a number greater than zero.';
                      }
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                        id: null.toString(),
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(newValue.toString()),
                        imageUrl: _editedProduct.imageUrl,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Discription'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptonFocusNode,
                    onSaved: (newValue) {
                      _editedProduct = Product(
                        id: null.toString(),
                        title: _editedProduct.title,
                        description: newValue.toString(),
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.length < 10) {
                        return 'Should be at least 10 characters long.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? const Text('Enter a URL')
                            : FittedBox(
                                fit: BoxFit.cover,
                                child: Image.network(_imageUrlController.text),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an image URL';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please enter a valid URL';
                            }
                            // if (!value.endsWith('.png') &&
                            //     !value.endsWith('.jpg') &&
                            //     !value.endsWith('.jpeg')) {
                            //   return 'Please enter a valid image URL';
                            // }
                            return null;
                          },
                          onSaved: (newValue) {
                            _editedProduct = Product(
                              id: null.toString(),
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: newValue.toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
