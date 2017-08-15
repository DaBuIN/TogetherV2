//
//  tabBarVC.swift
//  together
//
//  Created by Seven Tsai on 2017/8/11.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class tabBarVC: UITabBarController {

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("tabbar select")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //(79,157,157) (255, 117, 117) (41, 148, 255)
        self.tabBar.barTintColor = UIColor(red: 79.0/255.0, green: 157.0/255.0, blue: 157/255.0, alpha: 0.7)
        //        (red: 41.0/255.0, green: 148.0/255.0, blue: 117/255.0, alpha: 1.0)
        
        //        (red: 255.0/255.0, green: 117.0/255.0, blue: 117/255.0, alpha: 1.0)
        //        (red: 79.0/255.0, green: 157.0/255.0, blue: 157/255.0, alpha: 0.7)
        self.tabBar.unselectedItemTintColor = UIColor.black
        self.tabBar.tintColor = UIColor.blue
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
