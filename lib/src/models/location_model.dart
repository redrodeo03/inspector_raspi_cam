
import 'project_model.dart';

class Location {
    String? id;
    String? name;
    String? type;
    String? description;
    String? parentid;
    String? parenttype;
    String? createdby;
    String? createdat;
    String? url;  
   
    DateTime? editedat;
    String? lasteditedby;
    
    List<Child?>? children;

    Location({this.id, this.name, this.description,this.parentid,this.parenttype,this.createdby,this.createdat, this.url, 
     this.editedat, this.lasteditedby,this.type,  this.children}); 

    Location.fromJson(Map<String, dynamic> json) {
        id = json['_id'];
        name = json['name'];       
        description = json['description'];        
        createdby = json['createdby'];
        createdat = json['createdat'];
        parentid = json['parentid'];
        parenttype = json['parenttype'];
        url = json['url'];        
        editedat = json['editedat']==null?null: DateTime.tryParse(json['editedat']);
        lasteditedby = json['lasteditedby'];  
        type=json['type'];             
      }
    

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['_id'] = id;
        data['name'] = name;
        
        data['description'] = description;
        data['parentid'] = parentid;
        data['parenttype'] = parenttype;
        data['createdby'] = createdby;
        data['url'] = url;
        data['type'] = type;
        data['editedat'] = editedat;
        data['lasteditedby'] = lasteditedby;
        
        data['children'] =children != null ? children!.map((v) => v?.toJson()).toList() : null;
        return data;
    }
  }

class LocationResponse {
    Location? item;
    String? message;
    int? code;

    LocationResponse({this.item, this.message, this.code}); 

    LocationResponse.fromJson(Map<String, dynamic> json) {
        item = json['item'] != null ? Location?.fromJson(json['item']) : null;
        message = json['message'];
        code = json['code'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['item'] = item!.toJson();
        data['message'] = message;
        data['code'] = code;
        return data;
    }
}

