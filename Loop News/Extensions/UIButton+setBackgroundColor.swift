//
//  UIButton+setBackgroundColor.swift
//  Loop News
//
//  Created by Andrew Munsell on 12/13/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

extension UIButton {
    /**
     * Allow setting the background color of the button for the specified state
     */
    func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(img, forState: state)
    }
}