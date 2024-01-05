import UIKit
import Flutter
import GoogleMaps
//import flutter_config

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDN-Ziq7P37DnPsWsOxWW4skClxzilTqJQ")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
