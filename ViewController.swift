//
//  ViewController.swift
//  Assignment4
//
//  Created by Cole Dorma on 2016-03-28.
//  Copyright © 2016 Cole Dorma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var xLabel: UILabel!
    @IBOutlet var oLabel: UILabel!
    
    var xCount: Int = 0
    var oCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func xButton(sender: AnyObject) {
        xCount++
        self.xLabel.text = "X's: \(xCount)"
    }

    @IBAction func oButton(sender: AnyObject) {
        oCount++
        self.oLabel.text = "O's: \(oCount)"
    }
}

