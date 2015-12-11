//
//  TimelineTableView.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/9/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

class TimelineTableView: UITableView {
    var event: Event?
    
    /**
     * Stories in the timeline
     */
    var stories: [Story] = []
    
    private var headerCellNib = UINib(nibName: "TimelineHeaderCell", bundle: NSBundle.mainBundle())
    private var singleStoryCellNib = UINib(nibName: "TimelineSingleStoryCell", bundle: NSBundle.mainBundle())
    
    /**
     * We must implement this because we're overriding the second init overload below. This literally does nothing but pass the decoder to the super class.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     * Initialize the table and register the nibs as appropriate
     */
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        // Setup the auto-height
        self.estimatedRowHeight = 50
        self.rowHeight = UITableViewAutomaticDimension
        
        // Register the cell nibs
        self.registerNib(self.headerCellNib, forCellReuseIdentifier: "TimelineHeaderCell")
        self.registerNib(self.singleStoryCellNib, forCellReuseIdentifier: "TimelineSingleStoryCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove the separators between the cells
        self.separatorColor = UIColor.clearColor()
        self.separatorStyle = .None
    }
    
    /**
     * Number of rows in the table. We only have a single section so we ignore the parameter.
     */
    override func numberOfRowsInSection(section: Int) -> Int {
        return 1 /* the header */ + self.stories.count /* the stories */
    }
    
    /**
     * Get the cell for the specified row
     */
    override func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
        if indexPath.row == 0 {
            // This is the timeline header
            let cell = self.dequeueReusableCellWithIdentifier("TimelineHeaderCell") as! TimelineHeaderCell
            
            cell.setEventTitle(self.event!.title)
            cell.setEventDate(self.event!.date)
            
            if self.event!.headerImage != nil {
                // We get the image on a background thread so we aren't blocking the UI
                dispatch_async(GlobalBackgroundQueue, { () -> Void in
                    let url = NSURL(string: self.event!.headerImage!)!
                    let data = NSData(contentsOfURL: url)!
                    
                    let headerImage: UIImage = UIImage(data: data)!
                    
                    // Switch back to the main thread so that we can assign the image to the cell
                    dispatch_async(GlobalMainQueue, { () -> Void in
                        cell.setEventImage(headerImage)
                    })
                })
            } else {
                cell.eventImageView.backgroundColor = UIColor.darkGrayColor()
            }
            
            // Ensure the header cannot be selected
            cell.selectionStyle = .None
            
            return cell
        } else {
            let cell = self.dequeueReusableCellWithIdentifier("TimelineSingleStoryCell") as! TimelineSingleStoryCell
            
            cell.setStoryTitle(self.stories[indexPath.row - 1].title)
            cell.setStoryDate(self.stories[indexPath.row - 1].date)
            
            return cell
        }
    }
}