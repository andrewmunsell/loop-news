//
//  EventAnnotation.swift
//  Loop News
//
//  Created by Austin Gebauer on 12/13/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import Foundation
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var event = Event?()
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, event: Event) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.event = event
    }
}
