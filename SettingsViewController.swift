
//
//  SettingsViewController.swift
//  Assignment4
//
//  Created by Cole Dorma on 2016-04-04.
//  Copyright © 2016 Cole Dorma. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var oButton: UIButton!
    @IBOutlet var xButton: UIButton!
    @IBOutlet var xLabel: UILabel!
    @IBOutlet var oLabel: UILabel!
    var xCount: Int = 0
    var oCount: Int = 0
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func xButton(sender: AnyObject) {
        xCount++
        self.xLabel.text = "\(xCount)"
    }
    
    @IBAction func oButton(sender: AnyObject) {
        oCount++
        self.oLabel.text = "\(oCount)"
    }

}