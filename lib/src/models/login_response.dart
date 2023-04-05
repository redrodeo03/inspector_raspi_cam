/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/ 
class LoginResponse {
    String? id;
    String? username;
    String? lastname;
    String? firstname;
    String? email;
    String? role;
    String? accesstype;

    LoginResponse({this.id, this.username, this.lastname, this.firstname, this.email, this.role, this.accesstype}); 

    LoginResponse.fromJson(Map<String, dynamic> json) {
        id = json['_id'];
        username = json['username'];
        lastname = json['last_name'];
        firstname = json['first_name'];
        email = json['email'];
        role = json['role'];
        accesstype = json['access_type'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['_id'] = id;
        data['username'] = username;
        data['last_name'] = lastname;
        data['first_name'] = firstname;
        data['email'] = email;
        data['role'] = role;
        data['access_type'] = accesstype;
        return data;
    }
}

