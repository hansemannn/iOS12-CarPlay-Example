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
    // Override point for customization after application launch.
    return true
  }

  func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPMapContentWindow) {
    guard let origin = UserDefaults.standard.dictionary(forKey: "_origin") as? [String: CLLocationDegrees],
    let destination = UserDefaults.standard.dictionary(forKey: "_destination") as? [String: CLLocationDegrees] else {
      return // No active route
    }

    let mapTemplate = RootMapTemplate(configuration: CPMapTemplateConfiguration(guidanceBackgroundColor: UIColor.green, tripEstimateStyle: .dark))
    let trip = CPTrip(origin: MKMapItem(placemark: MKPlacemark(coordinate: locationFrom(dictionary: origin))),
                      destination: MKMapItem(placemark: MKPlacemark(coordinate: locationFrom(dictionary: destination))),
                      routeChoices: [CPRouteChoice(summaryVariants: [], additionalInformationVariants: [], selectionSummaryVariants: [])])

    interfaceController.setRootTemplate(mapTemplate, animated: true)
    mapTemplate.startNavigationSession(for: trip)
  }
  
  func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPMapContentWindow) {
    
  }
  
  private func locationFrom(dictionary: [String: CLLocationDegrees]) -> CLLocationCoordinate2D {
    guard let latitude = dictionary["latitude"], let longitude = dictionary["longitude"] else { return kCLLocationCoordinate2DInvalid }
    return CLLocationCoordinate2DMake(latitude, longitude)
  }
}
