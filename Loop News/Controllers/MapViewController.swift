//
//  MapViewController.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        // Get all events from Parse
        Event.all({(event: [Event]?, err: NSError?) -> Void in
            print(event);
        });
    }
}