import 'dart:io';

import 'package:deckinspectors/src/bloc/images_bloc.dart';
import 'package:deckinspectors/src/bloc/users_bloc.dart';
import 'package:deckinspectors/src/models/exteriorelements.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:deckinspectors/src/ui/section.dart';
import 'package:realm/realm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RealmProjectServices with ChangeNotifier {
  static const String queryAssignedProjects = "getAssignedProjectsSubscription";
  static const String queryMyProjects = "getMyProjectsSubscription";
  static const String queryAllLocations = "getAllLocationsSubscription";
  static const String queryAllSubProjects = "getAllSubProjectssSubscription";
  static const String queryAllVisualSections =
      "getAllVisualSectionsSubscription";
  static const String queryAllChildren = "getAllCildrenSubscription";
  static const String queryAllImage = "getAllImagesSubscription";

  bool showAll = true;
  static late bool offlineModeOn;
  bool isWaiting = false;
  late Realm realm;
  User? currentUser;
  App app;
  String loggedInUser;

  RealmProjectServices(this.app, this.loggedInUser) {
    if (app.currentUser != null || currentUser != app.currentUser) {
      currentUser ??= app.currentUser;
      realm = Realm(Configuration.flexibleSync(currentUser!, [
        LocalProject.schema,
        LocalChild.schema,
        LocalSubProject.schema,
        LocalLocation.schema,
        LocalSection.schema,
        LocalVisualSection.schema,
        DeckImage.schema
      ], syncErrorHandler: (SyncError error) {
        print("Error message" + error.message.toString());
      }));
      //showAll = (realm.subscriptions.findByName(queryAllProjects) != null);
      if (realm.subscriptions.isEmpty) {
        updateSubscriptions();
      }
      //set offline mode value;
      SharedPreferences.getInstance().then((value) {
        var configValue = value.getString('appSync') ?? 'false';
        if (configValue == 'false') {
          offlineModeOn = true;
        } else {
          offlineModeOn = false;
        }
        if (offlineModeOn) {
          realm.syncSession.pause();
        }
      });
    }
  }

  Future<void> updateSubscriptions() async {
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
      mutableSubscriptions.add(realm.all<LocalProject>(),
          name: queryAssignedProjects);

      mutableSubscriptions.add(realm.all<LocalLocation>(),
          name: queryAllLocations);
      mutableSubscriptions.add(realm.all<LocalSubProject>(),
          name: queryAllSubProjects);
      mutableSubscriptions.add(realm.all<DeckImage>(), name: queryAllImage);
      mutableSubscriptions.add(realm.all<LocalVisualSection>(),
          name: queryAllVisualSections);
    });
    await realm.subscriptions.waitForSynchronization();
  }

  Future<void> sessionSwitch(bool syncOn) async {
    offlineModeOn = !syncOn;
    if (offlineModeOn) {
      realm.syncSession.pause();
    } else {
      try {
        isWaiting = true;
        notifyListeners();
        realm.syncSession.resume();
        await updateSubscriptions();
        //uplaod all the images and update deckimages
        uploadLocalImages();
      } finally {
        isWaiting = false;
      }
    }
    notifyListeners();
  }

  Future<void> switchSubscription(bool value) async {
    showAll = value;
    if (!offlineModeOn) {
      try {
        isWaiting = true;
        notifyListeners();
        await updateSubscriptions();
      } finally {
        isWaiting = false;
      }
    }
    notifyListeners();
  }

//Projects
  void createProject(LocalProject project) {
    try {
      var creationtime = DateTime.now().toString();
      project.createdat = creationtime;
      realm.write<LocalProject>(() => realm.add<LocalProject>(project));
      notifyListeners();
    } catch (e) {
      //handle the exception
    }
  }

  String deleteProject(LocalProject project) {
    try {
      realm.write(() => realm.delete(project));
      notifyListeners();
      return 'success';
    } catch (e) {
      return 'failed';
    }
  }

  LocalProject? getProject(ObjectId id) {
    return realm.find<LocalProject>(id);
  }

  bool updateProjectUrl(LocalProject project, String url) {
    try {
      if (offlineModeOn) {
        DeckImage image = DeckImage(
            ObjectId(),
            url,
            '',
            false,
            project.id,
            'project',
            'projectimage',
            project.name as String,
            usersBloc.username);
        realm.write(() {
          realm.add<DeckImage>(image, update: true);
        });
      }
      realm.write(() {
        project.url = url;
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool addupdateProject(LocalProject project, String name, String address,
      String description, String userName, bool isNewProject) {
    try {
      if (loggedInUser == "") {
        loggedInUser = usersBloc.username;
      }
      var creationtime = DateTime.now().toString();

      realm.write<LocalProject>(() {
        project.name = name;
        project.address = address;
        project.description = description;
        if (isNewProject) {
          project.createdby = userName;
          project.assignedto.add(loggedInUser);
        } else {
          project.lasteditedby = userName;
        }

        project.createdat ??= creationtime;
        project.editedat = DateTime.now();

        return realm.add<LocalProject>(project, update: true);
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

//Update Project Children data
  void updateProjectChildren(ObjectId childId, ObjectId parentId, String name,
      String type, String description, String url) {
    var parentProject = realm.find<LocalProject>(parentId);

    if (parentProject != null) {
      var found =
          parentProject.children.where((element) => element.id == childId);
      if (found.isEmpty) {
        parentProject.children.add(LocalChild(childId,
            name: name, type: type, description: description, url: url));
      } else {
        var foundChild = found.first;
        foundChild.name = name;
        foundChild.description = description;
        foundChild.url = url;
      }
    }
  }

  void deleteProjectChildren(ObjectId childId, ObjectId parentId) {
    var parentProject = realm.find<LocalProject>(parentId);
    if (parentProject != null) {
      var foundChild =
          parentProject.children.firstWhere((element) => element.id == childId);
      parentProject.children.remove(foundChild);
    }
  }

  void updateChildUrl(ObjectId childId, ObjectId parentId, String url) {
    var parentProject = realm.find<LocalProject>(parentId);
    if (parentProject != null) {
      var found =
          parentProject.children.where((element) => element.id == childId);

      var foundChild = found.first;

      foundChild.url = url;
    }
  }

//Update SubProject Children data
  void updateSubProjectChildren(ObjectId childId, ObjectId parentId,
      String name, String type, String description, String url) {
    var parentProject = realm.find<LocalSubProject>(parentId);

    if (parentProject != null) {
      var found =
          parentProject.children.where((element) => element.id == childId);
      if (found.isEmpty) {
        parentProject.children.add(LocalChild(childId,
            name: name, type: type, description: description, url: url));
      } else {
        var foundChild = found.first;
        foundChild.name = name;
        foundChild.description = description;
        foundChild.url = url;
      }
    }
  }

  void deleteSubProjectChildren(ObjectId childId, ObjectId parentId) {
    var parentProject = realm.find<LocalSubProject>(parentId);
    if (parentProject != null) {
      var foundChild =
          parentProject.children.firstWhere((element) => element.id == childId);
      parentProject.children.remove(foundChild);
    }
  }

  void updateSubChildUrl(ObjectId childId, ObjectId parentId, String url) {
    var parentProject = realm.find<LocalSubProject>(parentId);
    if (parentProject != null) {
      var found =
          parentProject.children.where((element) => element.id == childId);

      var foundChild = found.first;

      foundChild.url = url;
    }
  }

  //Sub-projects
  void createSubProject(LocalSubProject subProject) {
    try {
      var creationtime = DateTime.now().toString();
      subProject.createdat ??= creationtime;

      realm
          .write<LocalSubProject>(() => realm.add<LocalSubProject>(subProject));
      notifyListeners();
    } catch (e) {
      //handle the exception
    }
  }

  String deleteSubProject(LocalSubProject subProject) {
    try {
      realm.write(() {
        deleteProjectChildren(subProject.id, subProject.parentid);
        realm.delete(subProject);
      });
      notifyListeners();
      return 'success';
    } catch (e) {
      return 'failed';
    }
  }

  LocalSubProject? getSubProject(ObjectId id) {
    return realm.find<LocalSubProject>(id);
  }

  bool updateSubProjectUrl(LocalSubProject subProject, String url) {
    try {
      if (offlineModeOn) {
        DeckImage image = DeckImage(
            ObjectId(),
            url,
            '',
            false,
            subProject.id,
            'subProject',
            'subProjectimage',
            subProject.name as String,
            usersBloc.username);
        realm.write(() {
          realm.add<DeckImage>(image, update: true);
        });
      }
      realm.write(() {
        updateChildUrl(subProject.id, subProject.parentid, url);
        subProject.url = url;
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool addupdateSubProject(LocalSubProject subProject, String name,
      String description, bool isNewBuilding, String fullUserName) {
    try {
      var creationtime = DateTime.now().toString();

      realm.write(() {
        subProject.name = name;

        subProject.description = description;
        if (isNewBuilding) {
          subProject.createdby = fullUserName;
        } else {
          subProject.lasteditedby = fullUserName;
        }
        subProject.createdat ??= creationtime;
        subProject.editedat = DateTime.now();

        //find the project and update it.
        updateProjectChildren(
            subProject.id,
            subProject.parentid,
            subProject.name as String,
            subProject.type as String,
            subProject.description as String,
            subProject.url as String);
        realm.add<LocalSubProject>(subProject, update: true);
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

//Locations
  void createLocation(LocalLocation location) {
    try {
      realm.write<LocalLocation>(() => realm.add<LocalLocation>(location));
      //notifyListeners();
    } catch (e) {
      //handle the exception
    }
  }

  bool updateLocationUrl(LocalLocation currentLocation, String url) {
    try {
      if (offlineModeOn) {
        DeckImage image = DeckImage(
            ObjectId(),
            url,
            '',
            false,
            currentLocation.id,
            'location',
            'locationImage',
            currentLocation.name as String,
            usersBloc.username);
        realm.write(() {
          realm.add<DeckImage>(image, update: true);
        });
      }
      realm.write(() {
        if (currentLocation.type == 'project') {
          updateChildUrl(currentLocation.id, currentLocation.parentid, url);
        } else {
          updateSubChildUrl(currentLocation.id, currentLocation.parentid, url);
        }
        currentLocation.url = url;
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  String deleteLocation(LocalLocation location) {
    try {
      realm.write(() {
        if (location.parenttype == 'project') {
          deleteProjectChildren(location.id, location.parentid);
        } else {
          deleteSubProjectChildren(location.id, location.parentid);
        }

        realm.delete(location);
      });
      //notifyListeners();
      return 'success';
    } catch (e) {
      return 'failed';
    }
  }

  LocalLocation? getLocation(ObjectId id) {
    return realm.find<LocalLocation>(id);
  }

  bool addupdateLocation(LocalLocation location, String name,
      String description, String fullUserName, bool isNewLocation) {
    try {
      var creationtime = DateTime.now().toString();

      realm.write(() {
        location.name = name;
        location.description = description;
        if (isNewLocation) {
          location.createdby = fullUserName;
        } else {
          location.lasteditedby = fullUserName;
        }
        location.createdat ??= creationtime;
        location.editedat = DateTime.now();

        //find the project and update it.
        if (location.parenttype == 'project') {
          updateProjectChildren(
              location.id,
              location.parentid,
              location.name as String,
              location.type as String,
              location.description as String,
              location.url as String);
        } else {
          updateSubProjectChildren(
              location.id,
              location.parentid,
              location.name as String,
              location.type as String,
              location.description as String,
              location.url as String);
        }
        realm.add<LocalLocation>(location, update: true);
      });
      return true;
    } catch (e) {
      return false;
    }

    //notifyListeners();
  }

//Visual Sections
  void createVisualSection(LocalVisualSection visualSection) {
    try {
      var creationtime = DateTime.now().toString();
      visualSection.createdat ??= creationtime;

      realm.write<LocalVisualSection>(
          () => realm.add<LocalVisualSection>(visualSection));
      notifyListeners();
    } catch (e) {
      //handle the exception
    }
  }

  String deleteVisualSection(LocalVisualSection section) {
    try {
      realm.write(() {
        deleteLocationSection(section.id, section.parentid);
        realm.delete(section);
      });
      notifyListeners();
      return 'success';
    } catch (e) {
      return 'failed';
    }
  }

  LocalVisualSection? getVisualSection(ObjectId id) {
    return realm.find<LocalVisualSection>(id);
  }

  bool addupdateVisualSection(
      LocalVisualSection visualSection,
      String name,
      String concerns,
      List<ElementModel> selectedExteriorelements,
      List<ElementModel> selectedWaterproofingElements,
      VisualReview? review,
      ConditionalAssessment? assessment,
      ExpectancyYears? eee,
      ExpectancyYears? lbc,
      ExpectancyYears? awe,
      bool invasiveReviewRequired,
      bool hasSignsOfLeak,
      bool isNewSection,
      String userFullName) {
    try {
      realm.write(() {
        visualSection.name = name;
        visualSection.additionalconsiderations = concerns;
        visualSection.exteriorelements
            .addAll(selectedExteriorelements.map((element) => element.name));
        visualSection.waterproofingelements.addAll(
            selectedWaterproofingElements.map((element) => element.name));

        visualSection.visualreview = review!.name;
        visualSection.conditionalassessment = assessment!.name;
        visualSection.eee = eee!.name;
        visualSection.lbc = lbc!.name;
        visualSection.awe = awe!.name;
        visualSection.furtherinvasivereviewrequired = invasiveReviewRequired;
        visualSection.visualsignsofleak = hasSignsOfLeak;

        if (isNewSection) {
          visualSection.createdby = userFullName;
        } else {
          visualSection.lasteditedby = userFullName;
        }

        var creationtime = DateTime.now().toString();
        visualSection.createdat ??= creationtime;
        visualSection.editedat = DateTime.now();
        //update parent with the section detail
        updateLocationSection(
            visualSection.id,
            visualSection.parentid,
            visualSection.name,
            visualSection.visualreview,
            visualSection.visualsignsofleak,
            visualSection.furtherinvasivereviewrequired,
            visualSection.conditionalassessment,
            visualSection.images.length);
        realm.add(visualSection, update: true);
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool addImagesUrl(LocalVisualSection localVisualSection, List<String> urls) {
    try {
      if (offlineModeOn) {
        realm.write(() {
          for (var url in urls) {
            DeckImage image = DeckImage(
                ObjectId(),
                url,
                '',
                false,
                localVisualSection.id,
                'visualSection',
                'visualSectionImage',
                localVisualSection.name as String,
                usersBloc.username);

            realm.add<DeckImage>(image, update: true);
          }
          localVisualSection.images.addAll(urls);
        });
      } else {
        realm.write(() {
          localVisualSection.images.addAll(urls);
          updateImageCount(localVisualSection.id, localVisualSection.parentid,
              localVisualSection.images.length);
        });
      }

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

//close realm connection
  Future<void> close() async {
    if (currentUser != null) {
      await currentUser?.logOut();
      currentUser = null;
    }
    realm.close();
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }

  void uploadLocalImages() async {
    realm.syncSession.resume();
    final images = realm.query<DeckImage>("isUploaded == false");

    for (var image in images) {
      String localPath = image.imageLocalPath;
      String parentType = image.parentType;
      ObjectId parentId = image.parentId;

      final file = File(localPath);

      if (!file.existsSync()) {
        continue;
      }
      var result = await imagesBloc.uploadImage(
          localPath,
          image.containerName,
          image.uploadedBy,
          image.id.toString(),
          image.parentType,
          image.entityName);
      if (result is ImageResponse) {
        realm.write(() {
          image.isUploaded = true;
          image.onlinePath = result.url as String;
          realm.add<DeckImage>(image, update: true);
          switch (parentType) {
            case 'project':
              var project = realm.find<LocalProject>(parentId);
              project?.url = result.url;
              break;
            case 'subproject':
              var subproject = realm.find<LocalSubProject>(parentId);
              subproject?.url = result.url;
              break;
            case 'location':
              var location = realm.find<LocalLocation>(parentId);
              location?.url = result.url;
              break;
            case 'visualSection':
              var visualsection = realm.find<LocalVisualSection>(parentId);
              if (visualsection != null) {
                int index = visualsection.images
                    .indexWhere((element) => element == image.imageLocalPath);
                visualsection.images[index] = result.url as String;
              }
              break;
            default:
          }
        });
      }
    }
  }

  void deleteLocationSection(ObjectId id, ObjectId parentid) {
    var parentLocation = realm.find<LocalLocation>(parentid);
    if (parentLocation != null) {
      var foundChild =
          parentLocation.sections.firstWhere((element) => element.id == id);
      parentLocation.sections.remove(foundChild);
    }
  }

  void updateLocationSection(
      ObjectId id,
      ObjectId parentid,
      String? name,
      String? visualreview,
      bool visualsignsofleak,
      bool furtherinvasivereviewrequired,
      String? conditionalassessment,
      int length) {
    var parentProject = realm.find<LocalLocation>(parentid);

    if (parentProject != null) {
      var found = parentProject.sections.where((element) => element.id == id);
      if (found.isEmpty) {
        parentProject.sections.add(LocalSection(id,
            name: name,
            visualreview: visualreview,
            visualsignsofleak: visualsignsofleak,
            furtherinvasivereviewrequired: furtherinvasivereviewrequired,
            conditionalassessment: conditionalassessment,
            count: length));
      } else {
        var foundChild = found.first;
        foundChild.name = name;
        foundChild.visualreview = visualreview;
        foundChild.visualsignsofleak = visualsignsofleak;
        foundChild.conditionalassessment = conditionalassessment;
        foundChild.furtherinvasivereviewrequired =
            furtherinvasivereviewrequired;
        foundChild.count = length;
      }
    }
  }

  void updateImageCount(ObjectId id, ObjectId parentid, int length) {
    var parentProject = realm.find<LocalLocation>(parentid);

    if (parentProject != null) {
      var found = parentProject.sections.where((element) => element.id == id);
      var foundChild = found.first;
      foundChild.count = length;
    }
  }
}
