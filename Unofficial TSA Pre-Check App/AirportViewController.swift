//
//  AirportViewController.swift
//  Unofficial TSA Pre-Check App
//
//  Created by Ryan Valle on 9/2/17.
//  Copyright © 2017 Ryan Valle. All rights reserved.
//

import UIKit

class AirportViewController: UIViewController {
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
    @IBOutlet weak var precheckStatus: UILabel!
    
    var selectedAirport: NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitle.title = selectedAirport["name"] as? String
        
        let shortcode = selectedAirport["shortcode"] as! String
        let isPrecheck = selectedAirport["precheck"] as? Bool
        var availability = false
        if let pc = isPrecheck {
            availability = pc
        }
        precheckStatus.text = availability ? "\(shortcode) offers TSA PreCheck!" : "Trasnportaiton security agency PreCheck is unavailable at \(shortcode)"
        precheckStatus.backgroundColor = availability ? uicolor_green : uicolor_red
        precheckStatus.textColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
