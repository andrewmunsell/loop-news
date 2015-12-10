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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circleView = self.viewWithTag(TimelineSingleStoryCell.CIRCLE_VIEW_TAG)!
        circleView.layer.cornerRadius = circleView.layer.frame.width
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
    }
}