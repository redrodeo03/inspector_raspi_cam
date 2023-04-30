// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class LocalProject extends _LocalProject
    with RealmEntity, RealmObjectBase, RealmObject {
  LocalProject(
    String? id, {
    String? onlineid,
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
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'onlineid', onlineid);
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
  }

  LocalProject._();

  @override
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get onlineid =>
      RealmObjectBase.get<String>(this, 'onlineid') as String?;
  @override
  set onlineid(String? value) => RealmObjectBase.set(this, 'onlineid', value);

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
  RealmList<LocalChild> get children =>
      RealmObjectBase.get<LocalChild>(this, 'children')
          as RealmList<LocalChild>;
  @override
  set children(covariant RealmList<LocalChild> value) =>
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
      SchemaProperty('id', RealmPropertyType.string,
          optional: true, primaryKey: true),
      SchemaProperty('onlineid', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('projecttype', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('address', RealmPropertyType.string, optional: true),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
      SchemaProperty('children', RealmPropertyType.object,
          linkTarget: 'LocalChild', collectionType: RealmCollectionType.list),
    ]);
  }
}

class LocalChild extends _LocalChild
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  LocalChild({
    String? id,
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
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'count', count);
  }

  LocalChild._();

  @override
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

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
        ObjectType.realmObject, LocalChild, 'LocalChild', [
      SchemaProperty('id', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('count', RealmPropertyType.int),
    ]);
  }
}

class LocalSubProject extends _LocalSubProject
    with RealmEntity, RealmObjectBase, RealmObject {
  LocalSubProject(
    String? id, {
    String? onlineid,
    String? name,
    String? type,
    String? description,
    String? parentid,
    String? parenttype,
    String? createdby,
    String? createdat,
    String? url,
    DateTime? editedat,
    String? lasteditedby,
    Iterable<LocalChild> children = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'onlineid', onlineid);
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
    RealmObjectBase.set<RealmList<LocalChild>>(
        this, 'children', RealmList<LocalChild>(children));
  }

  LocalSubProject._();

  @override
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get onlineid =>
      RealmObjectBase.get<String>(this, 'onlineid') as String?;
  @override
  set onlineid(String? value) => RealmObjectBase.set(this, 'onlineid', value);

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
  String? get parentid =>
      RealmObjectBase.get<String>(this, 'parentid') as String?;
  @override
  set parentid(String? value) => RealmObjectBase.set(this, 'parentid', value);

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
  RealmList<LocalChild> get children =>
      RealmObjectBase.get<LocalChild>(this, 'children')
          as RealmList<LocalChild>;
  @override
  set children(covariant RealmList<LocalChild> value) =>
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
      SchemaProperty('id', RealmPropertyType.string,
          optional: true, primaryKey: true),
      SchemaProperty('onlineid', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('parentid', RealmPropertyType.string, optional: true),
      SchemaProperty('parenttype', RealmPropertyType.string, optional: true),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
      SchemaProperty('children', RealmPropertyType.object,
          linkTarget: 'LocalChild', collectionType: RealmCollectionType.list),
    ]);
  }
}

class LocalLocation extends _LocalLocation
    with RealmEntity, RealmObjectBase, RealmObject {
  LocalLocation(
    String? id, {
    String? onlineid,
    String? name,
    String? type,
    String? description,
    String? parentid,
    String? parenttype,
    String? createdby,
    String? createdat,
    String? url,
    DateTime? editedat,
    String? lasteditedby,
    Iterable<LocalSection> sections = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'onlineid', onlineid);
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
    RealmObjectBase.set<RealmList<LocalSection>>(
        this, 'sections', RealmList<LocalSection>(sections));
  }

  LocalLocation._();

  @override
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get onlineid =>
      RealmObjectBase.get<String>(this, 'onlineid') as String?;
  @override
  set onlineid(String? value) => RealmObjectBase.set(this, 'onlineid', value);

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
  String? get parentid =>
      RealmObjectBase.get<String>(this, 'parentid') as String?;
  @override
  set parentid(String? value) => RealmObjectBase.set(this, 'parentid', value);

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
  RealmList<LocalSection> get sections =>
      RealmObjectBase.get<LocalSection>(this, 'sections')
          as RealmList<LocalSection>;
  @override
  set sections(covariant RealmList<LocalSection> value) =>
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
      SchemaProperty('id', RealmPropertyType.string,
          optional: true, primaryKey: true),
      SchemaProperty('onlineid', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('parentid', RealmPropertyType.string, optional: true),
      SchemaProperty('parenttype', RealmPropertyType.string, optional: true),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('url', RealmPropertyType.string, optional: true),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
      SchemaProperty('sections', RealmPropertyType.object,
          linkTarget: 'LocalSection', collectionType: RealmCollectionType.list),
    ]);
  }
}

class LocalSection extends _LocalSection
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  LocalSection({
    String? id,
    String? name,
    bool visualsignsofleak = false,
    bool furtherinvasivereviewrequired = false,
    String? conditionalassessment,
    String? visualreview,
    int count = 0,
    String? coverUrl,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<LocalSection>({
        'visualsignsofleak': false,
        'furtherinvasivereviewrequired': false,
        'count': 0,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'visualsignsofleak', visualsignsofleak);
    RealmObjectBase.set(
        this, 'furtherinvasivereviewrequired', furtherinvasivereviewrequired);
    RealmObjectBase.set(this, 'conditionalassessment', conditionalassessment);
    RealmObjectBase.set(this, 'visualreview', visualreview);
    RealmObjectBase.set(this, 'count', count);
    RealmObjectBase.set(this, 'coverUrl', coverUrl);
  }

  LocalSection._();

  @override
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

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
  Stream<RealmObjectChanges<LocalSection>> get changes =>
      RealmObjectBase.getChanges<LocalSection>(this);

  @override
  LocalSection freeze() => RealmObjectBase.freezeObject<LocalSection>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(LocalSection._);
    return const SchemaObject(
        ObjectType.realmObject, LocalSection, 'LocalSection', [
      SchemaProperty('id', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('visualsignsofleak', RealmPropertyType.bool),
      SchemaProperty('furtherinvasivereviewrequired', RealmPropertyType.bool),
      SchemaProperty('conditionalassessment', RealmPropertyType.string,
          optional: true),
      SchemaProperty('visualreview', RealmPropertyType.string, optional: true),
      SchemaProperty('count', RealmPropertyType.int),
      SchemaProperty('coverUrl', RealmPropertyType.string, optional: true),
    ]);
  }
}

class LocalVisualSection extends _LocalVisualSection
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  LocalVisualSection(
    String? id, {
    String? name,
    String? additionalconsiderations,
    String? visualreview,
    bool visualsignsofleak = false,
    bool furtherinvasivereviewrequired = true,
    String? conditionalassessment,
    String eee = 'one',
    String lbc = 'one',
    String awe = 'one',
    String? parentid,
    String? createdby,
    String? createdat,
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
        'eee': 'one',
        'lbc': 'one',
        'awe': 'one',
      });
    }
    RealmObjectBase.set(this, 'id', id);
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
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

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
  String? get parentid =>
      RealmObjectBase.get<String>(this, 'parentid') as String?;
  @override
  set parentid(String? value) => RealmObjectBase.set(this, 'parentid', value);

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
      SchemaProperty('id', RealmPropertyType.string,
          optional: true, primaryKey: true),
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
      SchemaProperty('parentid', RealmPropertyType.string, optional: true),
      SchemaProperty('createdby', RealmPropertyType.string, optional: true),
      SchemaProperty('createdat', RealmPropertyType.string, optional: true),
      SchemaProperty('editedat', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lasteditedby', RealmPropertyType.string, optional: true),
    ]);
  }
}
