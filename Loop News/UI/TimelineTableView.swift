//
//  TimelineTableView.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/9/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

class TimelineTableView: UITableView {
    /**
     * Stories in the timeline
     */
    var stories: [Story] = []
    
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
        
        // Register the cell nibs
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
        return self.stories.count
    }
    
    /**
     * Get the cell for the specified row
     */
    override func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
        let cell = self.dequeueReusableCellWithIdentifier("TimelineSingleStoryCell") as! TimelineSingleStoryCell
        
        cell.setStoryTitle(self.stories[indexPath.row].title)
        cell.setStoryDate(self.stories[indexPath.row].date)
        
        return cell
    }
}