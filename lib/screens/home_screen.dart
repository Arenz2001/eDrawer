import 'package:edrawer/constants/theme.dart';
import 'package:edrawer/screens/abouts_us_screen.dart';
import 'package:edrawer/screens/add_folder_screen.dart';
import 'package:edrawer/screens/doc_screen.dart';
import 'package:edrawer/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/db_handler.dart';
import '../constants/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<DossierModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutUsPage()));
        break;
    }
  }

  loadData() async {
    dataList = dbHelper!.getDataListFolder();
  }

  Color colorFolder = Color(0xFFDAB916);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Êtes-vous sûr?'),
                content: const Text(
                  "Voulez-vous quitter l'application ?",
                  //style: TextStyle(color: AppTheme.mainColor),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Non',
                      //style: TextStyle(color: AppTheme.mainColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Oui',
                      //style: TextStyle(color: AppTheme.mainColor),
                    ),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "eDrawer - Accueil",
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                /*const PopupMenuItem(
                  value: 0,
                  child: Text('Paramètres'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('À propos'),
                )*/
                const PopupMenuItem(
                  value: 1,
                  child: Text('À propos'),
                )
              ],
            )
          ],
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
                          //color: AppTheme.detailsColor,
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
                        String folderColor = snapshot.data![index].folder_color.toString();
                        String temp = folderColor.split('(0x')[1].split(')')[0];
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
                            key: ValueKey<int>(folderId),
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
                                      builder: (context) => AddFolderPage(
                                        folderId: folderId,
                                        folderTitle: folderTitle,
                                        folderColor: folderColor,
                                        updateFolder: true,
                                      ),
                                    ));
                              },
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DocPage(folderId: folderId),
                                    ));
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    //color: colorFolder,
                                    color: colorFolder,
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(10),
                                          title: Text(
                                            folderTitle,
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
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFolderPage() //AddUpdateFile(),
                    ));
          },
        ),
      ),
    );
  }
}
