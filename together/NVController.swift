//
//  NVController.swift
//  together
//
//  Created by Seven Tsai on 2017/8/15.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class NVController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //// 背景
        //        (0, 89, 179)
        self.navigationBar.barTintColor = UIColor(red: 79.0/255.0, green: 157.0/255.0, blue: 157/255.0, alpha: 0.7)
        //        (red: 0.0/255.0, green: 89.0/255.0, blue: 179.0/255.0, alpha: 0.7)
        self.navigationBar.barStyle = UIBarStyle.default
        ////title顏色
        //        (79,157,157)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        ////其他item顏色
        self.navigationBar.tintColor = UIColor.blue
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
