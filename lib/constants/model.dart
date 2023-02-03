//File model home_page

class DossierModel {
  final int? id;
  final String? title;
  //final String? desc;

  DossierModel({
    this.id,
    this.title,
    //this.desc,
  });

  DossierModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'];
  //desc = res['desc'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      //"desc": desc,
    };
  }
}

class DocModel {
  final int? id;
  final String? title;
  final String? doc_path;
  final int? folder_id;

  DocModel({
    this.id,
    this.title,
    this.doc_path,
    this.folder_id,
  });

  DocModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        doc_path = res['doc_path'],
        folder_id = res['folder_id'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "doc_path": doc_path,
      "folder_id": folder_id,
    };
  }
}
