//
//  Story.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import Parse

class Story: PFObject, PFSubclassing {
    @NSManaged var title: String
    @NSManaged var date: NSDate
    
    @NSManaged var url: String
    
    @NSManaged var type: String
    
    @NSManaged var event: Event
    
    /**
     * Get the name of the Parse class name
     */
    static func parseClassName() -> String {
        return "Story"
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
     * Get a story by its primary key
     */
    static func get(id: String, callback: (Story?, NSError?) -> Void) {
        let query = Story.query()!
        
        query.includeKey("event")
        
        query.getObjectInBackgroundWithId(id) { (story: PFObject?, err: NSError?) -> Void in
            callback(story as? Story, err)
        }
    }
    
    /**
     * Get the stories that belong to the specified event
     */
    static func forEvent(event: Event, callback: ([Story]?, NSError?) -> Void) {
        let query = Story.query()!
        
        query.whereKey("event", equalTo: event)
        query.orderByDescending("date")
        
        query.cachePolicy = .NetworkElseCache
        
        query.findObjectsInBackgroundWithBlock { (stories: [PFObject]?, err: NSError?) -> Void in
            callback(stories as? [Story], err)
        }
    }
}