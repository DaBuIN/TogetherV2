//
//  whoJoinProfileVC.swift
//  together
//
//  Created by Seven Tsai on 2017/8/11.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class whoJoinProfileVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var nametext:String?
    var detailtext:String?
    var personalpic:String?
    var imgDataBase64String:String?
    var subjectpic:Array<Any> = []
    var groupimg:Array<String> = []
    var images = [UIImage]()
    var subject:Array<String> = []
    var temptid:Array<String> = []
    var Myfilemid:String?
    @IBOutlet weak var takepictureBtn: UIButton!
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var testlabel: UITextView!
    
    
    @IBAction func btnAdmit(_ sender: Any) {
        
        //mastatus  1表狀態為審核結束
        let mastatus = "1"
        let maidForManage = app.whojoinGroupSelectMaid
        
        //表狀態為拒絕
        let admitordeny = "1"
        let url = URL(string: "https://together-seventsai.c9users.io/manageGroup.php")
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: url!)
        req.httpBody = "maid=\(maidForManage!)&admitordeny=\(admitordeny)&mastatus=\(mastatus)".data(using: .utf8)


        req.httpMethod = "POST"
        
        let task = session.dataTask(with: req, completionHandler: {(data,response,error) in
            let source = String(data: data!, encoding: .utf8)
            
            print(source!)
        })
        
        task.resume()
        
        sleep(1)
        
        alertOK(title: "審核完成")
        
    }
    
    @IBAction func btnDeny(_ sender: Any) {
        //mastatus  1表狀態為審核結束
        let mastatus = "1"
        let maidForManage = app.whojoinGroupSelectMaid
        
        //表狀態為拒絕
        let admitordeny = "0"
        let url = URL(string: "https://together-seventsai.c9users.io/manageGroup.php")
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: url!)
        req.httpBody = "maid=\(maidForManage!)&admitordeny=\(admitordeny)&mastatus=\(mastatus)".data(using: .utf8)
        req.httpMethod = "POST"
        
        let task = session.dataTask(with: req, completionHandler: {(data,response,error) in
            let source = String(data: data!, encoding: .utf8)
            
            print(source!)
        })
        
        task.resume()
        
        sleep(1)
        
        alertOK(title: "審核完成")
    }
    func alertOK(title:String){
        
        let alertController = UIAlertController(title: "\(title)", message: "", preferredStyle: .alert)
        let denyAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarvc")
            self.present(vc!, animated: true, completion: nil)
            
        })
        alertController.addAction(denyAction)
        self.present(alertController, animated: true, completion: nil )
    }
    
    //讀取個人資料
    
    func loadDB(){
        Myfilemid = app.whojoinGroupSelectApplyUserMid
        print("申請加入的會員mid是\(Myfilemid!)")
        if let mid = Myfilemid {
            
            //c9資料庫 post
            let url = URL(string: "https://together-seventsai.c9users.io/loadDatafromtable.php")
            let session = URLSession(configuration: .default)
            print("123465")
            
            var req = URLRequest(url: url!)
            
            req.httpMethod = "POST"
            req.httpBody = "mid=\(mid)".data(using: .utf8)
            
            let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
                let source = String(data: data!, encoding: .utf8)
                
                //                print(source!)
                
                DispatchQueue.main.async {
                    
                    
                    do{
                        
                        
                        let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        for a in  jsonobj as! [[String:String]] {
                            var nickname = a["nickname"]!
                            var description = a["description"]
                            var personalpic = a["personalpic"]!
                            self.nameText.text = nickname
                            self.testlabel.text = description
                            
                            do{
                                let url = URL(string:"\(personalpic)")
                                
                                //  print("222\(url)")
                                
                                if url != nil {
                                    let data = try Data(contentsOf: url!)
                                    if (UIImage(data: data) != nil) {
                                        print("OK")
                                        self.takepictureBtn.setImage(UIImage(data: data)!, for: .normal)
                                    }else {
                                        self.takepictureBtn.setImage(UIImage(named: "question.jpg")!, for: .normal)
                                        print("xx")
                                    }
                                    
                                }
                                else {
                                    print("ok")
                                    self.takepictureBtn.setImage(UIImage(named: "question.jpg")!, for: .normal)
                                }
                            }catch{
                                print(error)
                                self.takepictureBtn.setImage(UIImage(named: "question.jpg")!, for: .normal)
                            }
                            
                            
                            print("987654")
                        }
                        
                    }catch {
                        print("thisis \(error)")
                    }
                }
                
            })
            
            task.resume()
            
        }else {
            
            print("no account")
            
            
        }
        
    }
   
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ////navi 的名稱
       navigationItem.title = "申請入團會員資料"
        
        
        loadDB()
        
        let layer = takepictureBtn.layer
        layer.cornerRadius = takepictureBtn.frame.width / 2
        layer.masksToBounds = true

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
