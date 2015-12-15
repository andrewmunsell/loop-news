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
    var selectedEvent : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
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
                
                // create an EventAnnotation
                let eventAnnotation = EventAnnotation(
                    coordinate: location,
                    title: event.title,
                    subtitle: event.desc,
                    event: event
                )
                
                // create rect to bound new EventAnnotation
                let point : MKMapPoint = MKMapPointForCoordinate(location);
                let pointRect : MKMapRect = MKMapRectMake(point.x, point.y, 0.1, 0.1)
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect;
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                }
                
                // add annotation to map
                self.mapView.addAnnotation(eventAnnotation)
                
                // change visible bounds on map to include new EventAnnotation
                self.mapView.setVisibleMapRect(zoomRect, edgePadding: mapPadding, animated: false)
            }
        });
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.enabled = true
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return annotationView
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                let selectedAnnotation = view.annotation as! EventAnnotation
                self.selectedEvent = selectedAnnotation.event;
                self.performSegueWithIdentifier("MapToTimelineSegue", sender: nil)
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier! == "MapToTimelineSegue" {
            let destinationVC = segue.destinationViewController as! TimelineViewController
            destinationVC.event = self.selectedEvent
        }
    }
}