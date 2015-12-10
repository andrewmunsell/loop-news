//
//  TimelineViewController.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var timelineTable: TimelineTableView!
    
    /**
     * Event for this timeline view
     */
    var event: Event?
    
    override func viewDidLoad() {
        // Set the event for the timeline table
        self.timelineTable.event = event
        
        // Hide the nav bar for the timeline since we have our own custom UI
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        self.timelineTable.addSubview(refreshControl)
        
        // Now, load the data
        self.refresh()
    }
    
    /**
     * Refresh the data from the server and then reload the table
     */
    func refresh() {
        // Ensure we don't continue if the event isn't set yet
        if event == nil {
            return
        }
        
        Story.forEvent(self.event!) { (stories: [Story]?, err: NSError?) -> Void in
            if stories != nil {
                self.timelineTable.stories = stories!
                
                self.timelineTable.reloadData()
            }
        }
    }
}