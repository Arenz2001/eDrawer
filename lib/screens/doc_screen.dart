import 'dart:ffi';

import 'package:edrawer/constants/add_update_screen.dart';
import 'package:edrawer/constants/db_handler.dart';
import 'package:edrawer/constants/doc_update_screen.dart';
import 'package:edrawer/constants/model.dart';
import 'package:edrawer/screens/consult_doc.dart';
import 'package:edrawer/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:edrawer/constants/theme/theme.dart';

class DocScreen extends StatefulWidget {
  int? folderId;

  DocScreen({
    this.folderId,
  });

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  DBHelper? dbHelper;
  late Future<List<DocModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataListDoc(widget.folderId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onWillPop: () async {
      //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route route) => false);
      //  return Future.value(true);
      //},
      onWillPop: () async {
        Navigator.of(context).pop(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text("eDrawer - Documents"),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () async {
                Navigator.of(context).pop(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                return Future.value(true);
              },
              icon: const Icon(Icons.arrow_back),
            )),
        body: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<DocModel>> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Pas de documents",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.textColor,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        int fileId = snapshot.data![index].id!.toInt();
                        String fileTitle = snapshot.data![index].title.toString();
                        int folderId = snapshot.data![index].folder_id!.toInt();
                        String docPath = snapshot.data![index].doc_path.toString();
                        //String fileDesc = snapshot.data![index].desc.toString();
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          //Rajouter un truc en mode etes vous sur
                          child: Dismissible(
                            confirmDismiss: (DismissDirection direction) async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Êtes-vous sûr ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Non'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Oui'),
                                      )
                                    ],
                                  );
                                },
                              );
                              return confirmed;
                            },
                            key: ValueKey<int>(fileId),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.redAccent,
                              child: const Icon(
                                Icons.delete_forever,
                                color: MyTheme.textColor,
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.deleteDoc(fileId);
                                dataList = dbHelper!.getDataListDoc(folderId);
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: GestureDetector(
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DocUpdateFile(
                                        fileId: fileId,
                                        folder_id: folderId,
                                        fileTitle: fileTitle,
                                        doc_Path: docPath,
                                        updateFile: true,
                                      ),
                                    ));
                              },
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConsultPage(
                                        folder_id: widget.folderId,
                                        doc_path: docPath,
                                        docName: fileTitle,
                                      ),
                                    ));
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: MyTheme.textColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: MyTheme.lighterAccentBackColor,
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(10),
                                          title: Text(
                                            fileTitle,
                                            style: const TextStyle(fontSize: 19),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyTheme.lighterAccentBackColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocUpdateFile(
                    folder_id: widget.folderId,
                  ),
                ));
            //Provider.of<IdProvider>(context, listen: false).saveId(widget.folderId);
          },
        ),
      ),
    );
  }
}
