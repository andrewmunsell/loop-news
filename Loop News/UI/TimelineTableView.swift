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
    
    /**
     * The last story that was read by the current user
     */
    var lastReadStory: Story?
    
    /**
     * Delegate to assign to the timeline header cell
     */
    var timelineHeaderCellDelegate: TimelineHeaderCellDelegate?
    
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
            
            cell.setEvent(self.event!)
            cell.delegate = self.timelineHeaderCellDelegate
            
            // Ensure the header cannot be selected
            cell.selectionStyle = .None
            
            return cell
        } else {
            let story = self.stories[indexPath.row - 1]
            
            switch story.type {
            case "link":
                let cell = self.dequeueReusableCellWithIdentifier("TimelineSingleStoryCell") as! TimelineSingleStoryCell
                
                // Set the story as the "last read" story if it isn't the first story in the timeline and if it matches the ID of the last read story
                cell.setIsStoryBorderingNewStories(indexPath.row - 1 != 0 && story.objectId == self.lastReadStory?.objectId)
                
                cell.setStoryTitle(story.title)
                cell.setStoryDate(story.date)
                
                cell.setIsLastStory(indexPath.row == self.stories.count)
                
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}