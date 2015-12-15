//
//  Event.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import Parse

class Event: PFObject, PFSubclassing {
    @NSManaged var title: String
    @NSManaged var desc: String
    @NSManaged var date: NSDate
    @NSManaged var ongoing: Bool
    @NSManaged var headerImage: String?
    @NSManaged var coordinates: PFGeoPoint?
    
    /**
     * Get the name of the Parse class name
     */
    static func parseClassName() -> String {
        return "Event"
    }
    
    /**
     * Initialize the Parse object subclass
     */
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    /**
     * Get all of the events
     */
    static func all(callback: ([Event]?, NSError?) -> Void) {
        let query = Event.query()!
        
        query.orderByDescending("date")
        
        query.findObjectsInBackgroundWithBlock { (events: [PFObject]?, err: NSError?) -> Void in
            callback(events as? [Event], err)
        }
    }
    
    /**
     * Get an event by the specified ID
     */
    static func get(id: String, callback: (Event?, NSError?) -> Void) {
        let query = Event.query()!
        
        query.getObjectInBackgroundWithId(id) { (event: PFObject?, err: NSError?) -> Void in
            callback(event as? Event, err)
        }
    }
}