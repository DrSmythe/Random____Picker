//
//  ViewController.swift
//  RandomFoodPicker!
//
//  Created by Matthew Smith on 4/17/16.
//  Copyright © 2016 Smythe Labs. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var requestBar: UITextField!
    let locationManager = CLLocationManager()
    
    @IBAction func helpButtonIsPressed(sender: UIButton) {
     
        let alert = UIAlertController(title: "Help", message: "Tap the text box and enter something you'd like the app to pick for you and then press 'Go'. You will be asked to confirm your choice. Confirming will launch Apple Maps and route you to the chosen location. Denying will allow you to press the big question mark button to pick again from the same thing you just typed. You can enter a new something at any time. If nothing is entered, nearby food will randomly be picked when the button is pressed.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func editingTextBar(sender: UITextField) {
        label.text = requestBar.text
        
    }
    
    @IBAction func RandomizerIsPressed(sender: UIButton) {
        
        self.performSearch()
    }
    
    @IBAction func enterKeyIsPressed(sender: AnyObject) {
        requestBar.resignFirstResponder()
        self.performSearch()
    }
    
    func performSearch() {
        var matchingItems: [MKMapItem] = [MKMapItem]()
        var place: MKPlacemark?
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.region = mapView.region
        request.naturalLanguageQuery = requestBar.text
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({(response: MKLocalSearchResponse?,
            error: NSError?) in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    matchingItems.append(item as MKMapItem)
                    print("Matching items = \(matchingItems.count)")
                }
                
                    let randomIndex = Int(arc4random_uniform(UInt32(matchingItems.count)))
                    print(matchingItems[randomIndex], terminator: "")
                    place = matchingItems[randomIndex].placemark
                    print(matchingItems[randomIndex].placemark, terminator: "")
                    print(place!.name, terminator: "")
                
                    let alertController = UIAlertController(title: "Confirm Choice",
                        message: place!.name,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    let defaultAction = UIAlertAction(title: "Ok",
                    style: UIAlertActionStyle.Default) { action -> Void in
                        
                        let mapItem = MKMapItem(placemark: place!)
                        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMapsWithLaunchOptions(options)
                    }
                    
                    let cancelAction = UIAlertAction(title: "Pick Again",
                        style: UIAlertActionStyle.Cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    alertController.addAction(cancelAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        }
    
        func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
            mapView.centerCoordinate = userLocation.location!.coordinate
        }
    
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location = locations.last! as CLLocation
        
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
            mapView.setRegion(region, animated: true)
        
            locationManager.stopUpdatingLocation()
        }
    
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print(error)
        }
    
        func dismissKeyboard() {
            view.endEditing(true)
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.requestBar.delegate = self
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()

            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
        
            let location = locationManager.location
        }
    }
