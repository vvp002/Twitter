//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Vivian Pham on 2/28/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = skyBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Do any additional setup after loading the view.
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

}
