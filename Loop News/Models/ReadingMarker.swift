//
//  ReadingMarker.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import Parse

class ReadingMarker: PFObject, PFSubclassing {
    @NSManaged var event: Event
    @NSManaged var story: Story
    @NSManaged var user: PFUser
    
    /**
     * Get the name of the Parse class name
     */
    static func parseClassName() -> String {
        return "ReadingMarker"
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
     * Get the reading marker for the specified event and the current user
     */
    static func forCurrentUserAndEvent(event: Event, callback: (ReadingMarker?, NSError?) -> Void) {
        let query = ReadingMarker.query()!
        
        query.whereKey("event", equalTo: event)
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        
        query.includeKey("story")
        
        query.findObjectsInBackgroundWithBlock { (markers: [PFObject]?, err: NSError?) -> Void in
            callback(markers != nil && markers!.count > 0 ? markers![0] as? ReadingMarker : nil, err)
        }
    }
}