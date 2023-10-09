import 'dart:io';

import 'package:deckinspectors/src/bloc/images_bloc.dart';
import 'package:deckinspectors/src/bloc/settings_bloc.dart';
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
  static const String queryAllConclusiveSections =
      "getAllConclusiveSectionsSubscription";
  static const String queryAllInvasiveSections =
      "getAllInvasiveSectionsSubscription";
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
        DeckImage.schema,
        LocalInvasiveSection.schema,
        LocalConclusiveSection.schema
      ], syncErrorHandler: (SyncError error) {
        debugPrint("Error message: ${error.message}");
      }));
      //showAll = (realm.subscriptions.findByName(queryAllProjects) != null);
      offlineModeOn = false;
      if (realm.subscriptions.isEmpty) {
        updateSubscriptions();
      } else {
        //call updatelocalimages.
        //if (!isImageUplaoding) uploadLocalImages();
      }
      //set offline mode value;

      SharedPreferences.getInstance().then((value) {
        var configValue = value.getString('appSync') ?? 'true';
        if (configValue == 'false') {
          offlineModeOn = true;
        } else {
          offlineModeOn = false;
        }
        if (offlineModeOn) {
          realm.syncSession.pause();
        }
      });
      //subscribe to network when changed to connected.
      appSettings.addListener(() {
        appSettings.isImageUploading = true;
        uploadLocalImages();
      });
    }
  }

  Future<void> updateSubscriptions() async {
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
      mutableSubscriptions.add(
          realm.query<LocalProject>('\$0 IN assignedto', [loggedInUser]),
          name: queryAssignedProjects);

      mutableSubscriptions.add(realm.all<LocalLocation>(),
          name: queryAllLocations);
      // mutableSubscriptions.add(
      //     realm.query<LocalSubProject>('\$0 IN assignedto', [loggedInUser]),
      //     name: queryAllSubProjects);
      mutableSubscriptions.add(realm.all<LocalSubProject>(),
          name: queryAllSubProjects);
      mutableSubscriptions.add(realm.all<DeckImage>(), name: queryAllImage);
      mutableSubscriptions.add(realm.all<LocalVisualSection>(),
          name: queryAllVisualSections);
      mutableSubscriptions.add(realm.all<LocalConclusiveSection>(),
          name: queryAllConclusiveSections);
      mutableSubscriptions.add(realm.all<LocalInvasiveSection>(),
          name: queryAllInvasiveSections);
    });
    if (!realm.isClosed) {
      await realm.subscriptions.waitForSynchronization();
    }
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
      if (offlineModeOn || !appSettings.activeConnection) {
        DeckImage image = DeckImage(
            ObjectId(),
            url,
            '',
            false,
            project.id,
            'project',
            'projectimage',
            project.name as String,
            usersBloc.userDetails.username as String);
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
        loggedInUser = usersBloc.userDetails.username as String;
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
        project.editedat = DateTime.now().toString();

        return realm.add<LocalProject>(project, update: true);
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

//Update Project Children data
  void updateProjectChildren(ObjectId childId, ObjectId parentId,
      bool isInvasive, String name, String type, String description) {
    var parentProject = realm.find<LocalProject>(parentId);

    if (parentProject != null) {
      parentProject.isInvasive = isInvasive;
      var found =
          parentProject.children.where((element) => element.id == childId);
      if (found.isEmpty) {
        parentProject.children.add(LocalChild(childId, isInvasive,
            name: name, type: type, description: description, url: ""));
      } else {
        var foundChild = found.first;
        foundChild.name = name;
        foundChild.description = description;
        foundChild.isInvasive = isInvasive;
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
    try {
      if (parentProject != null) {
        var found =
            parentProject.children.where((element) => element.id == childId);

        var foundChild = found.first;

        foundChild.url = url;

        // found = parentProject.invasiveChildren
        //     .where((element) => element.id == childId);

        // foundChild = found.first;

        // foundChild.url = url;
      }
    } catch (e) {}
  }

//Update SubProject Children data
  void updateSubProjectChildren(
    ObjectId childId,
    ObjectId parentId,
    bool isInvasive,
    String name,
    String type,
    String description,
  ) {
    var parentProject = realm.find<LocalSubProject>(parentId);

    if (parentProject != null) {
      var found =
          parentProject.children.where((element) => element.id == childId);
      if (found.isEmpty) {
        parentProject.children.add(LocalChild(childId, isInvasive,
            name: name, type: type, description: description, url: ""));
      } else {
        var foundChild = found.first;
        foundChild.name = name;
        foundChild.description = description;
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

      // found = parentProject.invasiveChildren
      //     .where((element) => element.id == childId);

      // foundChild = found.first;

      // foundChild.url = url;
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
      if (offlineModeOn || !appSettings.activeConnection) {
        DeckImage image = DeckImage(
            ObjectId(),
            url,
            '',
            false,
            subProject.id,
            'subProject',
            'subProjectimage',
            subProject.name as String,
            usersBloc.userDetails.username as String);
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
          subProject.assignedto.add(loggedInUser);
        } else {
          subProject.lasteditedby = fullUserName;
        }
        subProject.createdat ??= creationtime;
        subProject.editedat = DateTime.now().toString();

        //find the project and update it.
        updateProjectChildren(
            subProject.id,
            subProject.parentid,
            subProject.isInvasive,
            subProject.name as String,
            subProject.type as String,
            subProject.description as String);
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
      if (offlineModeOn || !appSettings.activeConnection) {
        DeckImage image = DeckImage(
            ObjectId(),
            url,
            '',
            false,
            currentLocation.id,
            'location',
            'locationImage',
            currentLocation.name as String,
            usersBloc.userDetails.username as String);
        realm.write(() {
          realm.add<DeckImage>(image, update: true);
        });
      }
      realm.write(() {
        if (currentLocation.type == 'projectlocation') {
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
    // if (appSettings.activeConnection) {
    //   uploadLocalImages();
    // }
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
        location.editedat = DateTime.now().toString();

        //find the project and update it.
        if (location.parenttype == 'project') {
          updateProjectChildren(
              location.id,
              location.parentid,
              location.isInvasive,
              location.name as String,
              location.type as String,
              location.description as String);
          // updateProjectInvasiveChildren(
          //     location.id,
          //     location.parentid,
          //     location.name as String,
          //     location.type as String,
          //     location.description as String);
        } else {
          updateSubProjectChildren(
              location.id,
              location.parentid,
              location.isInvasive,
              location.name as String,
              location.type as String,
              location.description as String);
          // updateSubProjectInvasiveChildren(
          //     location.id,
          //     location.parentid,
          //     location.name as String,
          //     location.type as String,
          //     location.description as String);
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
        deleteLocationSection(
            section.parenttype, section.id, section.parentid, false);
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

  void updateImageUploadStatus(
      LocalLocation parentLocation, ObjectId sectionId, bool status) {
    var found =
        parentLocation.sections.where((element) => element.id == sectionId);
    if (found.isNotEmpty) {
      realm.write(() => found.first.isuploading = status);
    }
    notifyListeners();
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
      String userFullName,
      bool unitUnavailable) {
    try {
      realm.write(() {
        visualSection.name = name;
        visualSection.unitUnavailable = unitUnavailable;
        visualSection.additionalconsiderations = concerns;
        visualSection.exteriorelements.clear();
        visualSection.exteriorelements
            .addAll(selectedExteriorelements.map((element) => element.name));
        visualSection.waterproofingelements.clear();
        visualSection.waterproofingelements.addAll(
            selectedWaterproofingElements.map((element) => element.name));

        visualSection.visualreview = review == null ? "" : review.name;
        visualSection.conditionalassessment =
            assessment == null ? "" : assessment.name;
        visualSection.eee = eee == null ? "" : eee.name;
        visualSection.lbc = lbc == null ? "" : lbc.name;
        visualSection.awe = awe == null ? "" : awe.name;
        visualSection.furtherinvasivereviewrequired = invasiveReviewRequired;
        visualSection.visualsignsofleak = hasSignsOfLeak;

        if (isNewSection) {
          visualSection.createdby = userFullName;
        } else {
          visualSection.lasteditedby = userFullName;
        }

        var creationtime = DateTime.now().toString();
        visualSection.createdat ??= creationtime;
        visualSection.editedat = DateTime.now().toString();
        //update parent with the section detail
        updateLocationSection(
            visualSection.parenttype,
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

  bool removeImageUrl(LocalVisualSection localVisualSection, String url) {
    try {
      realm.write(() {
        localVisualSection.images.remove(url);

        updateImageCount(
            localVisualSection.parenttype,
            localVisualSection.id,
            localVisualSection.parentid,
            localVisualSection.images.length,
            localVisualSection.images.last);
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  String getlocalPath(String onlinePath) {
    if (!onlinePath.startsWith('http')) {
      return onlinePath;
    }
    var images = realm.query<DeckImage>('onlinePath == \$0', [onlinePath]);
    if (images.isNotEmpty) {
      return images.first.imageLocalPath;
    }
    return "";
  }

  bool addImagesUrl(LocalVisualSection localVisualSection,
      List<String> localPaths, List<String> onlinePaths) {
    try {
      if (offlineModeOn || !appSettings.activeConnection) {
        realm.write(() {
          for (var url in onlinePaths) {
            DeckImage image = DeckImage(
                ObjectId(),
                url,
                '',
                false,
                localVisualSection.id,
                'visualSection',
                'visualSectionImage',
                localVisualSection.name as String,
                usersBloc.userDetails.username as String);

            realm.add<DeckImage>(image, update: true);
          }
          localVisualSection.images.addAll(onlinePaths);
        });
      } else {
        int k = 0;
        realm.write(() {
          for (var url in onlinePaths) {
            DeckImage image = DeckImage(
                ObjectId(),
                url,
                onlinePaths[k],
                true,
                localVisualSection.id,
                'visualSection',
                'visualSectionImage',
                localVisualSection.name as String,
                usersBloc.userDetails.username as String);

            realm.add<DeckImage>(image, update: true);

            if (localVisualSection.images.contains(url)) {
              int index = localVisualSection.images.indexOf(url);
              localVisualSection.images[index] = onlinePaths[k];
            } else {
              localVisualSection.images.add(onlinePaths[k]);
            }
            k++;
          }
        });
      }

      realm.write(() {
        updateImageCount(
            localVisualSection.parenttype,
            localVisualSection.id,
            localVisualSection.parentid,
            localVisualSection.images.length,
            onlinePaths.last);
      });

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
    try {
      List<DeckImage> imagesTobeDelete = [];

      if (!realm.isClosed) {
        realm.syncSession.resume();

        final images = realm.query<DeckImage>("isUploaded == false");

        for (var image in images) {
          if (!appSettings.activeConnection) {
            appSettings.isImageUploading = false;
            return;
          }
          String localPath = image.imageLocalPath;
          String parentType = image.parentType;
          ObjectId parentId = image.parentId;

          final file = File(localPath);

          if (!file.existsSync()) {
            imagesTobeDelete.add(image);
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
//check if the image is already added to db
            final addedImage =
                realm.query<DeckImage>("imageLocalPath == \$0", [localPath]);
            realm.write(() {
              if (addedImage.isEmpty) {
                if (result.url!.startsWith('http')) {
                  image.isUploaded = true;
                } else {
                  image.isUploaded = false;
                }

                image.onlinePath = result.url as String;
                image.imageLocalPath = localPath;
                realm.add<DeckImage>(image, update: true);
              } else {
                if (result.url!.startsWith('http')) {
                  addedImage.first.isUploaded = true;
                } else {
                  addedImage.first.isUploaded = false;
                }

                addedImage.first.onlinePath = result.url as String;
              }

              switch (parentType.toLowerCase()) {
                case 'project':
                  var project = realm.find<LocalProject>(parentId);
                  project?.url = result.url;
                  break;
                case 'subproject':
                  var subproject = realm.find<LocalSubProject>(parentId);
                  subproject?.url = result.url;
                  updateChildUrl(parentId, subproject?.parentid as ObjectId,
                      result.url as String);
                  break;
                case 'location':
                  var location = realm.find<LocalLocation>(parentId);
                  location?.url = result.url;
                  updateSubChildUrl(parentId, location?.parentid as ObjectId,
                      result.url as String);
                  break;
                case 'visualsection':
                  var visualsection = realm.find<LocalVisualSection>(parentId);
                  if (visualsection != null) {
                    int index = visualsection.images.indexWhere(
                        (element) => element == image.imageLocalPath);
                    if (index != -1) {
                      visualsection.images[index] = result.url as String;
                      //update coverurls
                      updateImageCount(
                          visualsection.parenttype,
                          visualsection.id,
                          visualsection.parentid,
                          visualsection.images.length,
                          visualsection.images.last);
                    }
                  }
                  break;
                case 'invasivesection':
                  var invasiveSection =
                      realm.find<LocalInvasiveSection>(parentId);
                  if (invasiveSection != null) {
                    int index = invasiveSection.invasiveimages.indexWhere(
                        (element) => element == image.imageLocalPath);
                    if (index != -1) {
                      invasiveSection.invasiveimages[index] =
                          result.url as String;
                    }
                  }
                  break;
                case 'conclusivesection':
                  var conclusiveSection =
                      realm.find<LocalConclusiveSection>(parentId);
                  if (conclusiveSection != null) {
                    int index = conclusiveSection.conclusiveimages.indexWhere(
                        (element) => element == image.imageLocalPath);
                    if (index != -1) {
                      conclusiveSection.conclusiveimages[index] =
                          result.url as String;
                    }
                  }
                  break;
                default:
              }
            });
          }
        }
        realm.write(() => realm.deleteMany<DeckImage>(imagesTobeDelete));
      }
    } catch (e) {
      debugPrint("Error message: $e");
      appSettings.isImageUploading = false;
    }
    appSettings.isImageUploading = false;
  }

  void deleteLocationSection(String parentType, ObjectId id, ObjectId parentid,
      bool updateInvasiveSection) {
    if (parentType == 'project') {
      try {
        var parentProject = realm.find<LocalProject>(parentid);
        LocalSection foundChild;
        if (parentProject != null) {
          if (updateInvasiveSection) {
            // foundChild = parentProject.invasiveSections
            //     .firstWhere((element) => element.id == id);

            // parentProject.invasiveSections.remove(foundChild);
          } else {
            foundChild = parentProject.sections
                .firstWhere((element) => element.id == id);

            parentProject.sections.remove(foundChild);
          }
        }
      } catch (e) {}
    } else {
      var parentLocation = realm.find<LocalLocation>(parentid);
      LocalSection foundChild;

      if (parentLocation != null) {
        try {
          if (updateInvasiveSection) {
            if (parentLocation.parenttype == 'project') {
              var parentProject =
                  realm.find<LocalProject>(parentLocation.parentid);
              if (parentProject != null) {
                // LocalChild invasiveChild = parentProject.invasiveChildren
                //     .firstWhere((element) => element.id == parentid);
                // parentProject.invasiveChildren.remove(invasiveChild);
              }
            } else {
              var parentSubProject =
                  realm.find<LocalSubProject>(parentLocation.parentid);
              if (parentSubProject != null) {
                // LocalChild invasiveChild = parentSubProject.invasiveChildren
                //     .firstWhere((element) => element.id == parentid);
                // parentSubProject.invasiveChildren.remove(invasiveChild);
                //remove from project as well.
                var parentProject =
                    realm.find<LocalProject>(parentSubProject.parentid);
                if (parentProject != null) {
                  // invasiveChild = parentProject.invasiveChildren.firstWhere(
                  //     (element) => element.id == parentSubProject.id);
                  // parentProject.invasiveChildren.remove(invasiveChild);
                }
              }
            }
          } else {
            foundChild = parentLocation.sections
                .firstWhere((element) => element.id == id);
            parentLocation.sections.remove(foundChild);
          }
        } catch (e) {}
      }
    }
  }

  void updateLocationSection(
    String parentType,
    ObjectId id,
    ObjectId parentid,
    String? name,
    String? visualreview,
    bool visualsignsofleak,
    bool furtherinvasivereviewrequired,
    String? conditionalassessment,
    int length,
  ) {
    //for singlelevel project
    if (parentType == 'project') {
      var parentProject = realm.find<LocalProject>(parentid);

      if (parentProject != null) {
        var found = parentProject.sections.where((element) => element.id == id);
        if (found.isEmpty) {
          parentProject.sections.add(LocalSection(
              id, furtherinvasivereviewrequired,
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
          foundChild.isInvasive = furtherinvasivereviewrequired;
        }
      }
    } else {
      var parentLocation = realm.find<LocalLocation>(parentid);

      if (parentLocation != null) {
        var found =
            parentLocation.sections.where((element) => element.id == id);
        if (found.isEmpty) {
          parentLocation.sections.add(LocalSection(
              id, furtherinvasivereviewrequired,
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
          foundChild.isInvasive = furtherinvasivereviewrequired;
        }
        //set invasive property of location.
        parentLocation.isInvasive = parentLocation.sections
            .any((element) => element.furtherinvasivereviewrequired == true);
        //update parents
        if (parentLocation.parenttype == 'project') {
          var parentProject = realm.find<LocalProject>(parentLocation.parentid);
          if (parentProject != null) {
            var childLocation = parentProject.children
                .where((element) => element.id == parentLocation.id);
            childLocation.first.isInvasive = parentLocation.isInvasive;
            parentProject.isInvasive = parentProject.children
                .any((element) => element.isInvasive == true);
          }
        }
        if (parentLocation.parenttype == 'subproject') {
          var parentSubProject =
              realm.find<LocalSubProject>(parentLocation.parentid);
          if (parentSubProject != null) {
            var childLocation = parentSubProject.children
                .where((element) => element.id == parentLocation.id);
            childLocation.first.isInvasive = parentLocation.isInvasive;
            parentSubProject.isInvasive = parentSubProject.children
                .any((element) => element.isInvasive == true);

            var parentProject =
                realm.find<LocalProject>(parentSubProject.parentid);
            if (parentProject != null) {
              var childLocation = parentProject.children
                  .where((element) => element.id == parentSubProject.id);
              childLocation.first.isInvasive = parentSubProject.isInvasive;
              parentProject.isInvasive = parentProject.children
                  .any((element) => element.isInvasive == true);
            }
          }
        }
      }
    }
  }

  void updateImageCount(String parentType, ObjectId id, ObjectId parentid,
      int length, String url) {
    try {
      if (parentType == 'project') {
        var parentProject = realm.find<LocalProject>(parentid);

        if (parentProject != null) {
          var found =
              parentProject.sections.where((element) => element.id == id);
          var foundChild = found.first;
          foundChild.count = length;
          if (url != '') {
            foundChild.coverUrl = url;
          }

          //for inavasive sections
          // found = parentProject.invasiveSections
          //     .where((element) => element.id == id);
          // foundChild = found.first;
          // foundChild.count = length;
          // if (url != '') {
          //   foundChild.coverUrl = url;
          // }
        }
      } else {
        var parentLocation = realm.find<LocalLocation>(parentid);

        if (parentLocation != null) {
          var found =
              parentLocation.sections.where((element) => element.id == id);
          var foundChild = found.first;
          foundChild.count = length;
          if (url != '') {
            foundChild.coverUrl = url;
          }

          //for inavasive sections
          // found = parentLocation.invasiveSections
          //     .where((element) => element.id == id);
          // foundChild = found.first;
          // foundChild.count = length;
          // if (url != '') {
          //   foundChild.coverUrl = url;
          // }
        }
      }
    } catch (e) {}
  }

  LocalInvasiveSection getNewInvasiveSection(ObjectId sectionId) {
    return LocalInvasiveSection(
      ObjectId(),
      sectionId,
      "",
      postinvasiverepairsrequired: false,
    );
  }

  LocalConclusiveSection getNewConclusiveSection(ObjectId sectionId) {
    return LocalConclusiveSection(
      ObjectId(),
      sectionId,
      "",
      "",
      "",
      "",
      propowneragreed: false,
      invasiverepairsinspectedandcompleted: false,
    );
  }

  bool addInvasiveImagesUrl(String visualSectionName,
      LocalInvasiveSection currentInvasiveSection, List<String> urls) {
    try {
      if (offlineModeOn || !appSettings.activeConnection) {
        realm.write(() {
          for (var url in urls) {
            DeckImage image = DeckImage(
                ObjectId(),
                url,
                '',
                false,
                currentInvasiveSection.id,
                'invasiveSection',
                'invasiveSectionImage',
                visualSectionName,
                usersBloc.userDetails.username as String);

            realm.add<DeckImage>(image, update: true);
          }
          // localVisualSection.images.addAll(urls);
        });
      }

      realm.write(() {
        currentInvasiveSection.invasiveimages.addAll(urls);
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool addConclusiveImagesUrl(String visualSectionName,
      LocalConclusiveSection currentConclusiveSection, List<String> urls) {
    try {
      if (offlineModeOn || !appSettings.activeConnection) {
        realm.write(() {
          for (var url in urls) {
            DeckImage image = DeckImage(
                ObjectId(),
                url,
                '',
                false,
                currentConclusiveSection.id,
                'conclusiveSection',
                'conclusiveSectionImage',
                visualSectionName,
                usersBloc.userDetails.username as String);

            realm.add<DeckImage>(image, update: true);
          }
          // localVisualSection.images.addAll(urls);
        });
      }

      realm.write(() {
        currentConclusiveSection.conclusiveimages.addAll(urls);
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  LocalInvasiveSection getInvasiveSection(ObjectId sectionId) {
    var result =
        realm.query<LocalInvasiveSection>('parentid ==\$0', [sectionId]);
    if (result.isEmpty) {
      return getNewInvasiveSection(sectionId);
    }
    return result.first;
  }

  LocalConclusiveSection getConclusiveSection(ObjectId sectionId) {
    var result =
        realm.query<LocalConclusiveSection>('parentid == \$0', [sectionId]);
    if (result.isEmpty) {
      return getNewConclusiveSection(sectionId);
    }
    return result.first;
  }

  bool addupdateInvasiveSection(
    LocalInvasiveSection currentInvasiveSection,
    String description,
    bool postInvasiveRepairsRequired,
  ) {
    try {
      realm.write(() {
        currentInvasiveSection.postinvasiverepairsrequired =
            postInvasiveRepairsRequired;
        currentInvasiveSection.invasiveDescription = description;

        realm.add<LocalInvasiveSection>(currentInvasiveSection, update: true);
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  addupdateConclusiveSection(
    LocalConclusiveSection currentConclusiveSection,
    bool propOwnerAgreed,
    bool invasiveRepairsCompleted,
    String eeeConclusive,
    String lbcConclusive,
    String aweConclusive,
    String description,
  ) {
    try {
      realm.write(() {
        currentConclusiveSection.propowneragreed = propOwnerAgreed;
        currentConclusiveSection.invasiverepairsinspectedandcompleted =
            invasiveRepairsCompleted;
        currentConclusiveSection.aweconclusive = aweConclusive;
        currentConclusiveSection.eeeconclusive = eeeConclusive;
        currentConclusiveSection.lbcconclusive = lbcConclusive;
        currentConclusiveSection.conclusiveconsiderations = description;
        realm.add<LocalConclusiveSection>(currentConclusiveSection,
            update: true);
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool removeConclusiveImageUrl(
      LocalConclusiveSection localConclusiveSection, String url) {
    try {
      realm.write(() {
        localConclusiveSection.conclusiveimages.remove(url);
        //updateImageCount(localConclusiveSection.parenttype, localConclusiveSection.id,
        //localConclusiveSection.parentid, localConclusiveSection.images.length, "");
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool removeInvasiveImageUrl(
      LocalInvasiveSection localInvasiveSection, String url) {
    try {
      realm.write(() {
        localInvasiveSection.invasiveimages.remove(url);
        //updateImageCount(localConclusiveSection.parenttype, localConclusiveSection.id,
        //localConclusiveSection.parentid, localConclusiveSection.images.length, "");
      });

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  List<String> getImagesNotUploaded(
      List<String> capturedImages, bool activeConnection, bool isNewSection) {
    List<String> offlineImages = [];
    RealmResults<DeckImage> deckImages;
    try {
      if (activeConnection) {
        return capturedImages.where((e) => !e.startsWith('http')).toList();
      } else {
        if (isNewSection) {
          return capturedImages;
        } else {
          for (var imgpath in capturedImages) {
            deckImages =
                realm.query<DeckImage>('imageLocalPath == \$0', [imgpath]);
            if (deckImages.isNotEmpty) {
              // if (!deckImages.first.isUploaded) {
              //   offlineImages.add(deckImages.first.imageLocalPath);
              // }
            } else {
              offlineImages.add(imgpath);
            }
          }
        }
      }
    } catch (e) {}
    return offlineImages.toList();
  }
}
