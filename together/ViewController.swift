//
//  ViewController.swift
//  together
//
//  Created by Seven Tsai on 2017/7/17.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    
    let app = UIApplication.shared.delegate as! AppDelegate
   
    let loginObj = loginViewController()
    
    @IBAction func testDate(_ sender: Any) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: "01-01-2017") //according to date format your date string
        print(date ?? "") //Convert String to Date
        
        dateFormatter.dateFormat = "MMM d, yyyy" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date!) //pass Date here
        print(newDate) //New formatted Date string
        
        
        
        
        
        
        let myDatePicker = UIDatePicker()
        
        //模式
        myDatePicker.datePickerMode = .dateAndTime
        
        //時區
        myDatePicker.locale = Locale(identifier: "zh_TW")
        
        //預設日期
        
        
//        myDatePicker.date = Date()
//        
//        myDatePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
//        
//        //鍵盤置換
//        textField.inputView = myDatePicker
//        
//        //預設內容
//        textField.text = formatter.string(from: myDatePicker.date)
//
//        
//        
//        
//        
//        
//        let url = URL(string: "https://together-seventsai.c9users.io/openGroup.php")
//        let session = URLSession(configuration: .default)
//        var req = URLRequest(url: url!)
//        
//        ////STRING == 拍照或擷取相簿的base64String 用來傳給後端
//        subjectpicString = imgDataBase64String
//        
//        //如果subjectpicString != nil 傳data參數至後端
//        if subjectpicString != nil {
//            req.httpBody = "mid=\(mid!)&subject=\(subject!)&location=\(location!)&lat=\(locationLat!)&lng=\(locationLng!)&starttime=\(starttime!)&endtime=\(endtime!)&class=\(classType!)&detail=\(detail!)&data=\(subjectpicString!)".data(using: .utf8)
//            
//            
//            print("has photo")
//        }else {
//            ////如果沒有選照片 subjectpicString = nil 則傳送data空字串參數至後端
//            req.httpBody = "mid=\(mid!)&subject=\(subject!)&location=\(location!)&lat=\(locationLat!)&lng=\(locationLng!)&starttime=\(starttime!)&endtime=\(endtime!)&class=\(classType!)&detail=\(detail!)".data(using: .utf8)
//            print("no photo")
//        }
//        
//        
//        
//        req.httpMethod = "POST"
//        
//        
//        let task = session.dataTask(with: req, completionHandler: {(data,response,error) in
//            if error == nil {
//                
//                print("add success")
//                let source = String(data: data!, encoding: .utf8)
//                print(source!)
//                
//            }else{ print(error)}
//            
//            
//        })
//        task.resume()
//        
        
    }
    /////直接以a帳號登入用
    @IBAction func aAccountLogin(_ sender: Any) {
        app.mid = "kO2iktB0BHRkDEhZVn8ds0s3G572"
       
     go()
        
      
    }
    /////直接以s帳號登入用
    @IBAction func sAccountLogin(_ sender: Any) {
         app.mid = "PaN9703dbLZ5s13wEjopxXCLMu52"
        go()
        
    }
    
    
    @IBAction func QLogin(_ sender: Any) {
        app.mid = "Bdsl773vHqTAVw4xwKQ2AsHRDKk1"
        go()
    }
    
    
    
    
    ////直接登入用
    func go(){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "tabbarvc")
        show(vc!, sender: self)
    }
   


    //大家可以回家的segue
    @IBAction func home(_sender:UIStoryboardSegue){
        
        print("back home")
    }
    
    
    
    @IBAction func Gotomyile(_ sender: Any) {
        //let vc = storyboard?.instantiateViewController(withIdentifier: "MainView")
       // show(vc!, sender: self)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyfileViewController1")
        show(vc!, sender: self)
    }
    
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var registerView: UIView!
    
    @IBAction func segmentValue(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.loginView.isHidden = false
            self.registerView.isHidden = true
        case 1:
            self.registerView.isHidden = false
            self.loginView.isHidden = true
        default:
            break
        }
    }
    
   
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
           return passwordTest.evaluate(with: password)
    }
    
   
    //隱藏鍵盤手勢(點擊其他地方)
    func hideKeyborad(tapG: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        ////加入 點擊外面整個view回到原來位置
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = 0
        })
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate

        self.loginView.isHidden = false
        self.registerView.isHidden = true
        
        
        //isLogin = true
        //addMemberOrLogin()
        // Do any additional setup after loading the view, typically from a nib.
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(hideKeyborad(tapG:)))
        
        
        tapBack.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapBack)
    }

    
    //MyfileViewController1
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

