import 'package:realm/realm.dart';
part 'realm_schemas.g.dart';

@RealmModel()
class _LocalProject {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;

  late String? name;
  late String? projecttype;
  late String? description;
  late String? address;
  late String? createdby;
  late String? createdat;
  late String? url;
  late DateTime? editedat;
  String? lasteditedby;
  late Set<String> assignedto;
  List<_LocalChild> children = [];
}

@RealmModel(ObjectType.embeddedObject)
class _LocalChild {
  @MapTo('_id')
  late ObjectId id;
  late String? name;
  late String? type;
  late String? description;
  late String? url;
  int count = 0;
}

@RealmModel()
class _LocalSubProject {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  String? name;
  String? type;
  String? description;
  late ObjectId parentid;
  String? parenttype;
  String? createdby;
  String? createdat;
  String? url;
  late Set<String> assignedto;
  DateTime? editedat;
  String? lasteditedby;

  List<_LocalChild> children = [];
}

@RealmModel()
class _LocalLocation {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  String? name;
  String? type;
  String? description;
  late ObjectId parentid;
  String? parenttype;
  String? createdby;
  String? createdat;
  String? url;
  DateTime? editedat;
  String? lasteditedby;
  List<_LocalSection> sections = [];
}

@RealmModel(ObjectType.embeddedObject)
class _LocalSection {
  @MapTo('_id')
  late ObjectId id;
  late String? name;

  bool visualsignsofleak = false;
  bool furtherinvasivereviewrequired = false;
  String? conditionalassessment;
  String? visualreview;
  int count = 0;
  String? coverUrl;
}

@RealmModel()
class _LocalVisualSection {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  String? name;
  late List<String> images;
  late List<String> exteriorelements;
  late List<String> waterproofingelements;
  String? additionalconsiderations;
  String? visualreview;
  bool visualsignsofleak = false;
  bool furtherinvasivereviewrequired = true;
  String? conditionalassessment;
  String eee = 'one';
  String lbc = 'one';
  String awe = 'one';
  late ObjectId parentid;
  String? createdby;
  String? createdat;
  // InvasiveSection? invasiveSection;
  // ConclusiveSection? conclusiveSection;
  DateTime? editedat;
  String? lasteditedby;
}

@RealmModel()
class _DeckImage {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String imageLocalPath;
  late String onlinePath;
  late bool isUploaded;
  late ObjectId parentId;
  late String parentType;
  late String entityName;
  late String containerName;
  late String uploadedBy;
}
