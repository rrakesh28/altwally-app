import 'dart:io';

import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/core/common/widgets/validation_error_widget.dart';
import 'package:alt__wally/features/app/presentation/pages/app_screen.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/category/presentation/cubit/get_categories_cubit/category_cubit.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/add_wallpaper/add_wallpaper_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:image_cropper/image_cropper.dart';

class AddWallpaperScreen extends StatefulWidget {
  static const String routeName = '/add-wallpaper-screen';
  const AddWallpaperScreen({super.key});

  @override
  State<AddWallpaperScreen> createState() => _AddWallpaperScreenState();
}

class _AddWallpaperScreenState extends State<AddWallpaperScreen> {
  File? file;

  final TextEditingController _nameController = TextEditingController();
  String _category = "";
  int _fileSize = 0;
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _heightController.dispose();
    _widthController.dispose();
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
        setState(() {
          _fileSize = (fileSize / (1024 * 1024))
              .round()
              .clamp(1, double.infinity)
              .toInt();
        });

        // double fileSizeInMB = fileSize / (1024 * 1024);

        // if (fileSizeInMB > 2) {
        //   showToast(message: "Image size shouldn't be greater than 2MB");
        //   return;
        // }

        setState(() {
          file = File(result.files.single.path!);
        });
        _cropImage();
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

  void submit(BuildContext context) async {
    try {
      validateInput();

      WallpaperEntity wallpaper = WallpaperEntity(
        categoryId: _category,
        title: _nameController.text,
        image: file,
        size: _fileSize,
        height: int.tryParse(_heightController.text),
        width: int.tryParse(_widthController.text),
      );

      BlocProvider.of<AddWallpaperCubit>(context).submit(wallpaper);
    } catch (e) {
      showToast(message: "Error: $e");
    }
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

    if (_heightController.text.isEmpty || _widthController.text.isEmpty) {
      showToast(message: "Please enter the aspect ratio");
      throw Exception("Aspect ratio is empty");
    }

    if (_category == 'Select Category' || _category.isEmpty) {
      showToast(message: "Please select a category");
      throw Exception("Category not selected");
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file!.path,
      aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 16),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      File? convertedFile = File(croppedFile.path);
      setState(() {
        file = convertedFile;
      });
    } else {
      setState(() {
        file = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: const Text(
          'Display Your Creations!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AddWallpaperCubit, AddWallpaperState>(
          listener: (context, addWallpaperState) {
        if (addWallpaperState is AddWallpaperSuccess) {
          showToast(message: "Wallpaper Added Successfully!!");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AppScreen(index: 3),
            ),
          );
        }
        if (addWallpaperState is AddWallpaperFailed) {
          showToast(message: addWallpaperState.errorMessage);
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
          reverse: true,
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
                        child: file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  file!,
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
                if (file != null)
                  Center(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          file = null;
                        });
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    SizedBox(
                                      width: 206,
                                      child: Text(
                                        'Bring your screen to life – upload your perfect wallpaper here!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w200,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                if (state is AddWallpaperFailed)
                  ValidationErrorWidget(state: state, fieldName: 'image'),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Wallpaper name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Stars in the moon',
                  ),
                ),
                if (state is AddWallpaperFailed)
                  ValidationErrorWidget(state: state, fieldName: 'title'),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Collection',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                MyDropdown(onValueChanged: _handleDropdownValueChanged),
                if (state is AddWallpaperFailed)
                  ValidationErrorWidget(state: state, fieldName: 'category'),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Aspect Ratio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _heightController,
                        decoration: const InputDecoration(
                          hintText: '1200',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('X'),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _widthController,
                        decoration: const InputDecoration(
                          hintText: '800',
                        ),
                      ),
                    ),
                  ],
                ),
                if (state is AddWallpaperFailed)
                  ValidationErrorWidget(state: state, fieldName: 'height'),
                if (state is AddWallpaperFailed)
                  ValidationErrorWidget(state: state, fieldName: 'width'),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const [
                      TextSpan(text: 'Note: '),
                      TextSpan(
                        text: 'Copyrighted, Reported, or Sensitive',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                          text:
                              ' wallpapers may not be approved or can be removed permanently from the app without any prior notice.'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () {
                    submit(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.black,
                  ),
                  child: state is AddWallpaperLoading
                      ? const SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Upload",
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    ));
  }
}

class MyDropdown extends StatefulWidget {
  final Function(String) onValueChanged;

  const MyDropdown({super.key, required this.onValueChanged});
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  List<CategoryEntity> _categories = [];

  CategoryEntity? _selectedCategory;

  @override
  void initState() {
    super.initState();
    CategoryState currentState = BlocProvider.of<CategoryCubit>(context).state;

    if (currentState is CategoryInitial ||
        currentState is CategoriesLoadingFailed) {
      BlocProvider.of<CategoryCubit>(context).getCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          _categories = state.categories;
          return DropdownButton<CategoryEntity>(
            isExpanded: true,
            value: _selectedCategory,
            onChanged: (CategoryEntity? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
              widget.onValueChanged(newValue!.id.toString());
            },
            items: _categories.map<DropdownMenuItem<CategoryEntity>>(
                (CategoryEntity category) {
              return DropdownMenuItem<CategoryEntity>(
                value: category,
                child: Text(category.name!),
              );
            }).toList(),
          );
        } else if (state is CategoriesLoadingFailed) {
          return const Text('Error loading categories');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
