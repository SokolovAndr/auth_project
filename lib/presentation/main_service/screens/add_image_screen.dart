import 'dart:io';
import 'package:auth_project/services/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddImageScreen extends StatefulWidget {
  const AddImageScreen({super.key});

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imagePremanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePremanent);
    } on PlatformException catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Добавить изображения',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _buildBody,
    );
  }

  Future<String?> uploadImage(image) async {
    try {
      var url = Uri.parse('http://10.0.2.2:5080/Image');
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      var response = await request.send();
      if (!mounted) return null;
      if (response.statusCode == 200) {
        debugPrint('File uploaded successfully');
        SnackBarService.showSnackBar(
          this.context,
          'Изображение успешно загружено!',
          false,
        );
      } else {
        debugPrint('Failed to upload file: ${response.statusCode}');
      }
      Navigator.pop(this.context);
    } catch (e) {
      SnackBarService.showSnackBar(
        this.context,
        'Вы ничего не выбрали!',
        true,
      );
      debugPrint('Error: $e');
    }
    return null;
  }

  Widget get _buildBody {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          image != null
              ? Image.file(
                  image!,
                  width: 160,
                  height: 160,
                )
              : const FlutterLogo(
                  size: 160,
                ),
          const SizedBox(
            height: 100,
          ),
          buildButton(
              title: 'Выбрать из галереи',
              icon: Icons.image_outlined,
              onClicked: () => pickImage(ImageSource.gallery)),
          const SizedBox(height: 24),
          buildButton(
              title: 'Камера',
              icon: Icons.camera_alt_outlined,
              onClicked: () => pickImage(ImageSource.camera)),
          const SizedBox(height: 24),
          buildButton(
              title: 'Загрузить изображение',
              icon: Icons.upload_file,
              onClicked: () => uploadImage(image)),
        ],
      ),
    );
  }
}

Widget buildButton(
        {required String title,
        required IconData icon,
        required VoidCallback onClicked}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            textStyle: const TextStyle(fontSize: 20)),
        onPressed: onClicked,
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(title)
          ],
        ),
      ),
    );
