import 'package:realm/realm.dart';
part 'realm_schemas.g.dart';

@RealmModel()
class _LocalProject {
  @PrimaryKey()
  late String? id;
  late String? onlineid;
  late String? name;
  late String? projecttype;
  late String? description;
  late String? address;
  late String? createdby;
  late String? createdat;
  late String? url;

  DateTime? editedat;
  String? lasteditedby;

  List<_LocalChild> children = [];
}

@RealmModel()
class _LocalChild {
  String? id;
  String? name;
  String? type;
  String? description;
  String? url;
  int count = 0;
}

@RealmModel()
class _LocalSubProject {
  @PrimaryKey()
  String? id;
  late String? onlineid;
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

  List<_LocalChild> children = [];
}

@RealmModel()
class _LocalLocation {
  @PrimaryKey()
  String? id;
  String? onlineid;
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
  List<_LocalSection> sections = [];
}

@RealmModel()
class _LocalSection {
  String? id;
  String? name;

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
  String? id;
  String? name;
  List<String> images = [];
  List<String> exteriorelements = [];
  List<String> waterproofingelements = [];
  String? additionalconsiderations;
  String? visualreview;
  bool visualsignsofleak = false;
  bool furtherinvasivereviewrequired = true;
  String? conditionalassessment;
  String eee = 'one';
  String lbc = 'one';
  String awe = 'one';
  String? parentid;
  String? onlineId;
  String? createdby;
  String? createdat;

  // InvasiveSection? invasiveSection;
  // ConclusiveSection? conclusiveSection;
  DateTime? editedat;
  String? lasteditedby;
}
