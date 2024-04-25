import 'package:flutter/material.dart';
import 'package:stock_manager/widgets/custom_button.dart';
import 'package:stock_manager/widgets/input_field.dart';
class AddNewStock extends StatefulWidget {
  const AddNewStock({super.key});

  @override
  State<AddNewStock> createState() => _AddNewStockState();
}

class _AddNewStockState extends State<AddNewStock> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Stock'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key:  formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Image.asset('assets/images/upload_image.png',width: 150),
                  ),
                  InputField(label: 'Name', controller: nameController),
                  InputField(label: 'Item', controller: itemController,type: TextInputType.number),
                  InputField(label: 'Location', controller: locationController,maxLines: 3),
                  CustomButton(label: 'Save', onPressed: (){})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
