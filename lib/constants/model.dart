//File model home_page

// ignore_for_file: non_constant_identifier_names

class DossierModel {
  final int? id;
  final String? title;
  final String? folder_color;

  DossierModel({
    this.id,
    this.title,
    this.folder_color,
  });

  DossierModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        folder_color = res['folder_color'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "folder_color": folder_color,
    };
  }
}

class DocModel {
  final int? id;
  final String? title;
  final String? doc_path;
  final String? doc_color;
  final int? folder_id;

  DocModel({
    this.id,
    this.title,
    this.doc_path,
    this.doc_color,
    this.folder_id,
  });

  DocModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        doc_path = res['doc_path'],
        doc_color = res['doc_color'],
        folder_id = res['folder_id'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "doc_path": doc_path,
      "doc_color": doc_color,
      "folder_id": folder_id,
    };
  }
}
