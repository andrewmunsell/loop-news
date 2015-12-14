//
//  MapViewController.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rect used to bound all event annotations
        var zoomRect : MKMapRect = MKMapRectNull
        
        // padding for the edge of map to show annotations cut off
        let mapPadding = UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
        
        // get all events from Parse
        Event.all({(events: [Event]?, err: NSError?) -> Void in
            for event in events! {
                // create location of pin to drop
                let location = CLLocationCoordinate2DMake(
                    event.coordinates!.latitude,
                    event.coordinates!.longitude
                )
                
                // create map annotation point
                let eventPin = MKPointAnnotation()
                eventPin.coordinate = location
                eventPin.title = event.title
                eventPin.subtitle = event.desc
                
                // create rect to bound new annotation
                let point : MKMapPoint = MKMapPointForCoordinate(location);
                let pointRect : MKMapRect = MKMapRectMake(point.x, point.y, 0.1, 0.1)
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect;
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                }
                
                // add annotation to map
                self.mapView.addAnnotation(eventPin)
                
                // change visible bounds on map to include new annotation
                self.mapView.setVisibleMapRect(zoomRect, edgePadding: mapPadding, animated: false)
            }
        });
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKAnnotationView
        if let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
            pin.annotation = annotation
            view = pin
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
        }
        return view
    }
}