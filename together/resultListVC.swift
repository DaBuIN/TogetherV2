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
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let parentVC = parent as! resultMapListVC
        return (parentVC.groupDict?.count)!
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell") as! resultListTbCell
        
//        cell.groupTitle.text = "DaBuIN"
//        cell.groupContent.text = "我的老天鵝啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"
//        cell.groupStatus.text = "揪團中"
//        cell.groupClass.text = "美食"
        
        let parentVC = parent as! resultMapListVC
        
       
//            cell.groupTitle.text = parentVC.groupDict?[indexPath.row]["subject"]
        
        ///先顯示 tid
        cell.groupTitle.text = parentVC.groupDict?[indexPath.row]["tid"]
            cell.groupContent.text = parentVC.groupDict?[indexPath.row]["detail"]
//        cell.groupContent.text = parentVC.groupDict?[indexPath.row]["opengroupmid"]
            cell.groupStatus.text = "Hot"
            cell.groupClass.text = parentVC.groupDict?[indexPath.row]["class"]
            
       
       
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail") as! Groupdetail
        let parentVC = parent as! resultMapListVC
        
        app.tid = parentVC.groupDict?[indexPath.row]["tid"]
        ///////////////////*********************加來判斷  開團者是誰

        app.openGroupMid = parentVC.groupDict?[indexPath.row]["opengroupmid"]
        ///////////////////*****************************************

        print("selected: \(app.tid)")
        show(vc, sender: self)
        
    }
    
    
    
    ///////*********************************************下拉更新用
    func handleRefresh(){
        
        tableView.refreshControl?.endRefreshing()
        
        ///改為你loaddb
//        loadDB()
        testGroupDict()

        tableView.reloadData()
    }
    ///////////////////*****************************************

    override func viewDidLoad() {
        super.viewDidLoad()

        ///////////////////*********************加來判斷 目前使用者是誰
        mid = app.mid
        
        if mid == nil {
            mid = "0"
        }
        
        print("List頁面目前使用者是\(mid)")
        
        
      
        ///////////////////*****************************************

        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        ///////////////////*****************************************

        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
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
        tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testGroupDict() {
        
        let parentVC = parent as! resultMapListVC
        
        if parentVC.groupDict != nil {
            
            print(parentVC.groupDict?.description)
            
            for group in parentVC.groupDict! {
                for (key, value) in group {
                    print("\(key): \(value)")
                }
            }
        }
        
    }

}
