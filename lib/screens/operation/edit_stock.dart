import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/providers/stocks_provider.dart';
import 'package:stock_manager/services/firebase_storage_service.dart';
import 'package:stock_manager/widgets/input_field.dart';

class EditStock extends StatefulWidget {
  final Item stock;
  const EditStock({super.key, required this.stock});

  @override
  State<EditStock> createState() => _AddNewStockState();
}

class _AddNewStockState extends State<EditStock> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      return;
    }

    final imageName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageUrl =
        await FirebaseStorageService.updateImage(_imageFile!, imageName);

    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  void initState() {
    nameController.text = widget.stock.name;
    itemController.text = widget.stock.count.toString();
    locationController.text = widget.stock.location!;
    _imageUrl = widget.stock.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stock'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () =>
                        _isLoading ? null : _pickImage(ImageSource.gallery),
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : _imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: _imageUrl!,
                                    placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        color: Colors.grey.shade100,
                                        child: const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ))),
                                    errorWidget: (context, url, error) =>
                                        Image.asset('assets/images/stock.png'),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.image,
                                    size: 40,
                                  ),
                      ),
                    ),
                  ),
                  InputField(label: 'Name', controller: nameController),
                  InputField(
                      label: 'Item',
                      controller: itemController,
                      type: TextInputType.number),
                  InputField(
                      label: 'Location',
                      controller: locationController,
                      maxLines: 3),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 24),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          minimumSize: const Size.fromHeight(60),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                // Check if any field has changed
                                bool hasChanged = false;
                                if (nameController.text.trim() !=
                                        widget.stock.name ||
                                    int.parse(itemController.text) !=
                                        widget.stock.count ||
                                    _imageUrl != widget.stock.image ||
                                    locationController.text.trim() !=
                                        widget.stock.location) {
                                  hasChanged = true;
                                }
                                if (hasChanged) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await _uploadImage();
                                  String id = widget.stock.id;
                                  if (context.mounted) {
                                    print('Item saved successfully');
                                    await Provider.of<StocksManager>(context,
                                            listen: false)
                                        .updateStock(Item(
                                            id: id,
                                            name: nameController.text.trim(),
                                            count:
                                                int.parse(itemController.text),
                                            image: _imageUrl ?? '',
                                            location:
                                                locationController.text.trim(),
                                            timeStamp: DateTime.now()
                                                .toIso8601String()));
                                  }
                                } else {
                                  const snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(24),
                                    content:
                                        Text('Please make changes to update'),
                                    duration: Duration(seconds: 3),
                                  );

                                  // Show the snack bar
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }

                                if (context.mounted && hasChanged) {
                                  Navigator.pop(context);
                                }
                              },
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
