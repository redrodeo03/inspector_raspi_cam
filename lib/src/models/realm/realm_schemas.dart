import 'package:realm/realm.dart';
part 'realm_schemas.g.dart';

// @RealmModel()
// class _LocalSingleProject {
//   @MapTo('_id')
//   @PrimaryKey()
//   late ObjectId id;
//   late String? name;
//   late String? projecttype;
//   late String? description;
//   late String? address;
//   late String? createdby;
//   late String? createdat;
//   late String? url;
//   late DateTime? editedat;
//   String? lasteditedby;
//   late Set<String> assignedto;
//   List<_LocalSection> children = [];
//   List<_LocalSection> invasiveChildren = [];
// }

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

  List<_LocalChild> invasiveChildren = [];

  List<_LocalSection> sections = [];
  List<_LocalSection> invasiveSections = [];
}

@RealmModel(ObjectType.embeddedObject)
class _LocalChild {
  @MapTo('_id')
  late ObjectId id;
  late String? name;
  late String? type;
  late String? description;
  late String? url;
  late bool isInvasive;
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
  late bool isInvasive;
  List<_LocalChild> children = [];
  List<_LocalChild> invasiveChildren = [];
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
  late bool isInvasive;
  List<_LocalSection> sections = [];
  List<_LocalSection> invasiveSections = [];
}

@RealmModel(ObjectType.embeddedObject)
class _LocalSection {
  @MapTo('_id')
  late ObjectId id;
  late String? name;
  late bool isInvasive;
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
  late String eee;
  late String lbc;
  late String awe;
  late ObjectId parentid;
  String? createdby;
  String? createdat;
  String parenttype = '';
  late bool unitUnavailable;
  // InvasiveSection? invasiveSection;
  // ConclusiveSection? conclusiveSection;
  DateTime? editedat;
  String? lasteditedby;
}

@RealmModel()
class _LocalInvasiveSection {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late ObjectId parentid; //visualsectionid
  bool postinvasiverepairsrequired = false;
  late String invasiveDescription;
  late List<String> invasiveimages;
}

@RealmModel()
class _LocalConclusiveSection {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late ObjectId parentid; //visualsectionid
  bool propowneragreed = false;
  bool invasiverepairsinspectedandcompleted = false;
  late String conclusiveconsiderations;
  late String eeeconclusive;
  late String lbcconclusive;
  late String aweconclusive;
  late List<String> conclusiveimages;
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
