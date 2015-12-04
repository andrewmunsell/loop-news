//
//  DiscoverViewController.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

class DiscoverViewController: UIViewController {
    @IBOutlet weak var titleBar: UINavigationItem!

    override func viewDidLoad() {
        self.titleBar.leftBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "showMap:")
        
        self.titleBar.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: "showSettings:")
    }
    
    func showMap(sender: AnyObject?) {
        self.performSegueWithIdentifier("ShowMap", sender: sender)
    }
    
    func showSettings(sender: AnyObject?) {
        self.performSegueWithIdentifier("ShowSettings", sender: sender)
    }
}