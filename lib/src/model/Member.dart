class Member{

  String name;
  String tc;
  String password;
  String email;

  Member({this.name,this.tc,this.password,this.email});

  Member.fromJson(Map<String,dynamic>json){
    name = json['name'];
    tc = json['tc'];
    password = json['password'];
    email = json['email'];
  }

  Map<String,dynamic>toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['name'] = this.name;
    data['tc'] = this.tc;
    data['password'] = this.password;
    data['email'] = this.email;
    return data;
  }

}


class MemberList{
  List<Member> members=[];

  MemberList.fromJsonList(Map value){
    value.forEach((key, value) {
      var post = Member.fromJson(value);
      members.add(post);
    });

  }
}