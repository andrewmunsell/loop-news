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
     * @deprecated
     */
    static func getAllEvents(callback: ([Event]?, NSError?) -> Void) {
        Event.all(callback)
    }
    
    /**
     * Get an event by its ID.
     * @deprecated
     */
    static func getEvent(event: String, callback: (Event?, NSError?) -> Void) {
        Event.get(event, callback)
    }
}