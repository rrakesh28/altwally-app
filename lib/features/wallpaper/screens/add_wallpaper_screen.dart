import 'dart:io';

import 'package:alt__wally/common/services/user_service.dart';
import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/features/home/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddWallpaperScreen extends StatefulWidget {
  static const String routeName = '/add-wallpaper-screen';
  const AddWallpaperScreen({super.key});

  @override
  State<AddWallpaperScreen> createState() => _AddWallpaperScreenState();
}

class _AddWallpaperScreenState extends State<AddWallpaperScreen> {
  File? file;

  bool _uploading = false;

  final TextEditingController _nameController = TextEditingController();
  String _category = "";
  final TextEditingController _aspectRatioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _aspectRatioController.dispose();
  }

  Future<int> getFileSize(File file) async {
    try {
      int size = await file.length();
      return size;
    } catch (e) {
      showToast(message: 'Error getting file size: $e');
      return 0;
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        int fileSize = await getFileSize(File(result.files.single.path!));

        double fileSizeInMB = fileSize / (1024 * 1024);
        print('File size in MB: $fileSizeInMB MB');

        if (fileSizeInMB > 2) {
          showToast(message: "Image size shouldn't be greater than 2MB");
          return;
        }

        setState(() {
          file = File(result.files.single.path!);
        });
      }
    } catch (e) {
      showToast(message: 'Error $e');
    }
  }

  void _handleDropdownValueChanged(String selectedValue) {
    setState(() {
      _category = selectedValue;
    });
  }

  String generateUniqueFileName() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    String uuid = const Uuid().v4();

    String userUID = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    return 'file_$timestamp-$uuid-$userUID';
  }

  Future<String> _uploadFileAndGetURL(File file) async {
    User? authenticatedUser = UserService().authUser;

    String? userId = authenticatedUser?.uid;
    try {
      // String fileName = basename(file.path);
      String fileName = generateUniqueFileName();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('wallpapers/$userId/$fileName');

      UploadTask uploadTask = storageReference.putFile(file);

      Completer<String> completer = Completer<String>();

      await uploadTask.whenComplete(() async {
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL);
      });

      return completer.future;
    } catch (e) {
      showToast(message: "Error $e");
      return '';
    }
  }

  void submit(BuildContext context) async {
    setState(() {
      _uploading = true;
    });
    try {
      validateInput();

      String url = await _uploadFileAndGetURL(file!);

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference wallpapers = firestore.collection('wallpapers');
      User? authenticatedUser = UserService().authUser;

      Map<String, dynamic> wallpaper = {
        'userId': authenticatedUser?.uid,
        'image': url,
        'name': _nameController.text,
        'category': _category,
        'aspectRatio': _aspectRatioController.text,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await wallpapers.add(wallpaper);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(index: 3),
        ),
      );
    } catch (e) {
      showToast(message: "Error: $e");
    }

    setState(() {
      _uploading = false;
    });
  }

  void validateInput() {
    if (file == null) {
      showToast(message: "Please select a file");
      throw Exception("File not selected");
    }

    if (_nameController.text.isEmpty) {
      showToast(message: "Please enter a name");
      throw Exception("Name is empty");
    }

    if (_aspectRatioController.text.isEmpty) {
      showToast(message: "Please enter the aspect ratio");
      throw Exception("Aspect ratio is empty");
    }

    if (_category == 'Select Category' || _category.isEmpty) {
      showToast(message: "Please select a category");
      throw Exception("Category not selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Display Your Creations!'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: file != null ? 200 : 0,
                          child: file != null ? Image.file(file!) : Container(),
                        ),
                        Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    file = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                )))
                      ],
                    ),
                  ),
                  Container(
                    child: file != null
                        ? Container()
                        : GestureDetector(
                            onTap: () {},
                            child: DottedBorder(
                              color: Colors.black,
                              strokeWidth: 2,
                              dashPattern: const [5, 5],
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/upload-icon.png',
                                        width: 120,
                                        height: 80,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FilledButton(
                                          onPressed: pickFile,
                                          child: const Text('Click Here')),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 206,
                                        child: Text(
                                          'Bring your screen to life – upload your perfect wallpaper here!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Wallpaper name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Stars in the moon',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  CategoryDropdown(onValueChanged: _handleDropdownValueChanged),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Aspect Ratio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  TextField(
                    controller: _aspectRatioController,
                    decoration: InputDecoration(
                      hintText: '1200 x 800',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child:
                        _uploading ? CircularProgressIndicator() : Container(),
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () {
                        submit(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return const Color(0xFF5EBC8B);
                          },
                        ),
                      ),
                      child: const Text('Upload'),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

const List<String> list = <String>[
  'Select Category',
  'One',
  'Two',
  'Three',
  'Four'
];

class CategoryDropdown extends StatefulWidget {
  final Function(String) onValueChanged;

  const CategoryDropdown({
    Key? key,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? dropdownValue;
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    List<Map<String, dynamic>> categoriesFetched = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String documentId = documentSnapshot.id;
        data['id'] = documentId;
        categoriesFetched.add(data);
      }

      print(categoriesFetched);

      setState(() {
        // dropdownValue = categoriesFetched[0]['id'];
        categories = categoriesFetched;
      });
    } catch (e) {
      showToast(message: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 2.0)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        // icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        underline: Container(
          height: 2,
        ),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
          widget.onValueChanged(dropdownValue!);
        },
        items: categories.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value['id'],
            child: Text(value['name']),
          );
        }).toList(),
      ),
    );
  }
}
