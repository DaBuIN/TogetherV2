//
//  loginViewController.swift
//  together
//
//  Created by ooo on 03/08/2017.
//  Copyright © 2017 Seven Tsai. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {

    let app = UIApplication.shared.delegate as! AppDelegate
    var passwd:String?
    var account:String?
    var isLogin = true
    var id:String?
    var subjectpic:Array<Any> = []
    var subjectpic2:Array<Any> = []
    var groupimg:Array<String> = []
    var images = [UIImage]()
    var subject:Array<String> = []
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var loginBTN: UIButton!
    
    @IBAction func loginBtn(_ sender: Any) {
        if emailText.text == "" || passwordText.text == "" {
            
            passwordText.isSecureTextEntry = true
            
            
            
            //let account = emailText.text!
            //let passwd = passwordText.text!
        }
        
        Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
            
            
            if error != nil {
                self.alertWrong()
            }else {
                
//                do {
//                    
//                    //passwdText.isSecureTextEntry = true
//                    
//                     let account = self.emailText.text!
//                     let passwd = self.passwordText.text!
//                    
//                    
//                    
//                    let urlString:String = "https://together-seventsai.c9users.io/checkLogin.php?account=\(account)&passwd=\(passwd)"
//                    let url = URL(string:urlString)
//                    let source = try String(contentsOf: url!, encoding: .utf8)
//                    if source == "pass" {
//                        self.app.account = account
//                        self.app.passwd = passwd
//                        self.app.id = self.id
//                        //let vc = storyboard?.instantiateViewController(withIdentifier: "tableviewvc")
//                        //show(vc!, sender: self)
//                        print("ok")
//                    }else if source == "passwdwrong"{
//                        print("抱歉，密碼錯誤．")
//                        self.alertWrong()
//                    }else if source == "accountwrong"{
//                        print("抱歉，帳號錯誤．")
//                        self.alertWrong()
//                    }
//                    
//                }catch{
//                    print(error)
//                }
                self.app.account = self.emailText.text!
                
                Properties.user = User1(authData: user!)
                
                self.alertSuccesslogin()
                
                
                
            }
            
            
            
            //  self.performSegue(withIdentifier: "testvc", sender: nil)
        }
        
        
        
        //do {
        
        //passwdText.isSecureTextEntry = true
        
        // let account = accountText.text!
        // let passwd = passwdText.text!
        
        
        
        //     let urlString:String = "https://together-seventsai.c9users.io/checkLogin.php?account=\(account)&passwd=\(passwd)"
        //     let url = URL(string:urlString)
        //    let source = try String(contentsOf: url!, encoding: .utf8)
        //     if source == "pass" {
        //          self.app.account = account
        //          self.app.passwd = passwd
        //          self.app.id = id
        //let vc = storyboard?.instantiateViewController(withIdentifier: "tableviewvc")
        //show(vc!, sender: self)
        //          print("ok")
        //       }else if source == "passwdwrong"{
        //           print("抱歉，密碼錯誤．")
        //           alertWrong()
        //       }else if source == "accountwrong"{
        //           print("抱歉，帳號錯誤．")
        //           alertWrong()
        //       }
        
        //   }catch{
        //       print(error)
        //   }
        //    alertSuccesslogin()
        
        //Auth.auth().signIn(withEmail: self.accountText.text!, password: self.passwdText.text!) { (user, error) in
        
        //    Properties.user = User1(authData: user!)
        
        
        //  self.performSegue(withIdentifier: "testvc", sender: nil)
        // }
        
        UIView.animate(withDuration: 0.6,
                       animations: {
                        self.loginBTN.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.loginBTN.transform = CGAffineTransform.identity
                        }
        })
        
    
    
}
    
    
    //驗證密碼安全性    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    //alert 空白
    func alertEmpty() {
        
        let alertController = UIAlertController(title: "帳號申請/登入", message: "不能空白喔！", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確認", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
            
        })
        
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    //alert 存在
    func alertExist() {
        let alertController = UIAlertController(title: "帳號已重複", message: "請重新輸入", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確認", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
    }
    //alert 錯誤
    func alertWrong() {
        let alertController = UIAlertController(title: "帳號登入", message: "帳號不存在或密碼錯誤", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確認", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    
    //登入成功  登入成功把id 給delegate
    func alertSuccesslogin() {
        let alertController = UIAlertController(title: "通知", message: "登入成功", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確認", style: .default, handler: {(action) in
            go()
            //            self.dismiss(animated: true, completion: {(action) in
            //
            //
            //            })
        })
        
        
        func go(){
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "tabbarvc")
            show(vc!, sender: self)
        }
        app.mid = Properties.user?.uid
        //loadmygroup()
        //loadDB()
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //read id
//    func loadDB(){
//        if let account = app.account {
//            
//            //c9資料庫 post
//            let url = URL(string: "https://together-seventsai.c9users.io/loadDatafromtable.php")
//            let session = URLSession(configuration: .default)
//            
//            
//            var req = URLRequest(url: url!)
//            
//            req.httpMethod = "POST"
//            req.httpBody = "account=\(account)".data(using: .utf8)
//            
//            let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
//                let source = String(data: data!, encoding: .utf8)
//                
//                //                print(source!)
//                
//                DispatchQueue.main.async {
//                    do{
//                        
//                        
//                        let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                        
//                        for a in  jsonobj as! [[String:String]] {
//                            var idmember = a["id"]!
//                            self.id = idmember
//                        }
//                        
//                        
//                        //self.tbView.reloadData()
//                        
//                    }catch {
//                        print("thisis \(error)")
//                    }}
//                
//                
//                
//                
//                
//            })
//            
//            task.resume()
//            
//        }else {
//            
//            //沒輸入帳號直接跑到的話 給他一個假帳號
//            print("no account")
//            
//        }
//        
//    }
//    
//    
//    //loadtogether
//    
//    
//    func loadmygroup(){
//        
//        
//        if let account = app.account {
//            
//            //c9資料庫 post
//            let url = URL(string: "https://together-seventsai.c9users.io/loadtogetherdb.php")
//            let session = URLSession(configuration: .default)
//            
//            
//            var req = URLRequest(url: url!)
//            
//            req.httpMethod = "POST"
//            req.httpBody = "account=\(account)".data(using: .utf8)
//            
//            let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
//                let source = String(data: data!, encoding: .utf8)
//                
//                //                print(source!)
//                
//                DispatchQueue.main.async {
//                    do{
//                        
//                        
//                        let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                        
//                        for a in  jsonobj as! [[String:String]] {
//                            
//                            //var varsubjectpic = (a["subjectpic"]!)
//                            self.subjectpic2.append(a["subjectpic"])
//                            self.subjectpic = self.subjectpic2
//                            self.subject.append(a["subject"]!)
//                            
//                            // print(self.subjectpic)
//                        }
//                        
//                        
//                        //self.tbView.reloadData()
//                        
//                    }catch {
//                        print("thisis \(error)")
//                    }}
//                
//            })
//            
//            task.resume()
//            
//        }else {
//            
//            //沒輸入帳號直接跑到的話 給他一個假帳號
//            print("no account")
//            
//            
//        }
//        
//        
//        //  sleep(1)
//        
//        
//        // func putimage() {
//        
//        
//        //      do{
//        
//        //        for i in 0..<subjectpic.count {
//        //            let url = URL(string:"\(subjectpic[i])")
//        
//        //let url = URL(string:"")
//        //            let data = try Data(contentsOf: url!)
//        //             images.append(UIImage(data: data)!)
//        //mygroupImage.image = UIImage(data: data)
//        //mygroupControl.numberOfPages = subjectpic.count
//        
//        
//        //        }
//        
//        
//        //     }catch{
//        //         print(error)
//        //     }
//        
//        //print(subjectpic)
//        //print(images)
//        //mygroupImage.image = images[0]
//        //mygroupControl.numberOfPages = images.count
//        
//        
//        //  }
//        
//    }
    
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
