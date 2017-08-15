//
//  resultListVC.swift
//  together
//
//  Created by Chuei-Ching Chiou on 04/08/2017.
//  Copyright © 2017 Seven Tsai. All rights reserved.
//

import UIKit

class resultListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var app = UIApplication.shared.delegate as! AppDelegate
    var mid:String?
    var tid:String?
    var openGroupmid:String?
    
    var groupDict:[[String:String]]?
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.groupDict?.count)!
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell") as! resultListTbCell
        
        
        
        //            cell.groupTitle.text = self.groupDict?[indexPath.row]["subject"]
        
//        let picStr = groupDict?[indexPath.row]["subjectpic"]
//        cell.groupImg.downloadedFrom(link: "\(picStr)")
        
        ///先顯示 tid
        cell.groupTitle.text = self.groupDict?[indexPath.row]["tid"]
        cell.groupContent.text = self.groupDict?[indexPath.row]["detail"]
        //        cell.groupContent.text = self.groupDict?[indexPath.row]["opengroupmid"]
        cell.groupStatus.text = "Hot"
        cell.groupClass.text = self.groupDict?[indexPath.row]["class"]
//        cell.groupImg.image = UIImage(named:"question.jpg")

////        print("\(self.groupDict?[indexPath.row]["subjectpic"]!)")
//         cell.groupImg.downloadedFrom(link: "\( self.groupDict?[indexPath.row]["subjectpic"]! )"  )
//
        if let picStr = groupDict?[indexPath.row]["subjectpic"] {
            cell.groupImg.downloadedFrom(link: "\(picStr)")
//            cell.groupImg.image = UIImage(named:"question.jpg")
            
        } else {
            cell.groupContent.text = (groupDict?[indexPath.row]["subjectpic"])
        }
        
        
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail") as! Groupdetail
        
        app.tid = self.groupDict?[indexPath.row]["tid"]
        ///////////////////*********************加來判斷  開團者是誰

        app.openGroupMid = self.groupDict?[indexPath.row]["opengroupmid"]
        ///////////////////*****************************************

        print("selected: \(app.tid!)")
        show(vc, sender: self)
        
    }
    
    
    
    ///////*********************************************下拉更新用
    func handleRefresh(){

//        DispatchQueue.main.async {
//            self.loadTogetherDB()
//
//        }
        tableView.refreshControl?.endRefreshing()

        loadTogetherDB()

        tableView.reloadData()

        testGroupDict()
//        sleep(1)
//        tableView.reloadData()
    }
    ///////////////////*****************************************

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.dataSource = self
        tableView.delegate = self
        groupDict = []
        
//        DispatchQueue.main.async {
//            self.loadTogetherDB()
//
//        }
        loadTogetherDB()

        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        ///////////////////*****************************************

        
    }
    
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///////////////////*****************************************

        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
        ///////////////////*****************************************

        testGroupDict()
        sleep(1)
//        self.automaticallyAdjustsScrollViewInsets = true

//        tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testGroupDict() {
        
//        let parentVC = parent as! resultMapListVC
        
        if self.groupDict != nil {
            
            print(self.groupDict?.description)
            
            for group in self.groupDict! {
                for (key, value) in group {
                    print("\(key): \(value)")
                }
            }
        }
        
    }
    
    public func loadTogetherDB() {
        
        print("loadTogetherDB()")
        
        let url = URL(string: "https://together-seventsai.c9users.io/searchTogetherDB.php")
        //        let url = URL(string: "http://127.0.0.1/searchTogetherDB.php")
        let session = URLSession(configuration: .default)
        
        var req = URLRequest(url: url!)
        
        
        req.httpMethod = "GET"
        req.httpBody = "".data(using: .utf8)
        
        
        let task = session.dataTask(with: req, completionHandler: {(data, response, session_error) in
            
            self.groupDict = []
            
            DispatchQueue.main.async {
                
            
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                let allObj = jsonObj as! [[String:String]]
                var group:[String:String] = [:]
                
                
                for obj in allObj {
                    for (key,value) in obj {
                        group["\(key)"] = value
                    }
                    
                    self.groupDict?.append(group)

                }
                
                self.tableView.reloadData()
                
            } catch {
                print(error)
            }}
            
        })
        
        task.resume()
//        sleep(1)
    }
    
}
