//
//  ViewController.swift
//  Memory Game
//
//  Created by user196685 on 5/7/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var topTenBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onPlayClicked(_ sender: UIButton) {
    }
    
    @IBAction func onTopTenClicked(_ sender: UIButton) {
        print("Top 10")

    }
}

