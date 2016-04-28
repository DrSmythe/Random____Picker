//
//  Map.swift
//  RandomFoodPicker!
//
//  Created by Matthew Smith on 4/17/16.
//  Copyright © 2016 Smythe Labs. All rights reserved.
//

import MapKit
import UIKit

class Map: MKMapView {
    
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = "Restaurant"
    request.region = mapView.region
    
    let search = MKLocalSearch(request: request)
    
    search.startWithCompletionHandler({(response: MKLocalSearchResponse!,
    error: NSError!) in
    
    if error != nil {
    println("Error occured in search: \(error.localizedDescription)")
    } else if response.mapItems.count == 0 {
    println("No matches found")
    } else {
    println("Matches found")
    
    for item in response.mapItems as! [MKMapItems] {
    println("Name = \(item.name)")
    println("Phone = \(item.phoneNumber)")
    }
    }
    })

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
