import 'dart:io';

import 'package:edrawer/constants/theme/theme.dart';
import 'package:edrawer/screens/camera_page.dart';
//import 'package:edrawer/screens/home_screen.dart';
import 'package:edrawer/screens/doc_screen.dart';
import 'package:flutter/material.dart';
import 'package:edrawer/constants/db_handler.dart';
import 'package:edrawer/constants/model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';

class DocUpdateFile extends StatefulWidget {
  int? fileId;
  String? fileTitle;
  bool? updateFile;
  int? folder_id;
  String? doc_Path;

  DocUpdateFile({
    // Documents
    this.fileId,
    this.fileTitle,
    this.updateFile,
    this.folder_id,
    this.doc_Path,
  });

  @override
  State<DocUpdateFile> createState() => _DocUpdateFileState();
}

class _DocUpdateFileState extends State<DocUpdateFile> {
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

  @override
  Widget build(BuildContext context) {
    //titleController.text = widget.fileTitle.toString();
    String appTitle;
    if (widget.updateFile == true) {
      appTitle = "Document";
    } else {
      appTitle = "Ajout document";
    }

    //file_name = widget.doc_Path.toString().split('/').last;

    FilePickerResult? result;
    var docPath;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(
          MaterialPageRoute(
            builder: (context) => DocScreen(
              folderId: widget.folder_id,
            ),
          ),
        );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(appTitle),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(
                MaterialPageRoute(
                  builder: (context) => DocScreen(
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
                              style: TextStyle(
                                color: MyTheme.backColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final cameras = await availableCameras();
                              await availableCameras().then(
                                (value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CameraPage(
                                      cameras: value,
                                      fileId: widget.fileId,
                                      fileTitle: widget.fileTitle,
                                      folder_id: widget.folder_id,
                                      updateFile: widget.updateFile,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Prendre une photo",
                              style: TextStyle(
                                color: MyTheme.backColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Nom du fichier : ${file_name}'),
                      const SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: titleController,
                          style: const TextStyle(
                            color: MyTheme.textColor,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyTheme.textColor,
                              ),
                            ),
                            labelStyle: TextStyle(color: MyTheme.textColor),
                            //hintText: "Titre du document",
                            hintText: "Titre du document",
                            hintStyle: TextStyle(
                              color: MyTheme.textColor,
                            ),
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
                const SizedBox(height: 40),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
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
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: () async {
                              //file = widget.doc_Path;
                              if (file != null) {
                                final newFile = await saveFilePermanently(file);
                                //print('From path : ${file.path!}');
                                //print('to path : ${newFile.path}');

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
                                    ),
                                  );
                                } else {
                                  dbHelper!.insertDoc(
                                    DocModel(
                                      title: titleController.text,
                                      folder_id: widget.folder_id,
                                      doc_path: docPath,
                                    ),
                                  );
                                }
                                // ignore: use_build_context_synchronously
                                Future.delayed(Duration.zero, () {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return DocScreen(
                                      folderId: widget.folder_id,
                                    );
                                  }), (r) {
                                    return false;
                                  });
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
}
