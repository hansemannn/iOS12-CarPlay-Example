//
//  ViewController.swift
//  Route66
//
//  Created by Hans Knöchel on 21.06.18.
//  Copyright © 2018 Hans Knöchel. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

enum TextFieldType: IntegerLiteralType {
  case origin
  case destination
}

class ViewController: UIViewController {

  @IBOutlet weak var originTextField: LocationTextField!
  
  @IBOutlet weak var destinationTextField: LocationTextField!
  
  @IBOutlet weak var startRouteButton: UIButton!
  
  @IBAction func startRouteButtonTapped(_ sender: UIButton) {
    _getLocations()
  }
  
  @IBAction func textFieldChanged(_ sender: UITextField) {
    startRouteButton.isEnabled = _isFormValid()
    startRouteButton.alpha = _isFormValid() ? 1.0 : 0.3
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func _isFormValid() -> Bool {
    guard let origin = originTextField.text, let destination = destinationTextField.text else {
      return false
    }

    guard !origin.isEmpty, !destination.isEmpty else {
      return false
    }
    
    return true
  }
  
  private func _getLocations() {
    guard _isFormValid() else { return }
    
    let geocoder = CLGeocoder()
    var origin: CLLocationCoordinate2D!
    var destination: CLLocationCoordinate2D!
    
    // Get location of origin first
    geocoder.geocodeAddressString(originTextField.text!) { [weak self] placemarks, error in
      guard let strongSelf = self else { return }
      
      guard error == nil else {
        print("Error geocoding the origin: \(String(describing: error?.localizedDescription))")
        return
      }
      
      guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
      origin = location.coordinate
      
      // Get location of destination next
      geocoder.geocodeAddressString(strongSelf.destinationTextField.text!) { placemarks, error in
        guard error == nil else {
          print("Error geocoding the destination: \(String(describing: error?.localizedDescription))")
          return
        }
        
        guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
        destination = location.coordinate
        
        strongSelf._getDirections(from: origin, destination: destination)
      }
    }
  }
  
  private func _getDirections(from origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Void {
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
    request.transportType = .automobile
    
    let directions = MKDirections(request: request)
    directions.calculate { [weak self ] response, error in
      guard let strongSelf = self else { return }

      guard error == nil else {
        print("Error calculating the directions: \(String(describing: error?.localizedDescription))")
        return
      }

      guard let routes = response?.routes else { return }
      var encodedDirections: [[String: Any]] = [[:]]
  
      for route in routes {
        let direction = [
          "name": route.name,
          "steps": route.steps.map({ return ["instructions": $0.instructions, "distance": $0.distance] }),
          "advisoryNotices": route.advisoryNotices
        ] as [String: Any]
        encodedDirections.append(direction)
      }
      
      UserDefaults.standard.set(["latitude": origin.latitude, "longitude": origin.latitude], forKey: "_origin")
      UserDefaults.standard.set(["latitude": destination.latitude, "longitude": destination.latitude], forKey: "_destination")
      UserDefaults.standard.set(encodedDirections, forKey: "_directions")
      
      strongSelf._showAlert(with: NSLocalizedString("Location saved successfully! Go and connect to CarPlay to preview the route", comment: ""))
    }
  }
  
  private func _showAlert(with message: String) {
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))

    self.present(alert, animated: true, completion: nil)
  }
}
