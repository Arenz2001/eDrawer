import 'dart:io';
import 'package:edrawer/constants/model.dart';
import 'package:edrawer/constants/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:edrawer/screens/doc_screen.dart';
import 'package:edrawer/constants/db_handler.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';

class ConsultPage extends StatefulWidget {
  int? folder_id;
  String? doc_path;
  String? docName;

  ConsultPage({
    this.folder_id,
    this.doc_path,
    this.docName,
  });

  @override
  State<ConsultPage> createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  @override
  Widget build(BuildContext context) {
    var fileType = widget.doc_path.toString();
    if (fileType.isNotEmpty) {
      fileType = fileType.split('.').last;
    }

    bool display;
    if (fileType == 'pdf' || fileType == 'txt' || fileType == 'jpeg' || fileType == 'png' || fileType == 'gif' || fileType == 'jpg') {
      display = true;
    } else {
      display = false;
    }

    String docName = widget.docName.toString();
    String path = "'${widget.doc_path}'";

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
              title: Text("eDrawer - $docName"),
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
          body: Column(
            children: [
              if (display == true) ...[
                if (fileType == 'jpeg' || fileType == 'png' || fileType == 'gif' || fileType == 'jpg') ...[
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        //width: MediaQuery.of(context).size.width - 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(widget.doc_path.toString())),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () => {},
                              child: const Text("Enregistrer", style: TextStyle(color: MyTheme.backColor)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => {OpenFilex.open(widget.docName.toString())},
                              child: const Text(
                                "Ouvrir",
                                style: TextStyle(color: MyTheme.backColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ] else ...[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 189,
                            child: PDFView(
                              filePath: widget.doc_path,
                              enableSwipe: true,
                              fitPolicy: FitPolicy.WIDTH,
                              autoSpacing: true,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(),
                                onPressed: () async => {
                                  await OpenFilex.open(path),
                                },
                                child: const Text("Enregistrer", style: TextStyle(color: MyTheme.backColor)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () => {OpenFilex.open(widget.docName.toString())},
                                child: const Text(
                                  "Ouvrir",
                                  style: TextStyle(color: MyTheme.backColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Le fichier est enregistré à cette adresse : '),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${widget.doc_path}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () async => {
                                await OpenFilex.open(path),
                              },
                              child: const Text("Enregistrer", style: TextStyle(color: MyTheme.backColor)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => {OpenFilex.open(widget.docName.toString())},
                              child: const Text(
                                "Ouvrir",
                                style: TextStyle(color: MyTheme.backColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ],
          )),
    );
  }
}
