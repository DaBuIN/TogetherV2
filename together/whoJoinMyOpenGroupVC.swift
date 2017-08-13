//
//  whoJoinMyOpenGroupVC.swift
//  together
//
//  Created by Seven Tsai on 2017/8/10.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class whoJoinMyOpenGroupVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tbView: UITableView!
    
    
    let app = UIApplication.shared.delegate as! AppDelegate

    var mydataGroup:Array<String> = []
    var mydatamaid:Array<String> = []
    var mydataStatus:Array<String> = []
    var mydataPic:Array<String> = []
    var mydataApplyMid:Array<String> = []


    
   
    var mid:String?
    var tid:String?
    ////選到的揪團tid
    var myAllGroupSelectedTid:String?
   
    //ＴＢV數量
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mydataGroup.count
    }
    
    
    
    
    
    //ＴＢ內容
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //////////這是table 我的揪團審核用的
        //            let cell = tbView.dequeueReusableCell(withIdentifier: "myallopengroupcell", for: indexPath) as! myAllOpenGroupTBVCell
        
        let cell = tbView.dequeueReusableCell(withIdentifier: "whojoinmyopengroupcell", for: indexPath) as! whojoinmyopengroupTBVCell
        //
        //
        cell.labelCell.text = mydataGroup[indexPath.row]
        //            //        cell.labelStatus.text = "0"
        if mydataStatus[indexPath.row] == "" {
            cell.labelStatus.text = "沒資料"
            cell.labelStatus.textColor = UIColor.blue
            
        }
        else if mydataStatus[indexPath.row] == "0" {
            cell.labelStatus.text = "審核中"
            cell.labelStatus.textColor = UIColor.black
            
        }else if mydataStatus[indexPath.row] == "1" {
            cell.labelStatus.text = "審核結束"
            cell.labelStatus.textColor = UIColor.black
        }
        
        
        ////樣式有 向右指標
        cell.accessoryType = .disclosureIndicator

        
       
        return cell
        
        
        
    }
    
    
    //選擇ＴＢV的實作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //測試
        //        print(indexPath.row)
        //        print(mydata[indexPath.row])
        //        print(myidtoimg[indexPath.row])
        //        self.app.sentToDetailId = myidtoimg[indexPath.row]
        //        print(self.app.sentToDetailId)
        //        gowhere(whichVC: indexPath.row)
        
      
       
        let cell = tbView.dequeueReusableCell(withIdentifier: "whojoinmyopengroupcell", for: indexPath) as! whojoinmyopengroupTBVCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        
        cell.labelCell.text = mydataGroup[indexPath.row]
        
        if mydataStatus[indexPath.row] == "" {
            cell.labelStatus.text = "沒資料"
            cell.labelStatus.textColor = UIColor.blue
            
        }
        else if mydataStatus[indexPath.row] == "0" {
            cell.labelStatus.text = "審核中"
            cell.labelStatus.textColor = UIColor.black
            
        }else if mydataStatus[indexPath.row] == "1" {
            cell.labelStatus.text = "審核結束"
            cell.labelStatus.textColor = UIColor.black
        }

        
        /////令delegate whojoinGroupSelectApplyUserMid = 選到的使用者mid
        app.whojoinGroupSelectApplyUserMid = mydataApplyMid[indexPath.row]
        app.whojoinGroupSelectMaid = mydatamaid[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "whojoinprofile")
        show(vc!, sender: self)
        
    }
    
    
    
    func reload(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "managegroupvc")
        //        show(vc!, sender: self)
        //        self.tabBarController?.selectedIndex = 2
        //        self.handleRefresh()
        
    }
    
    
    
    
    ///VIEWDIDLOAD   讀取ＤＢ資料
    func loadDB(){
        
        
        
        mydataGroup = []
        mydatamaid = []
        mydataStatus = []
        
        //c9資料庫 post
        let url = URL(string: "https://together-seventsai.c9users.io/getWhoJoinMygroup.php")
        let session = URLSession(configuration: .default)
        
        
        var req = URLRequest(url: url!)
        
        req.httpMethod = "POST"
        req.httpBody = "myAllGroupSelectedTid=\(myAllGroupSelectedTid!)".data(using: .utf8)
        
        let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
            let source = String(data: data!, encoding: .utf8)
            
            //                print(source!)
            
            DispatchQueue.main.async {
                do{
                    
                    
                    let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    for a in  jsonobj as! [[String:String]] {
                        
                        
                        
                        var maid = a["maid"]!
                        var mastatus = a["mastatus"]!
                        var applygrouptid = a["applygrouptid"]!
                        var applyusermid = a["applyusermid"]!
                        var admitordeny = a["admitordeny"]!
                        var applytime = a["applytime"]!
                        var judgetime = a["judgetime"]!
                         var updatetime = a["updatetime"]!
                        var nickname = a["nickname"]!
                        //                        var displayLebel = "maid:\(maid)主題是\(subject),創辦者是\(openGroupmId),申請者是\(applyUsermId)"
//                        var displayLebel = "maid:\(maid)申請者是\(nickname)"
                        var displayLebel = "申請者是:\(nickname)"
                        //                        print("manageid:\(maid)")
                        //                        print("mastatus:\(mastatus)")
                        //                        print("揪團主題是\(subject)")
                        //                        print("揪團ＩＤ是\(applyGrouptId)")
                        //                        print("創辦者是\(openGroupmId)")
                        //                        print("申請者是\(applyUsermId)")
                        //                        print("-----------")
                        
                        //全部顯示用
                        
                        
                        
                        
                        //
                                                if mastatus == "0"  {
                        self.mydataStatus.append("\(mastatus)")
                        self.mydataGroup.append("\(displayLebel)")
                        self.mydatamaid.append("\(maid)")
                        self.mydataApplyMid.append("\(applyusermid)")
                                                }
                        
                    }
                    print("申請我揪團的maid是：\(self.mydatamaid)")
                    print("申請我揪團的使用者mid是：\(self.mydataApplyMid)")

                    self.tbView.reloadData()
                    
                }catch {
                    print("thisis \(error)")
                }}
            
            
            
        })
        
        task.resume()
        
        
        
        
    }
    
    
    ///////下拉更新用
    func handleRefresh(){
        
        tbView.refreshControl?.endRefreshing()
        
        
        loadDB()
        tbView.reloadData()
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "揪團審核"
        let app = UIApplication.shared.delegate as! AppDelegate
        ////取得使用者mid是多少
        mid = app.mid
        if mid == nil {
            mid = "0"
        }
        ///取得選取的揪團tid是多少
         myAllGroupSelectedTid = app.myAllGroupSelectedTid

        print("whojoinmygroup我是使用者：\(mid!)")
        print("whojoinmygroup我是選到的揪團id：\(myAllGroupSelectedTid!)")

        loadDB()
        
        tbView.refreshControl = UIRefreshControl()
        tbView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tbView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
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
