//
//  Groupdetail.swift
//  together
//
//  Created by ooo on 29/07/2017.
//  Copyright © 2017 Seven Tsai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Groupdetail: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //會員id
    
    var mid:String?
    var tid:String?
    var openGroupmid:String?
    var mastatus:String?
    let app = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var subjectpicView: UIImageView!
    @IBOutlet weak var subjectDescrption: UITextView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var Msgboard: UITableView!
    @IBOutlet weak var btnApplyOulet: UIBarButtonItem!
    
    
    
    
    
    
    
    
    
    ///////////申請加入揪團按鈕
    
    @IBAction func btnApplyGroup(_ sender: Any) {
        
        
        
        
        //////// tid == 從別頁帶進來的Gtid
        tid = Gtid
        
        
        let url = URL(string: "https://together-seventsai.c9users.io/applyGroup.php")
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: url!)
        
        req.httpBody = "mid=\(mid!)&tid=\(tid!)".data(using: .utf8)
        
        req.httpMethod = "POST"
        
        let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
            //        print(data)
            
            let source  =  String(data: data!, encoding: .utf8)
            
            print(source!)
            
            
            
        })
        
        task.resume()
        self.alertApply(title: "申請揪團已送出", message: "請靜候佳音")
    }
    /////申請 ALERT用
    func alertApply(title:String,message:String){
        
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarvc")
            self.present(vc!, animated: true, completion: nil)
            
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil )
    }
    
    
    @IBAction func ReviewBtn(_ sender: Any) {
        
        alertReview()
    }
    
    @IBOutlet weak var JoinGroup: UIButton!
    var GStartime:String?
    var GEndtime:String?
    var GLocaion:String?
    var Gsubject:String?
    var Gtid:String?
    var Gmid:String?
    //var nickname:String?
    var groupReviews: [GroupReviewItem] = [GroupReviewItem]()
    
    //loadtogether
    
    func loadmygroup(){
        
        Gtid = app.tid
        if let tid = Gtid {
            
            //c9資料庫 post
            let url = URL(string: "https://together-seventsai.c9users.io/loadtogetherdb.php")
            let session = URLSession(configuration: .default)
            
            
            var req = URLRequest(url: url!)
            
            req.httpMethod = "POST"
            req.httpBody = "tid=\(tid)".data(using: .utf8)
            
            let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
                let source = String(data: data!, encoding: .utf8)
                
                //                print(source!)
                
                DispatchQueue.main.async {
                    do{
                        
                        
                        let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        for a in  jsonobj as! [[String:String]] {
                            
                            self.Gsubject = a["subject"]
                            self.subject.text = a["subject"]
                            self.starttime.text = a["starttime"]
                            self.endtime.text = a["endtime"]
                            self.location.text = a["location"]
                            self.subjectDescrption.text = a["detail"]
                            var TempSubjectpic:String = a["subjectpic"]!
                            let url = URL(string:"\(TempSubjectpic)")
                            
                            do{
                                if url != nil{
                                    let data = try Data(contentsOf: url!)
                                    if (UIImage(data: data) != nil) {
                                        print("OK")
                                        DispatchQueue.main.async {
                                            self.subjectpicView.image = UIImage(data: data)!

                                        }
                                    }else {
                                        DispatchQueue.main.async {
                                            self.subjectpicView.image = UIImage(named:"question.jpg")
                                        }
                                    }
                                    
                                }else {
                                    DispatchQueue.main.async {
                                        self.subjectpicView.image = UIImage(named:"question.jpg")
                                    }
                                    
                                }
                                
                            }catch{
                                print(error)
                            }
                            
                        }
                        
                    }catch {
                        print("thisis \(error)")
                    }
                }
                
            })
            
            task.resume()
            
        }else {
            
            print("no mid")
            
        }

    }
    
    
    
    @IBAction func applyGroup(_ sender: Any) {
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupReviews.count
    }
    
    // 表格的儲存格設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupReviewTableViewCell", for: indexPath) as! GroupReviewTableViewCell
        
        //var temppic = self.groupReviews[indexPath.row].userId
        
        Gmid = app.mid
        
        //print("why\(Gmid)")
        let url = URL(string: "https://together-seventsai.c9users.io/loadDatafromtable.php")
        let session = URLSession(configuration: .default)
        
        var req = URLRequest(url: url!)
        
        req.httpMethod = "POST"
        req.httpBody = "mid=\(Gmid!)".data(using: .utf8)
        
        
        //print("hjjjjjjj")
        let task = session.dataTask(with: req, completionHandler: {(data, response,error) in

            let source = String(data: data!, encoding: .utf8)
            
            //print("qeqweqwe\(source)")
            DispatchQueue.main.async {
                
                //print("hjjjjkkkkkjjj")
 
                do{
                    
                    let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    for a in  jsonobj as! [[String:String]] {
                        var nickname = a["nickname"]!
                        var personalpic = a["personalpic"]!
                        //self.nickname = nickname
                        cell.loginUser.text = nickname
                        //print("why?")
                        do{
                            let url = URL(string:"\(personalpic)")
                            
                            //  print("222\(url)")
                            //處理圖片路徑錯誤或者破圖
                            if url != nil {
                                let data = try Data(contentsOf: url!)
                                if (UIImage(data: data) != nil) {
                                    print("OK")
                                    cell.ProfileImg.image = UIImage(data: data)!
                                    //                                    self.takepictureBtn.setImage(UIImage(data: data)!, for: .normal)
                                    //print("isnn")
                                }else {
                                    cell.ProfileImg.image = UIImage(named:"question.jpg")
                                    //                                    self.takepictureBtn.setImage(UIImage(named: "question.jpg")!, for: .normal)
                                    print("xx")
                                }
                                
                            }
                            else {
                                print("ok")
                                cell.ProfileImg.image = UIImage(named:"question.jpg")
                                
                            }
                        }catch{
                            print(error)
                            cell.ProfileImg.image = UIImage(named:"question.jpg")
                            
                        }
                        
                        
                        //print("987654")
                    }
                    
                }catch {
                    print("thisis \(error)")
                }
            }
//                        DispatchQueue.main.async {
//                            let source = String(data: data!, encoding: .utf8)
//            
//                            if source != "" {
//                                let url = URL(string:"\(source)")
//                                do{
//                                    let data = try Data(contentsOf: url!)
//                                    cell.ProfileImg.image = UIImage(data: data)!
//                                }catch{
//                                    print(error)
//                                }
//                            }else {
//                                cell.ProfileImg.image = UIImage(named:"question.jpg")
//                            }
//                            
//                        }
        })
        
        task.resume()
        //cell.loginUser.text = self.nickname
        cell.reViewTextView?.text = self.groupReviews.reversed()[indexPath.row].groupReview
        //cell.loginUser.text = self.groupReviews.reversed()[indexPath.row].userEmail
        cell.Timelabel.text = self.groupReviews.reversed()[indexPath.row].createDate
        let mmid = app.mid
        if mmid == self.groupReviews.reversed()[indexPath.row].userId {
            //cell.backgroundColor = UIColor.blue
           // cell.reViewTextView.backgroundColor = UIColor.blue
            cell.loginUser.textColor = UIColor.darkGray
        }
        
        let layer = cell.ProfileImg.layer
        layer.cornerRadius = 20.0
        layer.masksToBounds = true
        
        return cell
    }
    
    // use alert function to edit review
    
    func alertReview() {
        let alert = UIAlertController(title: "輸入留言", message: "請輸入留言", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action) in
            //self.dismiss(animated: true, completion: nil)
            //self.go()
        })
        
        let reviewAction = UIAlertAction(title: "留言", style: .default, handler: {(action) in
            
            let reviewText = alert.textFields![0].text as! String
            
            //print ("\(reviewText)")
            
            if reviewText == "" {
                self.alertEmpty()
                return
            }
            
            self.Gtid = self.app.tid
            
            // 新增節點資料
            let reference: DatabaseReference! = Database.database().reference().child("groupReviews").child("\(self.Gtid)")
            let childRef: DatabaseReference = reference.childByAutoId() // 隨機生成的節點唯一識別碼，用來當儲存時的key值
            
            // get date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/M/d H:m"
            let string = formatter.string(from: Date())
            
            
            //id name 再修正為團名以及ID
            var movieReview: [String : AnyObject] = [String : AnyObject]()
            movieReview["groupId"] = "\(self.Gtid)" as AnyObject
            movieReview["childId"] = childRef.key as AnyObject
            movieReview["groupName"] = "\(self.Gsubject)" as AnyObject
            movieReview["groupReview"] = reviewText as AnyObject
            movieReview["userId"] = (Properties.user?.uid)! as AnyObject
            movieReview["userEmail"] = (Properties.user?.email)! as AnyObject
            movieReview["createDate"] = "\(string)" as AnyObject
            //movieReview["nickname"] = "\(nickname)" as AnyObject
            
            
            
            let movieReviewReference = reference.child(childRef.key)
            movieReviewReference.updateChildValues(movieReview) { (err, ref) in
                if err != nil{
                    print("err： \(err!)")
                    return
                }
                
                print(ref.description())
                
                // 返回上一頁
                //_ = self.navigationController?.popViewController(animated: true)
                //self.go()
                
                
            }
            
            
        })
        
        alert.addTextField {
            (textField) in textField.placeholder = "留言"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(reviewAction)
        
        self.present(alert, animated: true, completion: nil)

        //show(alert, sender: self)
        
        
    }
    
    
    func go(){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "navadetailvc")
        
       // self.present(vc!, animated: true, completion: nil)

        show(vc!, sender: self)
        //self.tabBarController?.selectedIndex = 4
    }
    
    
    func alertEmpty() {
        
        let alertController = UIAlertController(title: "請輸入評論", message: "不能空白喔！", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確認", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
            
        })
        
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        mid = app.mid
        mastatus = app.applyToDetailMastatus
        if mid == nil {
            mid = "0"
        }
        
        print("detail頁面目前使用者是\(mid)")
        
        
        /////////////////////申請按鈕用
        ////判斷使用者是不是創團者。
        
        openGroupmid = app.openGroupMid
        print("detail頁面目前創團者是\(openGroupmid)")
//        btnApplyOulet.isEnabled = false
        
        //如果是同一個人   不顯示申請加入按鈕
        if mid == openGroupmid  {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        ////////////********************
        loadmygroup()
        
        let groupViewLayer = subjectpicView.layer
        groupViewLayer.cornerRadius = 20.0
        groupViewLayer.masksToBounds = true
        
        self.Gtid = self.app.tid
        
        let reference: DatabaseReference! = Database.database().reference().child("groupReviews").child("\(self.Gtid)")
        
        reference.queryOrderedByKey().observe(.value, with: { snapshot in
            if snapshot.childrenCount > 0 {
                var dataList: [GroupReviewItem] = [GroupReviewItem]()
                
                for item in snapshot.children {
                    let data = GroupReviewItem(snapshot: item as! DataSnapshot)
                    dataList.append(data)
                }
                
                self.groupReviews = dataList
                self.Msgboard.reloadData()
            }
            
            //self.reviewBtn.isEnabled = true
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
