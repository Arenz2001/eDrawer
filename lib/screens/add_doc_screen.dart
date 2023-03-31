// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:edrawer/constants/theme.dart';
import 'package:edrawer/screens/camera_page.dart';
import 'package:edrawer/screens/doc_screen.dart';
import 'package:edrawer/components/db_handler.dart';
import 'package:edrawer/constants/model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddDocPage extends StatefulWidget {
  int? fileId;
  String? fileTitle;
  bool? updateFile;
  int? folder_id;
  String? doc_Path;
  String? doc_Color;

  AddDocPage({super.key, this.fileId, this.fileTitle, this.updateFile, this.folder_id, this.doc_Path, this.doc_Color});

  @override
  State<AddDocPage> createState() => _AddDocPageState();
}

class _AddDocPageState extends State<AddDocPage> {
  DBHelper? dbHelper;
  late Future<List<DocModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  late var file = null;
  String file_name = '';
  //var textField = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();

    if (widget.fileTitle == null) {
      return;
    } else {
      titleController.text = widget.fileTitle.toString();
    }

    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataListDoc2();
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  var titleController = TextEditingController();

  bool updateCouleur = false;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.updateFile == true && updateCouleur == false) {
      String temp = widget.doc_Color!.split('(0x')[1].split(')')[0];
      int valeur = int.parse(temp, radix: 16);
      Color colorFolder = Color(valeur);
      currentColor = colorFolder;
      //pickerColor = colorFolder;
    } else if (widget.updateFile == true && updateCouleur == true) {
      currentColor = pickerColor;
    }

    String appTitle;
    if (widget.updateFile == true) {
      appTitle = "Document";
    } else {
      appTitle = "Ajout document";
    }

    //file_name = widget.doc_Path.toString().split('/').last;

    FilePickerResult? result;
    var docPath;
    String temp;
    int valeur;
    Color colorFolder;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DocPage(
              folderId: widget.folder_id,
            ),
          ),
        );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              appTitle,
              style: TextStyle(fontSize: 17),
            ),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DocPage(
                    folderId: widget.folder_id,
                  ),
                ),
              ),
              icon: const Icon(Icons.arrow_back),
            )),
        body: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _fromKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final result = await FilePicker.platform.pickFiles();
                              if (result == null) return;

                              file = result.files.first;
                              //print(file);
                              setState(() {
                                file_name = '${file.name}';

                                //titleController.text = textField.text;
                              });
                            },
                            child: const Text(
                              "Ajouter un fichier",
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              //final cameras = await availableCameras();
                              await availableCameras().then(
                                (value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CameraPage(
                                      cameras: value,
                                      fileId: widget.fileId,
                                      fileTitle: widget.fileTitle,
                                      folder_id: widget.folder_id,
                                      updateFile: widget.updateFile,
                                      doc_Color: currentColor.toString(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Prendre une photo",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Nom du fichier : ${file_name}'),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: "Titre du document",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Veuillez entrer un titre";
                            } else {
                              //textField = titleController;
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentColor,
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: () => {
                        pickColor(context),
                        if (widget.updateFile == true)
                          {
                            updateCouleur == true,
                            temp = widget.doc_Color!.split('(0x')[1].split(')')[0],
                            valeur = int.parse(temp, radix: 16),
                            colorFolder = Color(valeur),
                            pickerColor = colorFolder,
                          },
                      },
                      child: const Text('Couleur du document'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.red, width: 3),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                titleController.clear();
                                widget.fileTitle = "";
                                //ajouter le clear du fichier pick
                                result?.files.clear();
                                file_name = "";
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              height: 55,
                              width: 120,
                              child: const Text(
                                "Effacer",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.green, width: 3),
                          ),
                          child: InkWell(
                            onTap: () async {
                              if (file != null) {
                                final newFile = await saveFilePermanently(file);

                                docPath = newFile.toString();
                                if (docPath.isNotEmpty) {
                                  docPath = docPath.substring(7, docPath.length);
                                  if (docPath.isNotEmpty) {
                                    docPath = docPath.substring(0, docPath.length - 1);
                                  }
                                }
                              } else {
                                docPath = widget.doc_Path;
                              }

                              if (_fromKey.currentState!.validate()) {
                                if (widget.updateFile == true) {
                                  dbHelper!.updateDoc(
                                    DocModel(
                                      id: widget.fileId,
                                      title: titleController.text,
                                      folder_id: widget.folder_id,
                                      doc_path: docPath,
                                      doc_color: currentColor.toString(),
                                    ),
                                  );
                                } else {
                                  dbHelper!.insertDoc(
                                    DocModel(
                                        title: titleController.text,
                                        folder_id: widget.folder_id,
                                        doc_path: docPath,
                                        doc_color: currentColor.toString()),
                                  );
                                }
                                // ignore: use_build_context_synchronously
                                Future.delayed(Duration.zero, () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return DocPage(
                                          folderId: widget.folder_id,
                                        );
                                      },
                                    ),
                                  );
                                  titleController.clear();
                                });
                              }
                            },
                            child: widget.updateFile == true
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    height: 55,
                                    width: 120,
                                    child: const Text(
                                      "Modifier",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    height: 55,
                                    width: 120,
                                    child: const Text(
                                      "Ajouter",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Choisissez une couleur !'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                if (widget.updateFile == true) {
                  updateCouleur = true;
                }
                setState(() => {currentColor = pickerColor, updateCouleur = true});
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
