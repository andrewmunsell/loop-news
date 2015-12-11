//
//  TimelineTableView.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/9/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

class TimelineTableView: UITableView, UITableViewDataSource {
    var refreshControl: UIRefreshControl?
    
    /**
     * Event the table is displaying
     */
    var event: Event?
    
    /**
     * Stories in the timeline
     */
    var stories: [Story] = []
    
    private var headerCellNib = UINib(nibName: "TimelineHeaderCell", bundle: NSBundle.mainBundle())
    private var singleStoryCellNib = UINib(nibName: "TimelineSingleStoryCell", bundle: NSBundle.mainBundle())
    
    /**
     * Override the init to ensure the table is setup properly
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 /* the header */ + self.stories.count /* the stories */
    }
    
    /**
     * Get the cell for the specified row
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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