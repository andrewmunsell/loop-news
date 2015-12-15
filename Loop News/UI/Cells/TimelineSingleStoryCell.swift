//
//  TimelineSingleStoryCell.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/9/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import AFDateHelper
import UIKit

class TimelineSingleStoryCell: UITableViewCell {
    /**
     * Tag for the circle view
     */
    static let CIRCLE_VIEW_TAG = 100
    
    /**
     * Tag for the title label
     */
    static let TITLE_LABEL_TAG = 10;
    
    /**
     * Tag for the date label
     */
    static let DATE_LABEL_TAG = 20;
    
    /**
     * Label for the date inside of the circle
     */
    @IBOutlet weak var circleDateLabel: UILabel!
    
    /**
     * View that represents the vertical line in the timeline
     */
    @IBOutlet weak var timelineLineView: UIView!
    
    /**
     * Marker that shows what stories are new for a visitor
     */
    @IBOutlet weak var newStoriesMarkerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circleView = self.viewWithTag(TimelineSingleStoryCell.CIRCLE_VIEW_TAG)!
        
        circleView.layer.cornerRadius = circleView.layer.frame.width / 2
        circleView.layer.masksToBounds = true
        circleView.clipsToBounds = true
    }
    
    /**
     * Sets whether the story is bordering the "new" stories for the user
     */
    func setIsStoryBorderingNewStories(bordering: Bool) {
       self.newStoriesMarkerView.hidden = !bordering
    }

    /**
     * Set the story title
     */
    func setStoryTitle(title: String) {
        let titleLabelView = self.viewWithTag(TimelineSingleStoryCell.TITLE_LABEL_TAG) as! UILabel
        
        titleLabelView.text = title
    }
    
    /**
     * Set the story date
     */
    func setStoryDate(date: NSDate) {
        let dateLabelView = self.viewWithTag(TimelineSingleStoryCell.DATE_LABEL_TAG) as! UILabel
        
        dateLabelView.text = date.relativeTimeToString()
        self.circleDateLabel.text = date.toString(format: .Custom("MMM d"))
    }
    
    /**
     * Set whether this story is the last story in the event
     */
    func setIsLastStory(lastStory: Bool) {
        if !lastStory {
            self.timelineLineView.layer.mask = nil
        } else {
            let maskGradient = CAGradientLayer()
            
            maskGradient.frame = (self.timelineLineView.superview?.frame)!
            maskGradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
            maskGradient.locations = [0.2, 1.0]
            
            self.timelineLineView.layer.mask = maskGradient
        }
    }
}