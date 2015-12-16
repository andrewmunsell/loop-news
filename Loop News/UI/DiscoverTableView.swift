//
//  DiscoverTableView.swift
//  Loop News
//
//  Created by Rachel Kipps on 12/12/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import UIKit

class DiscoverTableView: UITableView, UITableViewDataSource, UISearchResultsUpdating {
    var refreshControl: UIRefreshControl?
    
    /**
     * Events in the discovery view
     */
    var events: [Event] = []
    var filteredEvents = [Event]()
    let searchController = UISearchController(searchResultsController: nil)
    
    private var eventCellNib = UINib(nibName: "DiscoverEventCell", bundle: NSBundle.mainBundle())
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        
        // Setup the auto-height
        self.estimatedRowHeight = 120.0
        self.rowHeight = 120.0
        
        // Register the cell nib
        self.registerNib(self.eventCellNib, forCellReuseIdentifier: "DiscoverEventCell")
        
        // search view
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.tableHeaderView = searchController.searchBar
        
        // offset tableHeaderView to hide search when table is scrollable
        self.contentOffset = CGPointMake(0,
            CGRectGetHeight(searchController.searchBar.frame));
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.separatorColor = UIColor.clearColor()
        self.separatorStyle = .None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredEvents.count
        }
        return self.events.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("DiscoverEventCell") as! DiscoverEventCell
        
        // set filtered event if searchController active
        let event: Event
        if searchController.active && searchController.searchBar.text != "" {
            event = self.filteredEvents[indexPath.row]
        } else {
            // otherwise, set event from all events
            event = self.events[indexPath.row]
        }
        
        cell.setEventTitle(event.title)
        cell.setEventDate(event.date)
        if event.headerImage != nil {
            dispatch_async(GlobalBackgroundQueue, { () -> Void in
                let url = NSURL(string: event.headerImage!)!
                let data = NSData(contentsOfURL: url)
                
                if data == nil {
                    dispatch_async(GlobalMainQueue, { () -> Void in
                        cell.eventImageView.backgroundColor = UIColor.darkGrayColor()
                    })
                } else {
                    let headerImage: UIImage = UIImage(data: data!)!
                    
                    dispatch_async(GlobalMainQueue, { () -> Void in
                        cell.setEventImage(headerImage)
                    })
                }
            })
        } else {
            cell.eventImageView.backgroundColor = UIColor.darkGrayColor()
        }
        
        return cell
    }
    
    /**
     * Filters all events based on the search text
     * If the event title doesn't have a substring equal to the
     * search text, it will be filtered out of the shown events
     */
    func filterEventsForSearchText(searchText: String, scope: String = "All") {
        self.filteredEvents = self.events.filter { event in
            return event.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        self.reloadData()
    }
    
    /**
     * Implements UISearchResultsUpdating protocol requirements
     */
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterEventsForSearchText(searchController.searchBar.text!)
    }
}
