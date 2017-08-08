//
//  MyfileViewController.swift
//  together
//
//  Created by iii-user on 2017/7/19.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class MyfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {

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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var groupname: UILabel!
    @IBOutlet weak var mygroupControl: UIPageControl!
    @IBOutlet weak var Mygroupimage: UIImageView!
    @IBOutlet weak var testlabel: UITextView!
    @IBAction func editBtn(_ sender: Any) {
        
        let nickname = nameText.text!
        let description = testlabel.text!
        
        let q = DispatchQueue.global()
        q.sync {
            do {
                
                let url = URL(string: "https://together-seventsai.c9users.io/resumeEdit.php")
                let session = URLSession(configuration: .default)
                var request = URLRequest(url:url!)
                request.httpBody = "account=\(self.app.account!)&nickname=\(nickname)&description=\(description)".data(using: .utf8)
                request.httpMethod = "POST"
                
                let task = session.dataTask(with: request, completionHandler: {(data, response , error) in
                    
                    
                    
                    
                    if  error != nil {
                        print("gg")
                    }else{
                        print("success")
                        
                    }
                    
                    
                })
                
                
                task.resume()
                
                
            }catch{
                print(error)
            }

        }
        q.async {
            sleep(1)
            self.loadDB()
        }
        
    }

    @IBOutlet weak var loadDetail: UIButton!
    @IBAction func loaddetail(_ sender: Any) {
        
        if self.subject.count == 0{
            print("do not move")
        }else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail")
            show(vc!, sender: self)
            
        }
        
        
        
    }
    
    @IBAction func uploadsubmit(_ sender: Any) {
        
        personalpic = imgDataBase64String
        let url = URL(string: "https://together-seventsai.c9users.io/personalfileSavePic.php")
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: url!)
        req.httpBody = "account=\(app.account!)&data=\(personalpic!)".data(using:.utf8)
        req.httpMethod = "POST"
        let task = session.dataTask(with: req, completionHandler: {(data,response,error) in
            if error == nil {
                print("add success")
                print(data)
            }else{
                print(error)
            }
        })
        task.resume()
    }
    
    
    @IBAction func takepic(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "use camera", style: .default, handler: {(action) in
            openCamera()
        })
        let libraryAction = UIAlertAction(title: "use library", style: .default, handler: {(action) in
            openLibrary()
        
        
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: {(action) in
           self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController{
            popoverController.sourceView = view as? UIView
            popoverController.sourceRect = CGRect(x : self.view.bounds.midX, y : self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alertController, animated: true, completion: nil)
        
        func openCamera(){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let imgPickerTakeVC = UIImagePickerController()
                imgPickerTakeVC.sourceType = .camera
                imgPickerTakeVC.delegate = self
                
                show(imgPickerTakeVC, sender: self)
            }
        }
        
        func openLibrary(){
            let imgPickGetVC = UIImagePickerController()
            imgPickGetVC.sourceType = .photoLibrary
            imgPickGetVC.delegate = self
            
            if let popoverController = alertController.popoverPresentationController{
                popoverController.sourceView = view as? UIView
                popoverController.sourceRect = CGRect(x : self.view.bounds.midX, y : self.view.bounds.midY, width : 0 ,height : 0)
            }
            present(imgPickGetVC, animated: true, completion: nil)
        }
        
        func imagePickerController(_picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
            print("")
            let imgTaken = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = imgTaken
            
            let imgData = UIImageJPEGRepresentation(imgTaken, 0.3)
            
            let imgDataBase64 = imgData?.base64EncodedData()
            
            imgDataBase64String = imgData?.base64EncodedString()
            
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_picker: UIImagePickerController){
            dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
        
    }
    
   
     @IBAction func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.left:
            //left swipe
            if mygroupControl.currentPage < images.count {
                mygroupControl.currentPage += 1
            }
        case UISwipeGestureRecognizerDirection.right:
            //right swipe
            if mygroupControl.currentPage > 0 {
                mygroupControl.currentPage -= 1
            }
        default:
            return
        }
        if self.subject.count == 0{
            print("cannot swipe")
        }else {
            Mygroupimage.image = images[mygroupControl.currentPage]
            groupname.text = self.subject[mygroupControl.currentPage]
            app.tid = temptid[mygroupControl.currentPage]
            print(app.tid)
            
        }
    }
    
    func loadDB(){
        Myfilemid = app.mid
        
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
                            
                            self.nameText.text = nickname
                            self.testlabel.text = description
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
    
    func loadmygroup(){
        
        Myfilemid = app.mid
        if let mid = Myfilemid {
            
            //c9資料庫 post
            let url = URL(string: "https://together-seventsai.c9users.io/myprofiletogether.php")
            let session = URLSession(configuration: .default)
            
            
            var req = URLRequest(url: url!)
            
            req.httpMethod = "POST"
            req.httpBody = "mid=\(mid)".data(using: .utf8)
            
            let task = session.dataTask(with: req, completionHandler: {(data, response,error) in
                let source = String(data: data!, encoding: .utf8)
                
                //                print(source!)
                
                //DispatchQueue.main.async {
                    do{
                        
                        
                        let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        var counter = 0
                        for a in  jsonobj as! [[String:String]] {
                            if counter >= 5 {
                                break
                            }
                            self.subjectpic.append(a["subjectpic"]!)
                            self.subject.append(a["subject"]!)
                            self.temptid.append(a["tid"]!)
                            print(self.subjectpic)
                            counter += 1
                            
                        }
                        sleep(1)
                        
                        print("我是紗布傑克\(self.subject)")
                        if self.subject.count == 0{

                            print("nothing here1")
                        }else {
                            DispatchQueue.main.async {
                              self.putimage()
                            }
                        }
                        
                    }catch {
                        print("thisis \(error)")
                    }
               // }
                
            })
            
            task.resume()
            
        }else {
            
            print("no account")
            
        }
    }
    
    func putimage() {

                for i in 0..<self.subjectpic.count {
                    
                    var temp = self.subjectpic[i] as? String ?? ""
                    //print(type(of:temp))
                    print(temp)
//                    if temp != "" {
                     do{
                        let url = URL(string:"\(temp)")
                        
                      //  print("222\(url)")
                        
                        if url != nil {
                            let data = try Data(contentsOf: url!)
                            if (UIImage(data: data) != nil) {
                                print("OK")
                                images.append(UIImage(data: data)!)
                            }else {
                                images.append(UIImage(named: "question.jpg")!)
                                print("xx")
                            }
                            
                       }
                            else {
                        print("ok")
                        images.append(UIImage(named: "question.jpg")!)
                       }
                     }catch{
                        print(error)
                        images.append(UIImage(named: "question.jpg")!)
                        }
//        }else {
//                        images.append(UIImage(named: "question.jpg")!)
//                    }
      
            }
        
        
        
        //print(subjectpic)
        //print(images)
        Mygroupimage.image = images[0]
        groupname.text =  self.subject[0]
        app.tid = temptid[0]
        mygroupControl.numberOfPages = images.count
        
        
    }
    
    //let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail")
    //show(vc!, sender: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDB()
        loadmygroup()
        //putimage()
        //self.loadDetail.isEnabled = false
        let layer = imageView.layer
        layer.cornerRadius = 20.0
        layer.masksToBounds = true
        
        let groupViewLayer = Mygroupimage.layer
        groupViewLayer.cornerRadius = 20.0
        groupViewLayer.masksToBounds = true
        
        print(self.subject)
        print(app.mid)
        
        // Do any additional setup after loading the view.
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
