import 'package:flutter/material.dart';
import 'package:edrawer/constants/theme.dart';
import 'package:edrawer/screens/home_screen.dart';
import 'package:edrawer/components/db_handler.dart';
import 'package:edrawer/constants/model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddFolderPage extends StatefulWidget {
  final int? folderId;
  final String? folderTitle;
  final String? folderColor;
  final bool? updateFolder;

  const AddFolderPage({super.key, this.folderId, this.folderTitle, this.folderColor, this.updateFolder});

  @override
  State<AddFolderPage> createState() => _AddFolderPageState();
}

class _AddFolderPageState extends State<AddFolderPage> {
  DBHelper? dbHelper;
  late Future<List<DossierModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();

    if (widget.folderTitle == null) {
      return;
    } else {
      titleController.text = widget.folderTitle.toString();
    }

    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataListFolder();
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
    if (widget.updateFolder == true && updateCouleur == false) {
      String temp = widget.folderColor!.split('(0x')[1].split(')')[0];
      int valeur = int.parse(temp, radix: 16);
      Color colorFolder = Color(valeur);
      currentColor = colorFolder;
      //pickerColor = colorFolder;
    } else if (widget.updateFolder == true && updateCouleur == true) {
      currentColor = pickerColor;
    }

    //pickerColor = currentColor;

    String appTitle;
    if (widget.updateFolder == true) {
      appTitle = "Édition";
    } else {
      appTitle = "Ajout dossier";
    }

    String temp;
    int valeur;
    Color colorFolder;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            appTitle,
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
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
                        decoration: const InputDecoration(hintText: 'Titre du dossier'),
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
                      if (widget.updateFolder == true)
                        {
                          updateCouleur == true,
                          temp = widget.folderColor!.split('(0x')[1].split(')')[0],
                          valeur = int.parse(temp, radix: 16),
                          colorFolder = Color(valeur),
                          pickerColor = colorFolder,
                        },
                    },
                    child: const Text('Couleur du dossier'),
                  ),
                ],
              ),
              const SizedBox(height: 60),
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
                              //widget.folderTitle = "";
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
                        //color: AppTheme.detailsColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.green, width: 3),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (_fromKey.currentState!.validate()) {
                              if (widget.updateFolder == true) {
                                dbHelper!.updateFolder(
                                  DossierModel(
                                    id: widget.folderId,
                                    title: titleController.text,
                                    folder_color: currentColor.toString(),
                                  ),
                                );
                              } else {
                                dbHelper!.insertFolder(
                                  DossierModel(
                                    title: titleController.text,
                                    folder_color: currentColor.toString(),
                                  ),
                                );
                              }
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
                                return const HomePage();
                              }), (r) {
                                return false;
                              });
                              titleController.clear();
                            }
                          },
                          child: widget.updateFolder == true
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
                if (widget.updateFolder == true) {
                  updateCouleur = true;
                }
                //setState(() => currentColor = pickerColor);
                setState(() => {currentColor = pickerColor, updateCouleur = true});
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
