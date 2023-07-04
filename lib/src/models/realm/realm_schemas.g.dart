// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class LocalProject extends _LocalProject
    with RealmEntity, RealmObjectBase, RealmObject {
  LocalProject(
    ObjectId id, {
    String? name,
    String? projecttype,
    String? description,
    String? address,
    String? createdby,
    String? createdat,
    String? url,
    DateTime? editedat,
    String? lasteditedby,
    Iterable<LocalChild> children = const [],
    Iterable<LocalChild> invasiveChildren = const [],
    Iterable<LocalSection> sections = const [],
    Iterable<LocalSection> invasiveSections = const [],
    Set<String> assignedto = const {},
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'projecttype', projecttype);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'createdby', createdby);
    RealmObjectBase.set(this, 'createdat', createdat);
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'editedat', editedat);
    RealmObjectBase.set(this, 'lasteditedby', lasteditedby);
    RealmObjectBase.set<RealmList<LocalChild>>(
        this, 'children', RealmList<LocalChild>(children));
    RealmObjectBase.set<RealmList<LocalChild>>(
        this, 'invasiveChildren', RealmList<LocalChild>(invasiveChildren));
    RealmObjectBase.set<RealmList<LocalSection>>(
        this, 'sections', RealmList<LocalSection>(sections));
    RealmObjectBase.set<RealmList<LocalSection>>(
        this, 'invasiveSections', RealmList<LocalSection>(invasiveSections));
    RealmObjectBase.set<RealmSet<String>>(
        this, 'assignedto', RealmSet<String>(assignedto));
  }

  LocalProject._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get projecttype =>
      RealmObjectBase.get<String>(this, 'projecttype') as String?;
  @override
  set projecttype(String? value) =>
      RealmObjectBase.set(this, 'projecttype', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get address =>
      RealmObjectBase.get<String>(this, 'address') as String?;
  @override
  set address(String? value) => RealmObjectBase.set(this, 'address', value);

  @override
  String? get createdby =>
      RealmObjectBase.get<String>(this, 'createdby') as String?;
  @override
  set createdby(String? value) => RealmObjectBase.set(this, 'createdby', value);

  @override
  String? get createdat =>
      RealmObjectBase.get<String>(this, 'createdat') as String?;
  @override
  set createdat(String? value) => RealmObjectBase.set(this, 'createdat', value);

  @override
  String? get url => RealmObjectBase.get<String>(this, 'url') as String?;
  @override
  set url(String? value) => RealmObjectBase.set(this, 'url', value);

  @override
  DateTime? get editedat =>
      RealmObjectBase.get<DateTime>(this, 'editedat') as DateTime?;
  @override
  set editedat(DateTime? value) => RealmObjectBase.set(this, 'editedat', value);

  @override
  String? get lasteditedby =>
      RealmObjectBase.get<String>(this, 'lasteditedby') as String?;
  @override
  set lasteditedby(String? value) =>
      RealmObjectBase.set(this, 'lasteditedby', value);

  @override
  RealmSet<String> get assignedto =>
      RealmObjectBase.get<String>(this, 'assignedto') as RealmSet<String>;
  @override
  set assignedto(covariant RealmSet<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<LocalChild> get children =>
      RealmObjectBase.get<LocalChild>(this, 'children')
          as RealmList<LocalChild>;
  @override
  set children(covariant RealmList<LocalChild> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<LocalChild> get invasiveChildren =>
      RealmObjectBase.get<LocalChild>(this, 'invasiveChildren')
          as RealmList<LocalChild>;
  @override
  set invasiveChildren(covariant RealmList<LocalChild> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<LocalSection> get sections =>
      RealmObjectBase.get<LocalSection>(this, 'sections')
          as RealmList<LocalSection>;
  @override
  set sections(covariant RealmList<LocalSection> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<LocalSection> get invasiveSections =>
      RealmObjectBase.get<LocalSection>(this, 'invasiveSections')
          as RealmList<LocalSection>;
  @override
  set invasiveSections(covariant RealmList<LocalSection> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<LocalProject>> get changes =>
      RealmObjectBase.getChanges<LocalProject>(this);

  @override
  LocalProject freeze() => RealmObjectBase.freezeObject<LocalProject>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalProject._);
    return const SchemaObject(
        ObjectType.realmObject, LocalProject, 'LocalProject', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('projecttype', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('address', RealmPropertyType.string, optional: true),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
      SchemaProperty('assignedto', RealmPropertyType.string,
          collectionType: RealmCollectionType.set),
      SchemaProperty('children', RealmPropertyType.object,
          linkTarget: 'LocalChild', collectionType: RealmCollectionType.list),
      SchemaProperty('invasiveChildren', RealmPropertyType.object,
          linkTarget: 'LocalChild', collectionType: RealmCollectionType.list),
      SchemaProperty('sections', RealmPropertyType.object,
          linkTarget: 'LocalSection', collectionType: RealmCollectionType.list),
      SchemaProperty('invasiveSections', RealmPropertyType.object,
          linkTarget: 'LocalSection', collectionType: RealmCollectionType.list),
    ]);
  }
}

class LocalChild extends _LocalChild
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  static var _defaultsSet = false;

  LocalChild(
    ObjectId id,
    bool isInvasive, {
    String? name,
    String? type,
    String? description,
    String? url,
    int count = 0,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<LocalChild>({
        'count': 0,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'isInvasive', isInvasive);
    RealmObjectBase.set(this, 'count', count);
  }

  LocalChild._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get url => RealmObjectBase.get<String>(this, 'url') as String?;
  @override
  set url(String? value) => RealmObjectBase.set(this, 'url', value);

  @override
  bool get isInvasive => RealmObjectBase.get<bool>(this, 'isInvasive') as bool;
  @override
  set isInvasive(bool value) => RealmObjectBase.set(this, 'isInvasive', value);

  @override
  int get count => RealmObjectBase.get<int>(this, 'count') as int;
  @override
  set count(int value) => RealmObjectBase.set(this, 'count', value);

  @override
  Stream<RealmObjectChanges<LocalChild>> get changes =>
      RealmObjectBase.getChanges<LocalChild>(this);

  @override
  LocalChild freeze() => RealmObjectBase.freezeObject<LocalChild>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalChild._);
    return const SchemaObject(
        ObjectType.embeddedObject, LocalChild, 'LocalChild', [
      SchemaProperty('id', RealmPropertyType.objectid, mapTo: '_id'),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('isInvasive', RealmPropertyType.bool),
      SchemaProperty('count', RealmPropertyType.int),
    ]);
  }
}

class LocalSubProject extends _LocalSubProject
    with RealmEntity, RealmObjectBase, RealmObject {
  LocalSubProject(
    ObjectId id,
    ObjectId parentid,
    bool isInvasive, {
    String? name,
    String? type,
    String? description,
    String? parenttype,
    String? createdby,
    String? createdat,
    String? url,
    DateTime? editedat,
    String? lasteditedby,
    Iterable<LocalChild> children = const [],
    Iterable<LocalChild> invasiveChildren = const [],
    Set<String> assignedto = const {},
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'parentid', parentid);
    RealmObjectBase.set(this, 'parenttype', parenttype);
    RealmObjectBase.set(this, 'createdby', createdby);
    RealmObjectBase.set(this, 'createdat', createdat);
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'editedat', editedat);
    RealmObjectBase.set(this, 'lasteditedby', lasteditedby);
    RealmObjectBase.set(this, 'isInvasive', isInvasive);
    RealmObjectBase.set<RealmList<LocalChild>>(
        this, 'children', RealmList<LocalChild>(children));
    RealmObjectBase.set<RealmList<LocalChild>>(
        this, 'invasiveChildren', RealmList<LocalChild>(invasiveChildren));
    RealmObjectBase.set<RealmSet<String>>(
        this, 'assignedto', RealmSet<String>(assignedto));
  }

  LocalSubProject._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  ObjectId get parentid =>
      RealmObjectBase.get<ObjectId>(this, 'parentid') as ObjectId;
  @override
  set parentid(ObjectId value) => RealmObjectBase.set(this, 'parentid', value);

  @override
  String? get parenttype =>
      RealmObjectBase.get<String>(this, 'parenttype') as String?;
  @override
  set parenttype(String? value) =>
      RealmObjectBase.set(this, 'parenttype', value);

  @override
  String? get createdby =>
      RealmObjectBase.get<String>(this, 'createdby') as String?;
  @override
  set createdby(String? value) => RealmObjectBase.set(this, 'createdby', value);

  @override
  String? get createdat =>
      RealmObjectBase.get<String>(this, 'createdat') as String?;
  @override
  set createdat(String? value) => RealmObjectBase.set(this, 'createdat', value);

  @override
  String? get url => RealmObjectBase.get<String>(this, 'url') as String?;
  @override
  set url(String? value) => RealmObjectBase.set(this, 'url', value);

  @override
  RealmSet<String> get assignedto =>
      RealmObjectBase.get<String>(this, 'assignedto') as RealmSet<String>;
  @override
  set assignedto(covariant RealmSet<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  DateTime? get editedat =>
      RealmObjectBase.get<DateTime>(this, 'editedat') as DateTime?;
  @override
  set editedat(DateTime? value) => RealmObjectBase.set(this, 'editedat', value);

  @override
  String? get lasteditedby =>
      RealmObjectBase.get<String>(this, 'lasteditedby') as String?;
  @override
  set lasteditedby(String? value) =>
      RealmObjectBase.set(this, 'lasteditedby', value);

  @override
  bool get isInvasive => RealmObjectBase.get<bool>(this, 'isInvasive') as bool;
  @override
  set isInvasive(bool value) => RealmObjectBase.set(this, 'isInvasive', value);

  @override
  RealmList<LocalChild> get children =>
      RealmObjectBase.get<LocalChild>(this, 'children')
          as RealmList<LocalChild>;
  @override
  set children(covariant RealmList<LocalChild> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<LocalChild> get invasiveChildren =>
      RealmObjectBase.get<LocalChild>(this, 'invasiveChildren')
          as RealmList<LocalChild>;
  @override
  set invasiveChildren(covariant RealmList<LocalChild> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<LocalSubProject>> get changes =>
      RealmObjectBase.getChanges<LocalSubProject>(this);

  @override
  LocalSubProject freeze() =>
      RealmObjectBase.freezeObject<LocalSubProject>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalSubProject._);
    return const SchemaObject(
        ObjectType.realmObject, LocalSubProject, 'LocalSubProject', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('parentid', RealmPropertyType.objectid),
      SchemaProperty('parenttype', RealmPropertyType.string, optional: true),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('assignedto', RealmPropertyType.string,
          collectionType: RealmCollectionType.set),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
      SchemaProperty('isInvasive', RealmPropertyType.bool),
      SchemaProperty('children', RealmPropertyType.object,
          linkTarget: 'LocalChild', collectionType: RealmCollectionType.list),
      SchemaProperty('invasiveChildren', RealmPropertyType.object,
          linkTarget: 'LocalChild', collectionType: RealmCollectionType.list),
    ]);
  }
}

class LocalLocation extends _LocalLocation
    with RealmEntity, RealmObjectBase, RealmObject {
  LocalLocation(
    ObjectId id,
    ObjectId parentid,
    bool isInvasive, {
    String? name,
    String? type,
    String? description,
    String? parenttype,
    String? createdby,
    String? createdat,
    String? url,
    DateTime? editedat,
    String? lasteditedby,
    Iterable<LocalSection> sections = const [],
    Iterable<LocalSection> invasiveSections = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'parentid', parentid);
    RealmObjectBase.set(this, 'parenttype', parenttype);
    RealmObjectBase.set(this, 'createdby', createdby);
    RealmObjectBase.set(this, 'createdat', createdat);
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'editedat', editedat);
    RealmObjectBase.set(this, 'lasteditedby', lasteditedby);
    RealmObjectBase.set(this, 'isInvasive', isInvasive);
    RealmObjectBase.set<RealmList<LocalSection>>(
        this, 'sections', RealmList<LocalSection>(sections));
    RealmObjectBase.set<RealmList<LocalSection>>(
        this, 'invasiveSections', RealmList<LocalSection>(invasiveSections));
  }

  LocalLocation._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  ObjectId get parentid =>
      RealmObjectBase.get<ObjectId>(this, 'parentid') as ObjectId;
  @override
  set parentid(ObjectId value) => RealmObjectBase.set(this, 'parentid', value);

  @override
  String? get parenttype =>
      RealmObjectBase.get<String>(this, 'parenttype') as String?;
  @override
  set parenttype(String? value) =>
      RealmObjectBase.set(this, 'parenttype', value);

  @override
  String? get createdby =>
      RealmObjectBase.get<String>(this, 'createdby') as String?;
  @override
  set createdby(String? value) => RealmObjectBase.set(this, 'createdby', value);

  @override
  String? get createdat =>
      RealmObjectBase.get<String>(this, 'createdat') as String?;
  @override
  set createdat(String? value) => RealmObjectBase.set(this, 'createdat', value);

  @override
  String? get url => RealmObjectBase.get<String>(this, 'url') as String?;
  @override
  set url(String? value) => RealmObjectBase.set(this, 'url', value);

  @override
  DateTime? get editedat =>
      RealmObjectBase.get<DateTime>(this, 'editedat') as DateTime?;
  @override
  set editedat(DateTime? value) => RealmObjectBase.set(this, 'editedat', value);

  @override
  String? get lasteditedby =>
      RealmObjectBase.get<String>(this, 'lasteditedby') as String?;
  @override
  set lasteditedby(String? value) =>
      RealmObjectBase.set(this, 'lasteditedby', value);

  @override
  bool get isInvasive => RealmObjectBase.get<bool>(this, 'isInvasive') as bool;
  @override
  set isInvasive(bool value) => RealmObjectBase.set(this, 'isInvasive', value);

  @override
  RealmList<LocalSection> get sections =>
      RealmObjectBase.get<LocalSection>(this, 'sections')
          as RealmList<LocalSection>;
  @override
  set sections(covariant RealmList<LocalSection> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<LocalSection> get invasiveSections =>
      RealmObjectBase.get<LocalSection>(this, 'invasiveSections')
          as RealmList<LocalSection>;
  @override
  set invasiveSections(covariant RealmList<LocalSection> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<LocalLocation>> get changes =>
      RealmObjectBase.getChanges<LocalLocation>(this);

  @override
  LocalLocation freeze() => RealmObjectBase.freezeObject<LocalLocation>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalLocation._);
    return const SchemaObject(
        ObjectType.realmObject, LocalLocation, 'LocalLocation', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('parentid', RealmPropertyType.objectid),
      SchemaProperty('parenttype', RealmPropertyType.string, optional: true),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
      SchemaProperty('isInvasive', RealmPropertyType.bool),
      SchemaProperty('sections', RealmPropertyType.object,
          linkTarget: 'LocalSection', collectionType: RealmCollectionType.list),
      SchemaProperty('invasiveSections', RealmPropertyType.object,
          linkTarget: 'LocalSection', collectionType: RealmCollectionType.list),
    ]);
  }
}

class LocalSection extends _LocalSection
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  static var _defaultsSet = false;

  LocalSection(
    ObjectId id,
    bool isInvasive, {
    String? name,
    bool visualsignsofleak = false,
    bool furtherinvasivereviewrequired = false,
    String? conditionalassessment,
    String? visualreview,
    int count = 0,
    String? coverUrl,
    bool isUploading = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<LocalSection>({
        'visualsignsofleak': false,
        'furtherinvasivereviewrequired': false,
        'count': 0,
        'isUploading': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'isInvasive', isInvasive);
    RealmObjectBase.set(this, 'visualsignsofleak', visualsignsofleak);
    RealmObjectBase.set(
        this, 'furtherinvasivereviewrequired', furtherinvasivereviewrequired);
    RealmObjectBase.set(this, 'conditionalassessment', conditionalassessment);
    RealmObjectBase.set(this, 'visualreview', visualreview);
    RealmObjectBase.set(this, 'count', count);
    RealmObjectBase.set(this, 'coverUrl', coverUrl);
    RealmObjectBase.set(this, 'isUploading', isUploading);
  }

  LocalSection._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  bool get isInvasive => RealmObjectBase.get<bool>(this, 'isInvasive') as bool;
  @override
  set isInvasive(bool value) => RealmObjectBase.set(this, 'isInvasive', value);

  @override
  bool get visualsignsofleak =>
      RealmObjectBase.get<bool>(this, 'visualsignsofleak') as bool;
  @override
  set visualsignsofleak(bool value) =>
      RealmObjectBase.set(this, 'visualsignsofleak', value);

  @override
  bool get furtherinvasivereviewrequired =>
      RealmObjectBase.get<bool>(this, 'furtherinvasivereviewrequired') as bool;
  @override
  set furtherinvasivereviewrequired(bool value) =>
      RealmObjectBase.set(this, 'furtherinvasivereviewrequired', value);

  @override
  String? get conditionalassessment =>
      RealmObjectBase.get<String>(this, 'conditionalassessment') as String?;
  @override
  set conditionalassessment(String? value) =>
      RealmObjectBase.set(this, 'conditionalassessment', value);

  @override
  String? get visualreview =>
      RealmObjectBase.get<String>(this, 'visualreview') as String?;
  @override
  set visualreview(String? value) =>
      RealmObjectBase.set(this, 'visualreview', value);

  @override
  int get count => RealmObjectBase.get<int>(this, 'count') as int;
  @override
  set count(int value) => RealmObjectBase.set(this, 'count', value);

  @override
  String? get coverUrl =>
      RealmObjectBase.get<String>(this, 'coverUrl') as String?;
  @override
  set coverUrl(String? value) => RealmObjectBase.set(this, 'coverUrl', value);

  @override
  bool get isUploading =>
      RealmObjectBase.get<bool>(this, 'isUploading') as bool;
  @override
  set isUploading(bool value) =>
      RealmObjectBase.set(this, 'isUploading', value);

  @override
  Stream<RealmObjectChanges<LocalSection>> get changes =>
      RealmObjectBase.getChanges<LocalSection>(this);

  @override
  LocalSection freeze() => RealmObjectBase.freezeObject<LocalSection>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalSection._);
    return const SchemaObject(
        ObjectType.embeddedObject, LocalSection, 'LocalSection', [
      SchemaProperty('id', RealmPropertyType.objectid, mapTo: '_id'),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('isInvasive', RealmPropertyType.bool),
      SchemaProperty('visualsignsofleak', RealmPropertyType.bool),
      SchemaProperty('furtherinvasivereviewrequired', RealmPropertyType.bool),
      SchemaProperty('conditionalassessment', RealmPropertyType.string,
          optional: true),
      SchemaProperty('visualreview', RealmPropertyType.string, optional: true),
      SchemaProperty('count', RealmPropertyType.int),
      SchemaProperty('coverUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('isUploading', RealmPropertyType.bool),
    ]);
  }
}

class LocalVisualSection extends _LocalVisualSection
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  LocalVisualSection(
    ObjectId id,
    String eee,
    String lbc,
    String awe,
    ObjectId parentid,
    bool unitUnavailable, {
    String? name,
    String? additionalconsiderations,
    String? visualreview,
    bool visualsignsofleak = false,
    bool furtherinvasivereviewrequired = true,
    String? conditionalassessment,
    String? createdby,
    String? createdat,
    String parenttype = '',
    DateTime? editedat,
    String? lasteditedby,
    Iterable<String> images = const [],
    Iterable<String> exteriorelements = const [],
    Iterable<String> waterproofingelements = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<LocalVisualSection>({
        'visualsignsofleak': false,
        'furtherinvasivereviewrequired': true,
        'parenttype': '',
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(
        this, 'additionalconsiderations', additionalconsiderations);
    RealmObjectBase.set(this, 'visualreview', visualreview);
    RealmObjectBase.set(this, 'visualsignsofleak', visualsignsofleak);
    RealmObjectBase.set(
        this, 'furtherinvasivereviewrequired', furtherinvasivereviewrequired);
    RealmObjectBase.set(this, 'conditionalassessment', conditionalassessment);
    RealmObjectBase.set(this, 'eee', eee);
    RealmObjectBase.set(this, 'lbc', lbc);
    RealmObjectBase.set(this, 'awe', awe);
    RealmObjectBase.set(this, 'parentid', parentid);
    RealmObjectBase.set(this, 'createdby', createdby);
    RealmObjectBase.set(this, 'createdat', createdat);
    RealmObjectBase.set(this, 'parenttype', parenttype);
    RealmObjectBase.set(this, 'unitUnavailable', unitUnavailable);
    RealmObjectBase.set(this, 'editedat', editedat);
    RealmObjectBase.set(this, 'lasteditedby', lasteditedby);
    RealmObjectBase.set<RealmList<String>>(
        this, 'images', RealmList<String>(images));
    RealmObjectBase.set<RealmList<String>>(
        this, 'exteriorelements', RealmList<String>(exteriorelements));
    RealmObjectBase.set<RealmList<String>>(this, 'waterproofingelements',
        RealmList<String>(waterproofingelements));
  }

  LocalVisualSection._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<String> get images =>
      RealmObjectBase.get<String>(this, 'images') as RealmList<String>;
  @override
  set images(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get exteriorelements =>
      RealmObjectBase.get<String>(this, 'exteriorelements')
          as RealmList<String>;
  @override
  set exteriorelements(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get waterproofingelements =>
      RealmObjectBase.get<String>(this, 'waterproofingelements')
          as RealmList<String>;
  @override
  set waterproofingelements(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get additionalconsiderations =>
      RealmObjectBase.get<String>(this, 'additionalconsiderations') as String?;
  @override
  set additionalconsiderations(String? value) =>
      RealmObjectBase.set(this, 'additionalconsiderations', value);

  @override
  String? get visualreview =>
      RealmObjectBase.get<String>(this, 'visualreview') as String?;
  @override
  set visualreview(String? value) =>
      RealmObjectBase.set(this, 'visualreview', value);

  @override
  bool get visualsignsofleak =>
      RealmObjectBase.get<bool>(this, 'visualsignsofleak') as bool;
  @override
  set visualsignsofleak(bool value) =>
      RealmObjectBase.set(this, 'visualsignsofleak', value);

  @override
  bool get furtherinvasivereviewrequired =>
      RealmObjectBase.get<bool>(this, 'furtherinvasivereviewrequired') as bool;
  @override
  set furtherinvasivereviewrequired(bool value) =>
      RealmObjectBase.set(this, 'furtherinvasivereviewrequired', value);

  @override
  String? get conditionalassessment =>
      RealmObjectBase.get<String>(this, 'conditionalassessment') as String?;
  @override
  set conditionalassessment(String? value) =>
      RealmObjectBase.set(this, 'conditionalassessment', value);

  @override
  String get eee => RealmObjectBase.get<String>(this, 'eee') as String;
  @override
  set eee(String value) => RealmObjectBase.set(this, 'eee', value);

  @override
  String get lbc => RealmObjectBase.get<String>(this, 'lbc') as String;
  @override
  set lbc(String value) => RealmObjectBase.set(this, 'lbc', value);

  @override
  String get awe => RealmObjectBase.get<String>(this, 'awe') as String;
  @override
  set awe(String value) => RealmObjectBase.set(this, 'awe', value);

  @override
  ObjectId get parentid =>
      RealmObjectBase.get<ObjectId>(this, 'parentid') as ObjectId;
  @override
  set parentid(ObjectId value) => RealmObjectBase.set(this, 'parentid', value);

  @override
  String? get createdby =>
      RealmObjectBase.get<String>(this, 'createdby') as String?;
  @override
  set createdby(String? value) => RealmObjectBase.set(this, 'createdby', value);

  @override
  String? get createdat =>
      RealmObjectBase.get<String>(this, 'createdat') as String?;
  @override
  set createdat(String? value) => RealmObjectBase.set(this, 'createdat', value);

  @override
  String get parenttype =>
      RealmObjectBase.get<String>(this, 'parenttype') as String;
  @override
  set parenttype(String value) =>
      RealmObjectBase.set(this, 'parenttype', value);

  @override
  bool get unitUnavailable =>
      RealmObjectBase.get<bool>(this, 'unitUnavailable') as bool;
  @override
  set unitUnavailable(bool value) =>
      RealmObjectBase.set(this, 'unitUnavailable', value);

  @override
  DateTime? get editedat =>
      RealmObjectBase.get<DateTime>(this, 'editedat') as DateTime?;
  @override
  set editedat(DateTime? value) => RealmObjectBase.set(this, 'editedat', value);

  @override
  String? get lasteditedby =>
      RealmObjectBase.get<String>(this, 'lasteditedby') as String?;
  @override
  set lasteditedby(String? value) =>
      RealmObjectBase.set(this, 'lasteditedby', value);

  @override
  Stream<RealmObjectChanges<LocalVisualSection>> get changes =>
      RealmObjectBase.getChanges<LocalVisualSection>(this);

  @override
  LocalVisualSection freeze() =>
      RealmObjectBase.freezeObject<LocalVisualSection>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalVisualSection._);
    return const SchemaObject(
        ObjectType.realmObject, LocalVisualSection, 'LocalVisualSection', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('images', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('exteriorelements', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('waterproofingelements', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('additionalconsiderations', RealmPropertyType.string,
          optional: true),
      SchemaProperty('visualreview', RealmPropertyType.string, optional: true),
      SchemaProperty('visualsignsofleak', RealmPropertyType.bool),
      SchemaProperty('furtherinvasivereviewrequired', RealmPropertyType.bool),
      SchemaProperty('conditionalassessment', RealmPropertyType.string,
          optional: true),
      SchemaProperty('eee', RealmPropertyType.string),
      SchemaProperty('lbc', RealmPropertyType.string),
      SchemaProperty('awe', RealmPropertyType.string),
      SchemaProperty('parentid', RealmPropertyType.objectid),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('parenttype', RealmPropertyType.string),
      SchemaProperty('unitUnavailable', RealmPropertyType.bool),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
    ]);
  }
}

class LocalInvasiveSection extends _LocalInvasiveSection
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  LocalInvasiveSection(
    ObjectId id,
    ObjectId parentid,
    String invasiveDescription, {
    bool postinvasiverepairsrequired = false,
    Iterable<String> invasiveimages = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<LocalInvasiveSection>({
        'postinvasiverepairsrequired': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'parentid', parentid);
    RealmObjectBase.set(
        this, 'postinvasiverepairsrequired', postinvasiverepairsrequired);
    RealmObjectBase.set(this, 'invasiveDescription', invasiveDescription);
    RealmObjectBase.set<RealmList<String>>(
        this, 'invasiveimages', RealmList<String>(invasiveimages));
  }

  LocalInvasiveSection._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  ObjectId get parentid =>
      RealmObjectBase.get<ObjectId>(this, 'parentid') as ObjectId;
  @override
  set parentid(ObjectId value) => RealmObjectBase.set(this, 'parentid', value);

  @override
  bool get postinvasiverepairsrequired =>
      RealmObjectBase.get<bool>(this, 'postinvasiverepairsrequired') as bool;
  @override
  set postinvasiverepairsrequired(bool value) =>
      RealmObjectBase.set(this, 'postinvasiverepairsrequired', value);

  @override
  String get invasiveDescription =>
      RealmObjectBase.get<String>(this, 'invasiveDescription') as String;
  @override
  set invasiveDescription(String value) =>
      RealmObjectBase.set(this, 'invasiveDescription', value);

  @override
  RealmList<String> get invasiveimages =>
      RealmObjectBase.get<String>(this, 'invasiveimages') as RealmList<String>;
  @override
  set invasiveimages(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<LocalInvasiveSection>> get changes =>
      RealmObjectBase.getChanges<LocalInvasiveSection>(this);

  @override
  LocalInvasiveSection freeze() =>
      RealmObjectBase.freezeObject<LocalInvasiveSection>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalInvasiveSection._);
    return const SchemaObject(
        ObjectType.realmObject, LocalInvasiveSection, 'LocalInvasiveSection', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('parentid', RealmPropertyType.objectid),
      SchemaProperty('postinvasiverepairsrequired', RealmPropertyType.bool),
      SchemaProperty('invasiveDescription', RealmPropertyType.string),
      SchemaProperty('invasiveimages', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
    ]);
  }
}

class LocalConclusiveSection extends _LocalConclusiveSection
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  LocalConclusiveSection(
    ObjectId id,
    ObjectId parentid,
    String conclusiveconsiderations,
    String eeeconclusive,
    String lbcconclusive,
    String aweconclusive, {
    bool propowneragreed = false,
    bool invasiverepairsinspectedandcompleted = false,
    Iterable<String> conclusiveimages = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<LocalConclusiveSection>({
        'propowneragreed': false,
        'invasiverepairsinspectedandcompleted': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'parentid', parentid);
    RealmObjectBase.set(this, 'propowneragreed', propowneragreed);
    RealmObjectBase.set(this, 'invasiverepairsinspectedandcompleted',
        invasiverepairsinspectedandcompleted);
    RealmObjectBase.set(
        this, 'conclusiveconsiderations', conclusiveconsiderations);
    RealmObjectBase.set(this, 'eeeconclusive', eeeconclusive);
    RealmObjectBase.set(this, 'lbcconclusive', lbcconclusive);
    RealmObjectBase.set(this, 'aweconclusive', aweconclusive);
    RealmObjectBase.set<RealmList<String>>(
        this, 'conclusiveimages', RealmList<String>(conclusiveimages));
  }

  LocalConclusiveSection._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  ObjectId get parentid =>
      RealmObjectBase.get<ObjectId>(this, 'parentid') as ObjectId;
  @override
  set parentid(ObjectId value) => RealmObjectBase.set(this, 'parentid', value);

  @override
  bool get propowneragreed =>
      RealmObjectBase.get<bool>(this, 'propowneragreed') as bool;
  @override
  set propowneragreed(bool value) =>
      RealmObjectBase.set(this, 'propowneragreed', value);

  @override
  bool get invasiverepairsinspectedandcompleted =>
      RealmObjectBase.get<bool>(this, 'invasiverepairsinspectedandcompleted')
          as bool;
  @override
  set invasiverepairsinspectedandcompleted(bool value) =>
      RealmObjectBase.set(this, 'invasiverepairsinspectedandcompleted', value);

  @override
  String get conclusiveconsiderations =>
      RealmObjectBase.get<String>(this, 'conclusiveconsiderations') as String;
  @override
  set conclusiveconsiderations(String value) =>
      RealmObjectBase.set(this, 'conclusiveconsiderations', value);

  @override
  String get eeeconclusive =>
      RealmObjectBase.get<String>(this, 'eeeconclusive') as String;
  @override
  set eeeconclusive(String value) =>
      RealmObjectBase.set(this, 'eeeconclusive', value);

  @override
  String get lbcconclusive =>
      RealmObjectBase.get<String>(this, 'lbcconclusive') as String;
  @override
  set lbcconclusive(String value) =>
      RealmObjectBase.set(this, 'lbcconclusive', value);

  @override
  String get aweconclusive =>
      RealmObjectBase.get<String>(this, 'aweconclusive') as String;
  @override
  set aweconclusive(String value) =>
      RealmObjectBase.set(this, 'aweconclusive', value);

  @override
  RealmList<String> get conclusiveimages =>
      RealmObjectBase.get<String>(this, 'conclusiveimages')
          as RealmList<String>;
  @override
  set conclusiveimages(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<LocalConclusiveSection>> get changes =>
      RealmObjectBase.getChanges<LocalConclusiveSection>(this);

  @override
  LocalConclusiveSection freeze() =>
      RealmObjectBase.freezeObject<LocalConclusiveSection>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalConclusiveSection._);
    return const SchemaObject(ObjectType.realmObject, LocalConclusiveSection,
        'LocalConclusiveSection', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('parentid', RealmPropertyType.objectid),
      SchemaProperty('propowneragreed', RealmPropertyType.bool),
      SchemaProperty(
          'invasiverepairsinspectedandcompleted', RealmPropertyType.bool),
      SchemaProperty('conclusiveconsiderations', RealmPropertyType.string),
      SchemaProperty('eeeconclusive', RealmPropertyType.string),
      SchemaProperty('lbcconclusive', RealmPropertyType.string),
      SchemaProperty('aweconclusive', RealmPropertyType.string),
      SchemaProperty('conclusiveimages', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
    ]);
  }
}

class DeckImage extends _DeckImage
    with RealmEntity, RealmObjectBase, RealmObject {
  DeckImage(
    ObjectId id,
    String imageLocalPath,
    String onlinePath,
    bool isUploaded,
    ObjectId parentId,
    String parentType,
    String entityName,
    String containerName,
    String uploadedBy,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'imageLocalPath', imageLocalPath);
    RealmObjectBase.set(this, 'onlinePath', onlinePath);
    RealmObjectBase.set(this, 'isUploaded', isUploaded);
    RealmObjectBase.set(this, 'parentId', parentId);
    RealmObjectBase.set(this, 'parentType', parentType);
    RealmObjectBase.set(this, 'entityName', entityName);
    RealmObjectBase.set(this, 'containerName', containerName);
    RealmObjectBase.set(this, 'uploadedBy', uploadedBy);
  }

  DeckImage._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get imageLocalPath =>
      RealmObjectBase.get<String>(this, 'imageLocalPath') as String;
  @override
  set imageLocalPath(String value) =>
      RealmObjectBase.set(this, 'imageLocalPath', value);

  @override
  String get onlinePath =>
      RealmObjectBase.get<String>(this, 'onlinePath') as String;
  @override
  set onlinePath(String value) =>
      RealmObjectBase.set(this, 'onlinePath', value);

  @override
  bool get isUploaded => RealmObjectBase.get<bool>(this, 'isUploaded') as bool;
  @override
  set isUploaded(bool value) => RealmObjectBase.set(this, 'isUploaded', value);

  @override
  ObjectId get parentId =>
      RealmObjectBase.get<ObjectId>(this, 'parentId') as ObjectId;
  @override
  set parentId(ObjectId value) => RealmObjectBase.set(this, 'parentId', value);

  @override
  String get parentType =>
      RealmObjectBase.get<String>(this, 'parentType') as String;
  @override
  set parentType(String value) =>
      RealmObjectBase.set(this, 'parentType', value);

  @override
  String get entityName =>
      RealmObjectBase.get<String>(this, 'entityName') as String;
  @override
  set entityName(String value) =>
      RealmObjectBase.set(this, 'entityName', value);

  @override
  String get containerName =>
      RealmObjectBase.get<String>(this, 'containerName') as String;
  @override
  set containerName(String value) =>
      RealmObjectBase.set(this, 'containerName', value);

  @override
  String get uploadedBy =>
      RealmObjectBase.get<String>(this, 'uploadedBy') as String;
  @override
  set uploadedBy(String value) =>
      RealmObjectBase.set(this, 'uploadedBy', value);

  @override
  Stream<RealmObjectChanges<DeckImage>> get changes =>
      RealmObjectBase.getChanges<DeckImage>(this);

  @override
  DeckImage freeze() => RealmObjectBase.freezeObject<DeckImage>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(DeckImage._);
    return const SchemaObject(ObjectType.realmObject, DeckImage, 'DeckImage', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('imageLocalPath', RealmPropertyType.string),
      SchemaProperty('onlinePath', RealmPropertyType.string),
      SchemaProperty('isUploaded', RealmPropertyType.bool),
      SchemaProperty('parentId', RealmPropertyType.objectid),
      SchemaProperty('parentType', RealmPropertyType.string),
      SchemaProperty('entityName', RealmPropertyType.string),
      SchemaProperty('containerName', RealmPropertyType.string),
      SchemaProperty('uploadedBy', RealmPropertyType.string),
    ]);
  }
}
