//
//  TimelineImageCell.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/9/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import AFDateHelper
import UIKit

class TimelineImageCell: UITableViewCell {
    /**
     * Circle for the timeline
     */
    @IBOutlet weak var circleView: UIView!
    
    /**
     * Label for the date inside of the circle
     */
    @IBOutlet weak var circleDateLabel: UILabel!
    
    /**
     * View that represents the vertical line in the timeline
     */
    @IBOutlet weak var timelineLineView: UIView!
    
    /**
     * Story image view
     */
    @IBOutlet weak var storyImageView: UIImageView!
    
    /**
     * Marker that shows what stories are new for a visitor
     */
    @IBOutlet weak var newStoriesMarkerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.storyImageView.contentMode = .ScaleAspectFill
        self.storyImageView.layer.cornerRadius = 10.0
        
        self.circleView.layer.cornerRadius = self.circleView.layer.frame.width / 2
        self.circleView.layer.masksToBounds = true
        self.circleView.clipsToBounds = true
    }
    
    /**
     * Sets whether the story is bordering the "new" stories for the user
     */
    func setIsStoryBorderingNewStories(bordering: Bool) {
        self.newStoriesMarkerView.hidden = !bordering
    }
    
    /**
     * Set the story date
     */
    func setStoryDate(date: NSDate) {
        self.circleDateLabel.text = date.toString(format: .Custom("MMM d"))
    }
    
    /**
     * Set the image for the cell
     */
    func setStoryImage(url: String) {
        dispatch_async(GlobalBackgroundQueue, { () -> Void in
            let nsUrl = NSURL(string: url)!
            let data = NSData(contentsOfURL: nsUrl)
            
            if data == nil {
                dispatch_async(GlobalMainQueue, { () -> Void in
                    self.storyImageView.backgroundColor = UIColor.darkGrayColor()
                })
            } else {
                let img: UIImage = UIImage(data: data!)!
                
                // Switch back to the main thread so that we can assign the image to the cell
                dispatch_async(GlobalMainQueue, { () -> Void in
                    self.storyImageView.image = img
                })
            }
        })
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