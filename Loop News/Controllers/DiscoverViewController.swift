//
//  DiscoverViewController.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

class DiscoverViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var discoverTable: DiscoverTableView!
    
    private var selectedEvent : Event?
    
    override func viewDidLoad() {
        // Set this view controller as the delegate for the table
        self.discoverTable.delegate = self
        
        self.titleBar.leftBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "showMap:")
        
        self.titleBar.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: "showSettings:")
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        self.discoverTable.addSubview(refreshControl)
        self.discoverTable.refreshControl = refreshControl
        
        // Set up the listener for APNS
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showEvent:", name: "showEvent", object: nil)
        
        // definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    
    func showMap(sender: AnyObject?) {
        self.performSegueWithIdentifier("ShowMap", sender: sender)
    }
    
    func showSettings(sender: AnyObject?) {
        self.performSegueWithIdentifier("ShowSettings", sender: sender)
    }
    
    /**
     * Handle tapping an event
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedEvent = self.discoverTable.events[indexPath.row]
        
        // De-select the row before we show the link
        self.discoverTable.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("ShowTimeline", sender: nil)
    }
    
    func refresh() {
       Event.all() { (events: [Event]?, err: NSError?) -> Void in
            if events != nil {
                self.discoverTable.events = events!
                
                self.discoverTable.reloadData()
                self.discoverTable.setNeedsDisplay()
                self.discoverTable.refreshControl?.endRefreshing()
            }
        }
    }
    
    /**
     * Show the event. Triggered by a push notification
     */
    func showEvent(sender: AnyObject?) {
        let notification = sender as! NSNotification
        
        let story = (notification.object!["story"] as! String)
        Story.get(story) { (story: Story?, err: NSError?) -> Void in
            if story != nil {
                self.selectedEvent = story?.event
                
                self.performSegueWithIdentifier("ShowTimeline", sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier! == "ShowTimeline" {
            self.discoverTable.searchController.active = false
            let destinationVC = segue.destinationViewController as! TimelineViewController
            destinationVC.event = self.selectedEvent
        }
    }
}