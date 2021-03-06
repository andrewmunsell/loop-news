//
//  TimelineViewController.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import SafariServices

class TimelineViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var timelineTable: TimelineTableView!
    
    /**
     * Event for this timeline view
     */
    var event: Event?
    
    override func viewDidLoad() {
        // Set this view controller as the delegate for the table
        self.timelineTable.delegate = self
        
        // Set the event for the timeline table
        self.timelineTable.event = event
        
        // Hide the nav bar for the timeline since we have our own custom UI
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup pull to refresh
        let refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        self.timelineTable.addSubview(refreshControl)
        self.timelineTable.refreshControl = refreshControl
        
        // Now, load the data
        self.refresh()
    }
    
    /**
     * Handle tapping a story
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Ignore the header being tapped
        if indexPath.row == 0 {
            return
        }
        
        let story = self.timelineTable.stories[indexPath.row - 1]
        
        // De-select the row before we show the link
        self.timelineTable.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch story.type {
        case "link":
            let safariViewController = SFSafariViewController(URL: NSURL(string: story.url)!)
            
            self.presentViewController(safariViewController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    /**
     * Refresh the data from the server and then reload the table
     */
    func refresh() {
        // Ensure we don't continue if the event isn't set yet
        if self.event == nil {
            return
        }
        
        Story.forEvent(self.event!) { (stories: [Story]?, err: NSError?) -> Void in
            if stories != nil {
                self.timelineTable.stories = stories!
                
                self.timelineTable.reloadData()
                self.timelineTable.setNeedsDisplay()
                
                self.timelineTable.refreshControl?.endRefreshing()
            }
        }
    }
}