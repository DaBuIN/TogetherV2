//
//  myAllOpenGroupVC.swift
//  together
//
//  Created by Seven Tsai on 2017/8/10.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class myAllOpenGroupVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

        
    @IBOutlet weak var tbView: UITableView!

        var mydataGroup:Array<String> = []
        var mydatatid:Array<String> = []
        var mydataStatus:Array<String> = []
        var mydataSubjectPic:Array<String> = []
    var mydataStartTime:Array<String> = []
    var mydataEndTime:Array<String> = []
   var  mydataOpenGroupMid:Array<String> = []
    var mydataDetail:Array<String> = []
    
        let app = UIApplication.shared.delegate as! AppDelegate

    
        //暫時假裝登入者
        //    let mid = "0"
        var mid:String?
        var tid:String?
    var myAllGroupSelectedTid:String?
        //ＴＢV數量
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return mydataGroup.count
        }
        
        
        
        
        
        //ＴＢ內容
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //////////這是table 我的揪團審核用的
//            let cell = tbView.dequeueReusableCell(withIdentifier: "myallopengroupcell", for: indexPath) as! myAllOpenGroupTBVCell
            
            let cell = tbView.dequeueReusableCell(withIdentifier: "myallopengroupcell", for: indexPath) as! myAllOpenGroupTBVCell
            var formatter: DateFormatter! = nil
            
            formatter = DateFormatter()   //date picker 初始化 日期格式
//            formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //////取得現在時間字串
            let now = Date()
            var nowDateString = formatter.string(from: now)
            print("現在是\(nowDateString)")
            
            
            var startDateAsString = mydataStartTime[indexPath.row]
            var endDateAsString = mydataEndTime[indexPath.row]
            
            
            
            print("我是資料庫讀出來的starttime:\(startDateAsString)")
            print("我是資料庫讀出來的endtime:\(endDateAsString)")
            /////////status label
            if endDateAsString > nowDateString && startDateAsString > nowDateString  {
                cell.labelStatus.text = "揪團熱烈邀請中"
                cell.labelStatus.textColor = UIColor.blue
                print("結束時間大於現在且未開團")
            }else if endDateAsString > nowDateString && startDateAsString < nowDateString {
                cell.labelStatus.text = "揪團舉行中"
                cell.labelStatus.textColor = UIColor.blue
                print("結束時間大於現在且已開團")
            }else if  endDateAsString < nowDateString  {
                cell.labelStatus.text = "揪團結束"
                cell.labelStatus.textColor = UIColor.black
                print("結束時間小於現在")
            }else if endDateAsString == nowDateString    {
                print("結束時間等於現在")
                cell.labelStatus.text = "非常幸運揪團正在舉行"
                cell.labelStatus.textColor = UIColor.black
            }
            
            
            
            
            
            
            
            ////time label
//            cell.starttime.text = mydataStartTime[indexPath.row]
//            cell.endtime.text = mydataEndTime[indexPath.row]
            
            
            /////group label
            ////tid
            cell.tid.text = mydatatid[indexPath.row]
            //主題
            cell.labelCell.text = mydataGroup[indexPath.row]
            //詳細資料
            cell.labeDetail.text = mydataDetail[indexPath.row]
            //照片
            cell.imgSubjectPic.downloadedFrom(link:  "\(mydataSubjectPic[indexPath.row])")
            
            
            //                    if mydataStatus[indexPath.row] == "" {
            //            cell.labelStatus.text = "沒資料"
            //            cell.labelStatus.textColor = UIColor.blue
            //
            //                    }
            //                    else if mydataStatus[indexPath.row] == "0" {
            //                    cell.labelStatus.text = "揪團中"
            //                        cell.labelStatus.textColor = UIColor.black
            //
            //                    }else if mydataStatus[indexPath.row] == "1" {
            //                        cell.labelStatus.text = "揪團結束"
            //                        cell.labelStatus.textColor = UIColor.black
            //                    }
            
            
            /////cell 樣式  有向右指標
            cell.accessoryType = .disclosureIndicator
            //            tbView.separatorColor = nil
            cell.selectionStyle = UITableViewCellSelectionStyle.none

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
            
            
            
      
            let cell = tbView.dequeueReusableCell(withIdentifier: "myallopengroupcell", for: indexPath) as! myAllOpenGroupTBVCell
            ////////cell style
            ///有指標
            cell.accessoryType = .disclosureIndicator
            ////選擇後沒有樣式
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            //            tbView.separatorColor = UIColor.red
            //////////點擊後的顯示文字。要讓他不變
            
            var formatter: DateFormatter! = nil
            
            formatter = DateFormatter()   //date picker 初始化 日期格式
//            formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //////取得現在時間字串
            let now = Date()
            var nowDateString = formatter.string(from: now)
            print("現在是\(nowDateString)")
            
            
            var startDateAsString = mydataStartTime[indexPath.row]
            var endDateAsString = mydataEndTime[indexPath.row]
            
            //            var date1 = formatter.date(from: dateAsString)
            
            
            print("我是資料庫讀出來的starttime:\(startDateAsString)")
            print("我是資料庫讀出來的endtime:\(endDateAsString)")
            /////////status label
            if endDateAsString > nowDateString && startDateAsString > nowDateString  {
                cell.labelStatus.text = "揪團熱烈邀請中"
                cell.labelStatus.textColor = UIColor.blue
                
                /////將選擇的tid值傳給appdelegate
                app.myAllGroupSelectedTid =  mydatatid[indexPath.row]
                print("我的揪團選到的揪團tid是\(app.myAllGroupSelectedTid!)")
                let vc = storyboard?.instantiateViewController(withIdentifier: "whojoinmyopengroupvc")
                show(vc!, sender: self)
                
                print("結束時間大於現在且未開團")
            }else if endDateAsString > nowDateString && startDateAsString < nowDateString {
                cell.labelStatus.text = "揪團舉行中"
                cell.labelStatus.textColor = UIColor.blue
                print("結束時間大於現在且已開團")
                
                /////將選擇的tid值傳給appdelegate
                app.myAllGroupSelectedTid =  mydatatid[indexPath.row]
                print("我的揪團選到的揪團tid是\(app.myAllGroupSelectedTid!)")
                let vc = storyboard?.instantiateViewController(withIdentifier: "whojoinmyopengroupvc")
                show(vc!, sender: self)
            }else if  endDateAsString < nowDateString  {
                cell.labelStatus.text = "揪團結束"
                cell.labelStatus.textColor = UIColor.black
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                ////結束的揪團 直接指定不能選
                //                cell.isUserInteractionEnabled = false
                ///結束的揪團 指定到詳細頁面
                //delegate的tid = 選擇的tid
                app.tid = mydatatid[indexPath.row]
                app.openGroupMid = mydataOpenGroupMid[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail")
                show(vc!, sender: self)
                
                //
                app.tid = mydatatid[indexPath.row]
                print("結束時間小於現在")
            }else if endDateAsString == nowDateString    {
                print("結束時間等於現在")
                cell.labelStatus.text = "非常幸運揪團正在舉行"
                cell.labelStatus.textColor = UIColor.black
                /////將選擇的tid值傳給appdelegate
                app.myAllGroupSelectedTid =  mydatatid[indexPath.row]
                print("我的揪團選到的揪團tid是\(app.myAllGroupSelectedTid!)")
                let vc = storyboard?.instantiateViewController(withIdentifier: "whojoinmyopengroupvc")
                show(vc!, sender: self)
                
            }
            
            ////time label
//            cell.starttime.text = mydataStartTime[indexPath.row]
//            cell.endtime.text = mydataEndTime[indexPath.row]
            
            
            /////group label
            ////tid
            cell.tid.text = mydatatid[indexPath.row]
            cell.labelCell.text = mydataGroup[indexPath.row]
            cell.labeDetail.text = mydataDetail[indexPath.row]
            //照片
            cell.imgSubjectPic.downloadedFrom(link:  "\(mydataSubjectPic[indexPath.row])")
            
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
            mydatatid = []
            mydataStatus = []

            mydataSubjectPic = []
             mydataStartTime = []
             mydataEndTime = []
            //c9資料庫 post
            let url = URL(string: "https://together-seventsai.c9users.io/getMyAllGroup.php")
            let session = URLSession(configuration: .default)
            
            
            var req = URLRequest(url: url!)
            
            req.httpMethod = "POST"
            req.httpBody = "mid=\(mid!)".data(using: .utf8)
            
            let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
                let source = String(data: data!, encoding: .utf8)
                
                //                print(source!)
                
                DispatchQueue.main.async {
                    do{
                        
                        
                        let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        for a in  jsonobj as! [[String:String]] {
                            
                            
                            var detail = a["detail"]!
                            var tid = a["tid"]!
                            var opengroupmid = a["opengroupmid"]!
                            var groupstatus = a["groupstatus"]!
                            var subjectpic = a["subjectpic"]!
                            var subject = a["subject"]!
                            var starttime = a["starttime"]!
                            var endtime = a["endtime"]!
                           
                            var displayLebel = "tid:\(tid)開團者是\(opengroupmid)"
                            
                            //                        print("manageid:\(maid)")
                            //                        print("mastatus:\(mastatus)")
                            //                        print("揪團主題是\(subject)")
                            //                        print("揪團ＩＤ是\(applyGrouptId)")
                            //                        print("創辦者是\(openGroupmId)")
                            //                        print("申請者是\(applyUsermId)")
                            //                        print("-----------")
                            
                            //全部顯示用
                            
                            var formatter: DateFormatter! = nil
                            
                            formatter = DateFormatter()   //date picker 初始化 日期格式
//                            formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            //////取得現在時間字串
                            let now = Date()
                            var nowDateString = formatter.string(from: now)
                            
                            
                            ///如果結束時間大於現在時間 才append進陣列
                            //                            if nowDateString < endtime {
                            
                            self.mydataStatus.append("\(groupstatus)")
                            self.mydataGroup.append("\(subject)")
                            self.mydatatid.append("\(tid)")
                            self.mydataSubjectPic.append("\(subjectpic)")
                            self.mydataOpenGroupMid.append("\(opengroupmid)")
                            self.mydataDetail.append("\(detail)")
                            
                            self.mydataStartTime.append("\(starttime)")
                            self.mydataEndTime.append("\(endtime)")
                            
                            //                            }

                            
                        }
                        print("我的所有開團tid是：\(self.mydatatid)")
                        
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
        
        
    
//        func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        
//        //ask where it is first tab bar item
//        if self.tabBarController?.selectedIndex == 1 {
//            // your action, e.g.:
//            self.loadDB()
//            self.tbView.reloadData()
//            print("從1來成功")
//        }
//        if self.tabBarController?.selectedIndex == 2 {
//            // your action, e.g.:
//            self.loadDB()
//            self.tbView.reloadData()
//            print("從2來成功")
//        }
//        
//        if self.tabBarController?.selectedIndex == 3 {
//            // your action, e.g.:
//            self.loadDB()
//            self.tbView.reloadData()
//            print("從3來成功")
//        }
//    }
//    
    
    
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()

            
            
            
            mid = app.mid
            
            if mid == nil {
                mid = "0"
            }
            
            print("myAllOpenGroupVC我是使用者：\(mid!)")
            
            loadDB()
            
            tbView.refreshControl = UIRefreshControl()
            tbView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            
            
            
            
        }
        
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            tbView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
//            loadDB()
//            tbView.reloadData()
            print("開團過來會執行嗎？？？")
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
//             loadDB()
//        tbView.reloadData()
//        print("點ＴＡＢ會執行嗎？？？")
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
