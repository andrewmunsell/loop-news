//
//  DiscoverEventCell.swift
//  Loop News
//
//  Created by Rachel Kipps on 12/12/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import AFDateHelper
import UIKit

class DiscoverEventCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    
    static let TITLE_LABEL_TAG = 10
    
    static let DATE_LABEL_TAG = 20
    
    /**
     * Ensure the image is scaled to fill based on the aspect ratio
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.eventImageView.contentMode = .ScaleToFill
    }
    
    /**
     * Set the image for the event
     */
    func setEventImage(image: UIImage) {
        UIView.transitionWithView(self.eventImageView, duration: 0.0, options: .TransitionNone, animations: { self.eventImageView.image = image }, completion: nil)
    }
    
    func setEventTitle(title: String) {
        let titleLabelView = self.viewWithTag(DiscoverEventCell.TITLE_LABEL_TAG) as! UILabel
        titleLabelView.text = title
    }
    
    func setEventDate(date: NSDate) {
        let dateLabelView = self.viewWithTag(DiscoverEventCell.DATE_LABEL_TAG) as! UILabel
        dateLabelView.text = date.toString(format: .Custom("MMM d"))
    }
    
}
