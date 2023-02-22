import 'package:edrawer/constants/add_update_screen.dart';
import 'package:edrawer/constants/db_handler.dart';
import 'package:edrawer/constants/model.dart';
import 'package:edrawer/screens/doc_screen.dart';
import 'package:flutter/material.dart';
import 'package:edrawer/constants/theme/theme.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //const HomePage({Key? key}) : super(key: key);

  DBHelper? dbHelper;
  late Future<List<DossierModel>> dataList;

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
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Êtes-vous sûr?'),
                content: const Text("Voulez-vous quitter l'application"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Non'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Oui'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("eDrawer - Accueil"),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<DossierModel>> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Pas de dossier",
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
                        int folderId = snapshot.data![index].id!.toInt();
                        String folderTitle = snapshot.data![index].title.toString();
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
                            key: ValueKey<int>(folderId),
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
                                dbHelper!.deleteFolder(folderId);
                                dataList = dbHelper!.getDataListFolder();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: GestureDetector(
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddUpdateFile(
                                        folderId: folderId,
                                        //fileDesc: fileDesc,
                                        folderTitle: folderTitle,
                                        updateFolder: true,
                                      ),
                                    ));
                              },
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DocScreen(folderId: folderId),
                                    ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
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
                                              folderTitle,
                                              style: const TextStyle(fontSize: 19),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
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
          child: const Icon(
            Icons.add,
            color: MyTheme.textColor,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUpdateFile(),
                ));
          },
        ),
      ),
    );
  }
}
