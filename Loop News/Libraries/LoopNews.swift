//
//  LoopNews.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import Parse

class LoopNews {
    /**
     * Get all of the events
     */
    static func getAllEvents(callback: ([Event]?, NSError?) -> Void) {
        let query = Event.query()!
        
        query.findObjectsInBackgroundWithBlock { (events: [PFObject]?, err: NSError?) -> Void in
            callback(events as? [Event], err)
        }
    }
    
    /**
     * Get an event by its ID
     */
    static func getEvent(event: String, callback: (Event?, NSError?) -> Void) {
        let query = Event.query()!
        
        query.getObjectInBackgroundWithId(event) { (event: PFObject?, err: NSError?) -> Void in
            callback(event as? Event, err)
        }
    }
}