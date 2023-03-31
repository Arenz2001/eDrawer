import 'package:edrawer/screens/add_doc_screen.dart';
import 'package:edrawer/screens/home_screen.dart';
import 'package:edrawer/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:edrawer/constants/theme.dart';
import 'package:provider/provider.dart';
import '../components/db_handler.dart';
import '../constants/model.dart';
import '../screens/consult_doc.dart';

class DocPage extends StatefulWidget {
  int? folderId;

  DocPage({super.key, required this.folderId});

  @override
  State<DocPage> createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> {
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

  Color colorFolder = Color(0xFFDAB916);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "eDrawer - Documents",
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pop(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              return Future.value(true);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
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
                        String docColor = snapshot.data![index].doc_color.toString();
                        String temp = docColor.split('(0x')[1].split(')')[0];
                        int valeur = int.parse(temp, radix: 16);
                        colorFolder = Color(valeur);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Dismissible(
                            confirmDismiss: (DismissDirection direction) async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Êtes-vous sûr ?',
                                      style: TextStyle(fontSize: 23),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text(
                                          'Non',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text(
                                          'Oui',
                                          style: TextStyle(fontSize: 18),
                                        ),
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
                                color: AppTheme.textColor,
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
                                      builder: (context) => AddDocPage(
                                        fileId: fileId,
                                        folder_id: folderId,
                                        fileTitle: fileTitle,
                                        doc_Path: docPath,
                                        updateFile: true,
                                        doc_Color: docColor,
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
                                    color: colorFolder,
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(10),
                                          title: Text(
                                            fileTitle,
                                            style: TextStyle(
                                                fontSize: 19, color: colorFolder.computeLuminance() > 0.5 ? AppTheme.mainColor : AppTheme.textColor),
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
          child: const Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDocPage(folder_id: widget.folderId),
                ));
          },
        ),
      ),
    );
  }
}
