class Properties {
  final bool deleted;
  final Map trash;
  final Map worker;
  final String confirm;
  final String createdAt;
  final String updatedAt;
  final int id;

  Properties(
      {this.deleted,
      this.trash,
      this.worker,
      this.confirm,
      this.createdAt,
      this.updatedAt,
      this.id});

  factory Properties.fromJson(Map<String, dynamic> json) {
    return new Properties(
        deleted: json['deleted'],
        trash: json['trash'],
        worker: json['worker'],
        confirm: json['confirm'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        id: json['id']);
  }
}
