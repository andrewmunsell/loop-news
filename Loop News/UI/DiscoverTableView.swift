//
//  DiscoverTableView.swift
//  Loop News
//
//  Created by Rachel Kipps on 12/12/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import UIKit

class DiscoverTableView: UITableView, UITableViewDataSource {
    var refreshControl: UIRefreshControl?
    
    /**
     * Events in the discovery view
     */
    var events: [Event] = []
    
    private var eventCellNib = UINib(nibName: "DiscoverEventCell", bundle: NSBundle.mainBundle())
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        
        // Setup the auto-height
        self.estimatedRowHeight = 120.0
        self.rowHeight = 120.0
        
        // Register the cell nib
        self.registerNib(self.eventCellNib, forCellReuseIdentifier: "DiscoverEventCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.separatorColor = UIColor.clearColor()
        self.separatorStyle = .None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("DiscoverEventCell") as! DiscoverEventCell
        let event = self.events[indexPath.row]
        cell.setEventTitle(event.title)
        cell.setEventDate(event.date)
        if event.headerImage != nil {
            dispatch_async(GlobalBackgroundQueue, { () -> Void in
                let url = NSURL(string: event.headerImage!)!
                let data = NSData(contentsOfURL: url)!
                
                let headerImage: UIImage = UIImage(data: data)!
                
                dispatch_async(GlobalMainQueue, { () -> Void in
                    cell.setEventImage(headerImage)
                })
            })
        } else {
            cell.eventImageView.backgroundColor = UIColor.darkGrayColor()
        }
        
        return cell
    }
}
