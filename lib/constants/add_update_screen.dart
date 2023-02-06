import 'package:edrawer/constants/theme/theme.dart';
import 'package:edrawer/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:edrawer/constants/db_handler.dart';
import 'package:edrawer/constants/model.dart';

class AddUpdateFile extends StatefulWidget {
  int? folderId;
  String? folderTitle;
  //String? fileDesc;
  bool? updateFolder;

  AddUpdateFile({
    //Dossier
    this.folderId,
    this.folderTitle,
    this.updateFolder,
    //this.fileDesc,
  });

  @override
  State<AddUpdateFile> createState() => _AddUpdateFileState();
}

class _AddUpdateFileState extends State<AddUpdateFile> {
  DBHelper? dbHelper;
  late Future<List<DossierModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataListFolder();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.folderTitle);
    //final descController = TextEditingController(text: widget.fileDesc);
    String appTitle;
    if (widget.updateFolder == true) {
      appTitle = "Édition";
    } else {
      appTitle = "Ajout dossier";
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(appTitle),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (context) => HomePage(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: titleController,
                        style: TextStyle(
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
                          hintText: "Titre du dossier",
                          hintStyle: TextStyle(
                            color: MyTheme.textColor,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez entrer un titre";
                          }
                          return null;
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
              Container(
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
                              widget.folderTitle = "";
                              //descController.clear();
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
                          onTap: () {
                            if (_fromKey.currentState!.validate()) {
                              if (widget.updateFolder == true) {
                                dbHelper!.updateFolder(
                                  DossierModel(
                                    id: widget.folderId,
                                    title: titleController.text,
                                    //desc: descController.text,
                                  ),
                                );
                              } else {
                                dbHelper!.insertFolder(
                                  DossierModel(
                                    title: titleController.text,
                                    //desc: descController.text,
                                  ),
                                );
                              }
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
                                return HomePage();
                              }), (r) {
                                return false;
                              });
                              titleController.clear();
                            }
                          },
                          child: Container(
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
    );
  }
}
