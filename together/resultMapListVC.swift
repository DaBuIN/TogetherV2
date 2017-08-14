//
//  segmentMapListVC.swift
//  together
//
//  Created by Chuei-Ching Chiou on 04/08/2017.
//  Copyright © 2017 Seven Tsai. All rights reserved.
//

import UIKit

class resultMapListVC: UIViewController {
    
    var app = UIApplication.shared.delegate as! AppDelegate
    
    var groupDict:[[String:String]]?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contViewList: UIView!
    @IBOutlet weak var contViewMap: UIView!
    @IBAction func toEditSearch(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchvc") as! searchGroupVC
        
        show(vc, sender: self)
        
    }
    
    
    
    @IBAction func didEditSearch(_ sender: UIStoryboardSegue) {
        print("修改了搜尋條件")
    }
    
    
    @IBAction func changeShowMode(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("List")
            
            contViewMap.isHidden = true
            contViewList.isHidden = false

            
        case 1:
            print("Map")
            
            contViewMap.isHidden = false
            contViewList.isHidden = true
            
        default:
            print("Map")
            
            contViewMap.isHidden = false
            contViewList.isHidden = true
            
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        self.segmentedControl.selectedSegmentIndex = 0 // List
        
        groupDict = []
        //self.loadTogetherDB()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.changeShowMode(segmentedControl)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.changeShowMode(segmentedControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    public func loadTogetherDB() {
//        
//        print("loadTogetherDB()")
//        
//        let url = URL(string: "https://together-seventsai.c9users.io/searchTogetherDB.php")
////        let url = URL(string: "http://127.0.0.1/searchTogetherDB.php")
//        let session = URLSession(configuration: .default)
//        
//        var req = URLRequest(url: url!)
//        
////        req.httpMethod = "POST"
////        req.httpBody = "mid=\(app.mid!)".data(using: .utf8)
//        
//        req.httpMethod = "GET"
//        req.httpBody = "".data(using: .utf8)
//        
//        
//        let task = session.dataTask(with: req, completionHandler: {(data, response, session_error) in
//            
//            self.groupDict = []
//            
//            DispatchQueue.main.async {
//                
//                
//                do {
//                    let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                    
//                    let allObj = jsonObj as! [[String:String]]
//                    var group:[String:String] = [:]
//                    
//                    for obj in allObj {
//                        for (key, value) in obj {
//                            group["\(key)"] = value
//                        }
//                        
//                        self.groupDict! += [group]
//                    }
//                    
//                    let queue = DispatchQueue(label: "saveDB")
//                    
//                    for obj in allObj {
//                        
//                        queue.async {
//                            for (key, value) in obj {
//                                //                        print("\(key): \(value)")
//                                group["\(key)"] = value
//                            }
//                        }
//                        
//                        queue.async {
//                            self.groupDict! += [group]
//                        }
//                        
//                        
//                    }
//                    
//                    sleep(1)
//                    
//                    
//                } catch {
//                    print(error)
//                }
//            }
//            
//        })
//        
//        task.resume()
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let segId = segue.identifier!
//        
//        if segId == "segResultList" {
//            let vc = segue.destination as! resultListVC
//            vc.testGroupDict()
//        }
//    }


}
