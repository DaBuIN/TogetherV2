//
//  manageApplyViewVC.swift
//  together
//
//  Created by Seven Tsai on 2017/7/31.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class manageApplyViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tbView: UITableView!
    
    //mastatus = 0 時的陣列。 申請中
     var mydataTid:Array<String> = []
     var mydataDetail:Array<String> = []
    var mydataGroup:Array<String> = []
    var mydataMaid:Array<String> = []
    var mydataStatus:Array<String> = []
    var mydataAdmitOrDeny:Array<String> = []
    var mydataOpenGroupMid:Array<String> = []
    var mydataSubjectPic:Array<String> = []
    //    //mastatus = 1 時的陣列  審核結束
    //    var mydataStatusFinish:Array<String> = []
    //    var mydataGroupFinish:Array<String> = []
    //    var mydataMaidFinish:Array<String> = []
    let app = UIApplication.shared.delegate as! AppDelegate


    var mid:String?
//    var applyToDetailTid:String?
    var applyToDetailMastatus:String?
    
    //ＴＢV數量
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mydataGroup.count
    }
    
    
    
    //ＴＢ內容
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //////////這是table 我的揪團審核用的
        
        let cell = tbView.dequeueReusableCell(withIdentifier: "manageapplycell", for: indexPath) as! applyGroupTBVCell
        
     
     
        ////Status 0為申請中 1為審核結束
        switch mydataStatus[indexPath.row] {
        case "0":
            cell.labelStatus.text = "申請中"
            
        case "1":
            //////admitOrDeny 0為拒絕申請 1入團成功
            if mydataAdmitOrDeny[indexPath.row] == "0" {
                cell.labelStatus.text = "拒絕申請"
            }else if mydataAdmitOrDeny[indexPath.row] == "1" {
                cell.labelStatus.text = "入團成功"
                
            }
        default:
            break
        }
        
        
        /////主題
        cell.labelCell.text = mydataGroup[indexPath.row]
        ///號碼
        cell.labelNumber.text = mydataTid[indexPath.row]
        ////詳細資料
        cell.labelDetail.text = mydataDetail[indexPath.row]
        ////主題圖片
        cell.imgSubjectPic.downloadedFrom(link: "\(mydataSubjectPic[indexPath.row])")
        
        /////cell 樣式  有向右指標
        cell.accessoryType = .disclosureIndicator
        //            tbView.separatorColor = nil
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
        
        
        
    }
    
    
    //選擇ＴＢV的實作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tbView.dequeueReusableCell(withIdentifier: "manageapplycell", for: indexPath) as! applyGroupTBVCell
        
        switch mydataStatus[indexPath.row] {
        case "0":
            cell.labelStatus.text = "申請中"
            
        case "1":
            //////admitOrDeny 0為拒絕申請 1入團成功
            if mydataAdmitOrDeny[indexPath.row] == "0" {
                cell.labelStatus.text = "拒絕申請"
            }else if mydataAdmitOrDeny[indexPath.row] == "1" {
                cell.labelStatus.text = "入團成功"
                
            }
        default:
            break
        }
        app.tid = mydataTid[indexPath.row]
        app.openGroupMid = mydataOpenGroupMid[indexPath.row]
        app.applyToDetailMastatus = mydataStatus[indexPath.row]
        /////點擊到detail頁面
    
        let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail")
        show(vc!, sender: self)
        
        
        
        /////主題
        cell.labelCell.text = mydataGroup[indexPath.row]
        ///號碼
        cell.labelNumber.text = mydataTid[indexPath.row]
        ////詳細資料
        cell.labelDetail.text = mydataDetail[indexPath.row]
        ////主題圖片
        cell.imgSubjectPic.downloadedFrom(link: "\(mydataSubjectPic[indexPath.row])")
        
        ///Style
        cell.selectionStyle = UITableViewCellSelectionStyle.none
       
        cell.accessoryType = .disclosureIndicator


    }
    
    
    
    ///VIEWDIDLOAD   讀取ＤＢ資料
    func loadDB(){
        
        
        mydataGroup = []
        mydataMaid = []
        mydataStatus = []
        mydataTid = []
         mydataDetail = []
         mydataStatus = []
         mydataAdmitOrDeny = []
         mydataOpenGroupMid = []
        mydataSubjectPic = []
        
        //c9資料庫 post
        let url = URL(string: "https://together-seventsai.c9users.io/getMyApplyGroup.php")
        let session = URLSession(configuration: .default)
        
        
        var req = URLRequest(url: url!)
        
        req.httpMethod = "POST"
//        req.httpBody = "tid=\(tid)mid=\(mid!)".data(using: .utf8)
        req.httpBody = "mid=\(mid!)".data(using: .utf8)

        let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
            print("data是我：\(data)")
            print("error是我：\(error)")
            if data != nil{
                let source = String(data: data!, encoding: .utf8)
                
                //                print(source!)
                DispatchQueue.main.async {
                    do{
                        
                        
                        let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        for a in  jsonobj as! [[String:String]] {
                            
                            
                            //managegroupid
                            var maid = a["maid"]!
                            //managegroup 資料表 的狀態 0 表申請中,1表已審核
                            var mastatus = a["mastatus"]!
                            //1允許或0拒絕。
                            var admitordeny = a["admitordeny"]!
                            //申請的團tid
                            var applyGrouptId = a["applygrouptid"]!
                            //申請者mid
                            var applyUsermId = a["applyusermid"]!
                            //開團者mid
                            var openGroupmId = a["opengroupmid"]!
                            //主題名稱
                            var subject = a["subject"]!
                            //主題詳細資料
                            var detail = a["detail"]!

                            var subjectpic =  a["subjectpic"]!
                            
                            
//                            var displayLebel = "maid:\(maid)主題是\(subject),創辦者是\(openGroupmId),申請者是\(applyUsermId)"
                            var displayLebel = "\(subject)"

//                                                    print("manageid:\(maid)")
//                                print(displayLebel)
//                            print("mastatus:\(mastatus)")
//                                                    print("審核狀態是\(admitordeny)")
//
////                                                    print("揪團主題是\(subject)")
//                                                    print("揪團ＩＤ是\(applyGrouptId)")
////                                                    print("創辦者是\(openGroupmId)")
//                                                    print("申請者是\(applyUsermId)")
//                            print("-----------")
                            
                           
                            ///如果申請者mid 與 使用者mid 一致的話。才append進array
                            ///目前顯示所有案件狀態
                            if  applyUsermId == self.mid {
                                self.mydataTid.append("\(applyGrouptId)")
                                self.mydataOpenGroupMid.append("\(openGroupmId)")
                                self.mydataDetail.append("\(detail)")

                                self.mydataStatus.append("\(mastatus)")
                                self.mydataGroup.append("\(displayLebel)")
                                self.mydataMaid.append("\(maid)")
                                self.mydataAdmitOrDeny.append("\(admitordeny)")
                                self.mydataSubjectPic.append("\(subjectpic)")
                            }
                            
                            
                            //                            //如果狀態為申請中 且 申請者id ＝使用者id
                            //                            if mastatus == "0" &&  applyUsermId == self.mid {
                            //                                self.mydataStatus.append("\(mastatus)")
                            //                                self.mydataGroup.append("\(displayLebel)")
                            //                                self.mydataMaid.append("\(maid)")
                            //                            }
                            
                            //                            // 如果狀態為審核結束 且 申請者id ＝ 使用者id
                            //                            if mastatus == "1" &&  applyUsermId == self.mid {
                            //                                self.mydataStatusFinish.append("\(mastatus)")
                            //                                self.mydataGroupFinish.append("\(displayLebel)")
                            //                                self.mydataMaidFinish.append("\(maid)")
                            //                            }
                            
                            
                            
                            
                        }
                        
                        self.tbView.reloadData()
                        
                    }catch {
                        print("CATCH的錯誤是我 \(error)")
                    }}
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
        })
        
        task.resume()
        
        
        
        
    }
    
    
    
    func handleRefresh(){
        loadDB()
        tbView.refreshControl?.endRefreshing()
        
        
        
        tbView.reloadData()
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        ////取得目前使用者是誰
        mid = app.mid
        
        if mid == nil {
            mid = "0"
        }
        
        print("manageApplyviewVC我是使用者：\(mid!)")

        loadDB()
        
        //tb沒有分割線
//        self.tbView.separatorStyle = UITableViewCellSeparatorStyle.singleLine

        tbView.refreshControl = UIRefreshControl()
        tbView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tbView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
//        loadDB()
//        tbView.reloadData()
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
