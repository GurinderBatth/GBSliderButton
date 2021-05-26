//
//  ViewController.swift
//  GBSliderButton
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit

class ViewController: UIViewController,GBSliderButtonDelegate {

    @IBOutlet weak var gbView: GBSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gbView.font = UIFont.systemFont(ofSize: 19)
        gbView.gbSliderDelegate = self
    }
    
    func sliderComplete(direction: GBSliderDirection) {
        print("Direction \(direction)")
    }

    @IBAction func reset(){
    }
    
}

