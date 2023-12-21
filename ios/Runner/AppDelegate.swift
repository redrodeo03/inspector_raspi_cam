import UIKit
import Flutter
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //register for native code

let controller = (window?.rootViewController as! FlutterViewController)
// 1
let methodChannel = 
    FlutterMethodChannel(name: "com.deckinspectors.fluttermobile/photoalbum", binaryMessenger: controller.binaryMessenger)
// 2
methodChannel
    .setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    switch call.method {
    case "createAlbum":
        if let arguments = call.arguments as? [String: Any],
         let albumName = arguments["albumName"] as? String {
            let isAlbumCreated = self?.albumExists(albumName: albumName) 
            if isAlbumCreated==false {           
                self?.createAlbum(albumName: albumName)
            }        
        result(nil)
         }
    case "addPhotoToAlbum":
    if let arguments = call.arguments as? [String: Any],
         let albumName = arguments["albumName"] as? String,
         let imagePath = arguments["imagePath"] as? String {
        self?.addPhotoToAlbum(albumName: albumName, imagePath: imagePath)
        result(nil)
      }
      else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
      }
    default:        
        result(FlutterMethodNotImplemented)
    }
})


    GeneratedPluginRegistrant.register(with: self)
   
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func albumExists(albumName: String) -> Bool {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
    let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    return albums.count > 0
  }

  private func addPhotoToAlbum(albumName: String, imagePath: String) {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
    let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

    guard let album = albums.firstObject else {
      print("Album not found")
      return
    }

    PHPhotoLibrary.shared().performChanges({
      if let image = UIImage(contentsOfFile: imagePath) {
        let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
        let addAssetRequest = PHAssetCollectionChangeRequest(for: album)
        addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
      }
    }) { success, error in
      if success {
        print("Photo added to album successfully")
      } else {
        print("Error adding photo to album: \(error?.localizedDescription ?? "Unknown error")")
      }
    }
  }


  private func createAlbum(albumName: String) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
    }) { success, error in
      if success {
        print("Album created successfully")
      } else {
        print("Error creating album: \(error?.localizedDescription ?? "Unknown error")")
      }
    }
  }
}
