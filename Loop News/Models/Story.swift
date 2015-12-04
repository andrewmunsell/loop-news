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
    @NSManaged var url: String
    
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
}