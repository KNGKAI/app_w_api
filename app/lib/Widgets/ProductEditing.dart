import 'dart:convert';
import 'dart:io';

import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProductEditing extends StatefulWidget {
  final Product product;
  final List<String> categories;

  const ProductEditing({
    @required this.product,
    this.categories,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductEditing> {
  Product _cachedInitialProduct;

  @override
  void initState() {
    _cachedInitialProduct = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: widget.product.name);
    TextEditingController descriptionController =
        TextEditingController(text: widget.product.description);
    TextEditingController sizeController =
        TextEditingController(text: widget.product.size);
    TextEditingController priceController =
        TextEditingController(text: widget.product.price.toString());
    return Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              onChanged: (value) => widget.product.name = value,
              decoration: InputDecoration(
                labelText: "Name:",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              onChanged: (value) => widget.product.description = value,
              decoration: InputDecoration(
                labelText: "Description:",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: sizeController,
              onChanged: (value) => widget.product.size = value,
              decoration: InputDecoration(
                labelText: "Size:",
                border: OutlineInputBorder(),
              ),
            ),
            Divider(),
            Row(
              children: [
                Text("Category:"),
                SizedBox(width: 10.0),
                DropdownButton(
                  value: widget.product.category,
                  items: widget.categories
                      .map((category) => DropdownMenuItem(
                            child: Text(category),
                            value: category,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.product.category = value;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Text("In Stock:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      widget.product.inStock--;
                      if (widget.product.inStock < 0) {
                        widget.product.inStock = 0;
                      }
                    });
                  },
                ),
                Text(widget.product.inStock.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      widget.product.inStock++;
                    });
                  },
                )
              ],
            ),
            Divider(),
            TextField(
              controller: priceController,
              onChanged: (value) => widget.product.price = int.parse(value),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            Divider(),
            widget.product.image == null || widget.product.image.isEmpty
                ? Text("No Image")
                : Image.memory(Base64Decoder().convert(widget.product.image),
                    width: MediaQuery.of(context).size.width / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text("Upload", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () {
                    print('upload');

                    // final _picker = ImagePicker();
                    //
                    // var _pickedImage = await _picker.getImage(source: ImageSource.gallery);
                    //
                    // setState(() {
                    //   image = _pickedImage.path;
                    // });
                  },
                ),
                TextButton(
                  child:
                      Text("Take Photo", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () async {
                    print('take photo');

                    var camera = await availableCameras();
                    var result = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: TakePictureScreen(camera: camera.first),
                      ),
                    );
                    print(result.toString());
                    if (result != null) {
                      setState(() {
                        widget.product.image = result.toString();
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ));
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            print(path);
            var bytes = await File(path).readAsBytes();
            var base64 = base64Encode(bytes);
            Navigator.of(context).pop(base64);
            // If the picture was taken, display it on a new screen.
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DisplayPictureScreen(imagePath: path),
            //   ),
            // );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}
