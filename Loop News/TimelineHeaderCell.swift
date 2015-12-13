//
//  TimelineHeaderCell.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/9/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import AFDateHelper

class TimelineHeaderCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventOngoingLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    /**
     * Ensure the image is scaled to fill based on the aspect ratio
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.eventImageView.contentMode = .ScaleAspectFill
        
        self.followButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.followButton.layer.borderWidth = 1.0
        self.followButton.layer.cornerRadius = 5.0
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