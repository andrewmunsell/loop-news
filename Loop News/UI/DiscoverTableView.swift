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
        self.estimatedRowHeight = 50
        self.rowHeight = UITableViewAutomaticDimension
        
        // Register the cell nibs
        self.registerNib(self.eventCellNib, forCellReuseIdentifier: "DiscoverEventCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("DiscoverEventCell") as! DiscoverEventCell
        cell.setEventTitle(self.events[indexPath.row - 1].title)
        cell.setEventDate(self.events[indexPath.row - 1].date)
        
        return cell
    }
}
