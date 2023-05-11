import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class EditProductsScreen extends StatefulWidget {
  final String? id;
  EditProductsScreen({this.id});
  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0.0, imageUrl: '');

  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  Future<void> _saveForm() async {
    final productData = Provider.of<Products>(context, listen: false);
    final isVaild = _form.currentState!.validate();
    if (!isVaild) return;

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (widget.id != null) {
      await productData.updateProduct(widget.id!, _editedProduct);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text('Item updated sucessfully!'),
        ),
      );
    } else {
      try {
        await productData.addProduct(_editedProduct);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            content: Text('Item added to products!'),
            action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  productData.undoAddProduct();
                }),
          ),
        );
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                    title: Text('An Error occured!'),
                    content: Text('Something went wrong.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 5),
                              content: Text('Adding failed!'),
                            ));
                          },
                          child: Text('Ok'))
                    ]));
      } // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.pop(context);
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  // var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // _imageUrlController.addListener(() {
    //   setState(() {});
    // });
    final productId = widget.id;
    if (productId != null) {
      final product =
          Provider.of<Products>(context, listen: false).findById(productId);

      _editedProduct = product;
      initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        // 'imageUrl': _editedProduct.imageUrl,
        'imageUrl': '',
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final productId = widget.id;
  //     if (productId != null) {
  //       final product =
  //           Provider.of<Products>(context, listen: false).findById(productId);

  //       _editedProduct = product;
  //       initValues = {
  //         'title': _editedProduct.title,
  //         'description': _editedProduct.description,
  //         'price': _editedProduct.price.toString(),
  //         // 'imageUrl': _editedProduct.imageUrl,
  //         'imageUrl': '',
  //       };
  //       _imageUrlController.text = _editedProduct.imageUrl;
  //     }
  //   }
  //   _isInit = false;

  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _imageUrlController;
    // _imageUrlController.removeListener(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add a product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.8,
                    alignment: Alignment.bottomCenter,
                    image: AssetImage(
                      'assets/images/vision.png',
                    ),
                    // fit: BoxFit.contain,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      key: _form,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          TextFormField(
                            initialValue: initValues['title'],
                            decoration: InputDecoration(labelText: 'Title'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please input a value!';
                              } else {
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onSaved: (newValue) => _editedProduct = Product(
                                id: _editedProduct.id,
                                title: newValue!,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                isFavourite: _editedProduct.isFavourite),
                          ),
                          TextFormField(
                            initialValue: initValues['price'],
                            decoration: InputDecoration(labelText: 'Price'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onSaved: (newValue) => _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: double.parse(newValue!),
                                imageUrl: _editedProduct.imageUrl,
                                isFavourite: _editedProduct.isFavourite),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter a price!';
                              }
                              if (double.tryParse(value) == null) {
                                return 'please enter a number!';
                              }
                              if (double.parse(value) <= 0) {
                                return 'please enter a vaild number.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            initialValue: initValues['description'],
                            decoration:
                                InputDecoration(labelText: 'Description:'),
                            // textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,

                            maxLength: 1500,
                            onSaved: (newValue) => _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: newValue!,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                isFavourite: _editedProduct.isFavourite),
                            validator: (value) {
                              if (value!.length < 10) {
                                return 'should be at leaset 10 characters.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 70,
                                height: 70,
                                child: _imageUrlController.text.isEmpty
                                    ? Center(child: Icon(Icons.photo))
                                    : Image.network(_imageUrlController.text),
                              ),
                              Expanded(
                                child: TextFormField(
                                  // initialValue: initValues['imageUrl'],
                                  decoration: InputDecoration(
                                      labelText: 'Image Link (URL)'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _imageUrlController,
                                  // onFieldSubmitted: (value) => setState(() {}),
                                  onSaved: (newValue) => _editedProduct =
                                      Product(
                                          id: _editedProduct.id,
                                          title: _editedProduct.title,
                                          description:
                                              _editedProduct.description,
                                          price: _editedProduct.price,
                                          imageUrl: newValue!,
                                          isFavourite:
                                              _editedProduct.isFavourite),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter an image URL.';
                                    }
                                    // if (!value.contains('https') &
                                    //     !value.contains('http')) {
                                    //   return 'please enter http/https';
                                    // }
                                    // if (!value.endsWith('jpg') &
                                    //     !value.endsWith('png') &
                                    //     !value.endsWith('jpeg')) {
                                    //   return 'please enter a jpg/jpeg/png formats.';
                                    // }
                                    else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                  foregroundColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                ),
                                onPressed: () {
                                  _saveForm();
                                },
                                label: widget.id != null
                                    ? Text('Update')
                                    : Text('Add'),
                                icon: widget.id != null
                                    ? Icon(Icons.edit)
                                    : Icon(Icons.add),
                              ),
                            ),
                          ),
                        ]),
                      )),
                ),
              ),
            ]),
    );
  }
}
