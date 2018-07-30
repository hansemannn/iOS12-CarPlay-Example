//
//  AppDelegate.swift
//  Route66
//
//  Created by Hans Knöchel on 21.06.18.
//  Copyright © 2018 Hans Knöchel. All rights reserved.
//

import UIKit
import CarPlay

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CPApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    return true
  }

  func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPWindow) {

    guard let origin = UserDefaults.standard.dictionary(forKey: "_origin") as? [String: CLLocationDegrees],
    let destination = UserDefaults.standard.dictionary(forKey: "_destination") as? [String: CLLocationDegrees],
    let directions = UserDefaults.standard.array(forKey: "_directions") as? [[String: Any]] else {
      return // No active route
    }

    let mapTemplate = CPMapTemplate()
    mapTemplate.tripEstimateStyle = .dark
    mapTemplate.guidanceBackgroundColor = UIColor.green

    let trip = CPTrip(origin: MKMapItem(placemark: MKPlacemark(coordinate: _locationFrom(dictionary: origin))),
                      destination: MKMapItem(placemark: MKPlacemark(coordinate: _locationFrom(dictionary: destination))),
                      routeChoices: [CPRouteChoice(summaryVariants: _summaryVariantsFrom(array: directions),
                                                   additionalInformationVariants: _additionalInformationVariantsFrom(array: directions),
                                                   selectionSummaryVariants: [])])

    interfaceController.setRootTemplate(mapTemplate, animated: true)
    mapTemplate.startNavigationSession(for: trip)
  }
  
  func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPWindow) {

  }
  
  /// MARK: Internal utilities to unserialize our dictionaries of route steps
  
  private func _locationFrom(dictionary: [String: CLLocationDegrees]) -> CLLocationCoordinate2D {
    guard let latitude = dictionary["latitude"], let longitude = dictionary["longitude"] else { return kCLLocationCoordinate2DInvalid }
    return CLLocationCoordinate2DMake(latitude, longitude)
  }
  
  private func _summaryVariantsFrom(array: [[String: Any]]) -> [String] {
    var variants: [String] = []
  
    for direction in array {
      if let name = direction["name"] as? String {
        variants.append(name)
      }
    }
    
    return variants;
  }
  
  private func _additionalInformationVariantsFrom(array: [[String: Any]]) -> [String] {
    var additionalInformationVariants: [String] = []
    
    for routes in array {
      guard let advisoryNotices = routes["advisoryNotices"] as? [String] else { return [] }
      for advisoryNotice in advisoryNotices {
        additionalInformationVariants.append(advisoryNotice)
      }
    }
    
    return additionalInformationVariants
  }
}
