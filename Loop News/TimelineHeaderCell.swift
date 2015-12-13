//
//  TimelineHeaderCell.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/9/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import AFDateHelper
import Parse

class TimelineHeaderCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventOngoingLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    private var event: Event?
    private var subscription: Subscription?
    
    /**
     * Ensure the image is scaled to fill based on the aspect ratio
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.eventImageView.contentMode = .ScaleAspectFill
        
        self.followButton.setBackgroundColor(UIColor.whiteColor(), forState: .Highlighted)
        
        self.followButton.layer.masksToBounds = true
        self.followButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.followButton.layer.borderWidth = 1.0
        self.followButton.layer.cornerRadius = 5.0
    }
    
    /**
     * Handle the follow button being tapped
     */
    @IBAction func followButtonTapped(sender: UIButton) {
        if self.event != nil && self.subscription != nil {
            self.subscription!.deleteEventually()
            
            self.subscription = nil
        } else if self.event != nil && self.subscription == nil {
            self.subscription = Subscription()
            
            self.subscription?.event = self.event!
            self.subscription?.user = PFUser.currentUser()!
            
            self.subscription?.saveEventually()
        }
        
        self.setIsFollowed(self.subscription != nil)
    }
    
    /**
     * Set the event for this cell
     */
    func setEvent(event: Event) {
        self.event = event
        
        self.setEventTitle(self.event!.title)
        self.setEventDate(self.event!.date)
        self.setIsOngoing(self.event!.ongoing)
        
        if self.event!.headerImage != nil {
            // We get the image on a background thread so we aren't blocking the UI
            dispatch_async(GlobalBackgroundQueue, { () -> Void in
                let url = NSURL(string: self.event!.headerImage!)!
                let data = NSData(contentsOfURL: url)!
                
                let headerImage: UIImage = UIImage(data: data)!
                
                // Switch back to the main thread so that we can assign the image to the cell
                dispatch_async(GlobalMainQueue, { () -> Void in
                    self.setEventImage(headerImage)
                })
            })
        } else {
            self.eventImageView.backgroundColor = UIColor.darkGrayColor()
        }
        
        Subscription.forCurrentUserAndEvent(self.event!) { (sub: Subscription?, err: NSError?) -> Void in
            self.setIsFollowed(sub != nil)
        }
    }
    
    /**
     * Set the image for the header, cross fading from whatever used to be in the image view
     */
    func setEventImage(image: UIImage) {
        UIView.transitionWithView(self.eventImageView, duration: 1.0, options: .TransitionCrossDissolve, animations: { self.eventImageView.image = image }, completion: nil)
    }
    
    /**
     * Set the title of the event
     */
    func setEventTitle(title: String) {
        self.eventTitleLabel.text = title
    }
    
    /**
     * Set the date for the event
     */
    func setEventDate(date: NSDate) {
        self.eventDateLabel.text = date.toString(format: .Custom("MMMM d, yyyy"))
    }
    
    /**
     * Set whether the event is ongoing
     */
    func setIsOngoing(ongoing: Bool) {
        self.eventOngoingLabel.hidden = !ongoing
    }
    
    /**
     * Set whether the event has already been followed
     */
    func setIsFollowed(followed: Bool) {
        self.followButton.setTitle(followed ? "Unfollow" : "Follow", forState: .Normal)
    }
}