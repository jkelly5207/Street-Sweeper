//
//  StreetViewController.swift
//  Street Sweeper
//
//  Created by Jason Kelly on 12/10/22.
//

import UIKit

class StreetViewController: UIViewController {
    
    let StreetDict: [ String: [String] ] = [
        
        "1st & 3rd Monday": [],
        "1st & 3rd Tuesday": ["Prince St.",
                              "Snow Hill St. (Hull St - Charter St)",
                              "Hull St - (Snow Hill St - Commerical St)"],
        "1st & 3rd Wednesday": [],
        "1st & 3rd Thursday": [],
        "1st & 3rd Friday": ["Charter St."],
        
        "2nd & 4th Monday": [],
        "2nd & 4th Tuesday": [
            "Hull St. (Salem St - Snow Hill St)",
            "Snow Hill St. (Snow Hill St - Prince St)"],
        "2nd & 4th Wednesday": [],
        "2nd & 4th Thursday": [],
        "2nd & 4th Friday": ["Salem St. (Prince St - Charter St)"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
