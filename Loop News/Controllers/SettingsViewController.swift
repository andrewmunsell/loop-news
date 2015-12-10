//
//  SettingsViewController.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/3/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import Eureka

class SettingsViewController: FormViewController {
    private var subsSection: Section?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        
        // Setup the form
        self.subsSection = Section("Followed Events")
        
        self.form +++ self.subsSection!
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    
    /**
     * Refresh the user's subscriptions
     */
    func refresh() {
        self.subsSection?.removeAll(keepCapacity: true)
        
        Subscription.forCurrentUser { (subs: [Subscription]?, err: NSError?) -> Void in
            if subs != nil {
                for sub in subs! {
                    self.subsSection!
                        <<< LabelRow() {
                            $0.title = sub.event.title
                        }
                }
            }
            
            if subs == nil || subs!.count < 1 {
                self.subsSection!
                    <<< LabelRow() {
                        $0.title = "You don't have any subscriptions."
                        $0.disabled = true
                        
                        $0.evaluateDisabled()
                    }
            }
        }
    }
}