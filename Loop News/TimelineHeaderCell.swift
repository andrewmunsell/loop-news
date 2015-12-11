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
    
    /**
     * Ensure the image is scaled to fill based on the aspect ratio
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.eventImageView.contentMode = .ScaleAspectFill
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
        if ongoing {
            self.eventOngoingLabel.hidden = false
        } else {
            self.eventOngoingLabel.hidden = true
        }
    }
}