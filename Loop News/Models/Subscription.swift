//
//  Subscription.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import Parse

class Subscription: PFObject, PFSubclassing {
    @NSManaged var user: PFUser
    @NSManaged var event: Event
    
    /**
     * Get the name of the Parse class name
     */
    static func parseClassName() -> String {
        return "Subscription"
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
     * Get the subscriptions for the current user
     */
    static func forCurrentUser(callback: ([Subscription]?, NSError?) -> Void) {
        Subscription.forUser(PFUser.currentUser()!, callback: callback)
    }
    
    /**
     * Get the subscriptions for the specified user
     */
    static func forUser(user: PFUser, callback: ([Subscription]?, NSError?) -> Void) {
        let query = Subscription.query()!
        
        query.whereKey("user", equalTo: user)
        query.includeKey("event")
        
        query.cachePolicy = .NetworkElseCache
        
        query.findObjectsInBackgroundWithBlock { (subs: [PFObject]?, err: NSError?) -> Void in
            callback(subs as? [Subscription], err)
        }
    }
}