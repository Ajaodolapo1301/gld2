


    class NoteModel {
     String remark;
    var   admin_user;
     var  created_at;

     NoteModel({this.admin_user, this.created_at, this.remark});

     factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
       remark: json["remark"],
       admin_user: json["admin_user_uuid"],
       created_at: json["created_at"]
     );
    }