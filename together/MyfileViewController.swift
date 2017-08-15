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
    @IBOutlet weak var takepictureBtn: UIButton!
    //@IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var groupname: UILabel!
    @IBOutlet weak var mygroupControl: UIPageControl!
    @IBOutlet weak var Mygroupimage: UIImageView!
    @IBOutlet weak var testlabel: UITextView!
    @IBOutlet var SwipeRight: UISwipeGestureRecognizer!
    @IBOutlet var SwipeLeft: UISwipeGestureRecognizer!
    @IBOutlet var Tap: UITapGestureRecognizer!
    
    
    @IBAction func logout(_ sender: Any) {
        app.account = nil
        app.mid = nil
        app.tid = nil
        app.id = nil
        app.myAllGroupSelectedTid = nil
        app.whojoinGroupSelectApplyUserMid = nil
        app.whojoinGroupSelectMaid = nil
        
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainView")
        present(vc!, animated: true, completion: nil)

    }
    
    
    
    @IBAction func SaveinfoBtn(_ sender: Any) {
        
        let nickname = nameText.text!
        let description = testlabel.text!
        let mid = app.mid!
        //print("note\(mid)")
        let url = URL(string: "https://together-seventsai.c9users.io/personalfileSavePic.php")
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: url!)
        personalpic = imgDataBase64String
        //如果personalpic != nil 傳data參數至後端
        if personalpic != nil {
            req.httpBody = "mid=\(mid)&data=\(personalpic!)&nickname=\(nickname)&description=\(description)".data(using: .utf8)
            print("has photo")
        }else {
            ////如果沒有選照片 personalpic = nil 則傳送data空字串參數至後端
            req.httpBody = "mid=\(mid)&nickname=\(nickname)&description=\(description)".data(using: .utf8)
            print("no photo")
        }
        //        req.httpBody = "account=\(app.account!)&data=\(personalpic!)".data(using:.utf8)
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
        alertSaved()
    }
    
    
    @IBAction func takepicBTN(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "使用相機", style: .default, handler: {(action) in
            openCamera()
        })
        let libraryAction = UIAlertAction(title: "使用相簿", style: .default, handler: {(action) in
            openLibrary()
            
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: {(action) in
            //           self.dismiss(animated: true, completion: nil)
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
        
        
    }
    //圖片使用照相機拍攝後的圖片或者本機端圖片
    @IBAction func takepic(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "使用相機", style: .default, handler: {(action) in
            openCamera()
        })
        let libraryAction = UIAlertAction(title: "使用相簿", style: .default, handler: {(action) in
            openLibrary()
            
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: {(action) in
            //           self.dismiss(animated: true, completion: nil)
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
        
    }
    
    
    //tap 手勢功能
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        
        if self.subject.count == 0{
            print("do not move")
        }else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail")
            show(vc!, sender: self)
            
        }
    }
    
    //swipe手勢功能
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
        if self.subject.count == 0 {
            print("cannot swipe")
        }else {
            Mygroupimage.image = images[mygroupControl.currentPage]
            //            groupname.text = self.subject[mygroupControl.currentPage]
            groupname.text = self.temptid[mygroupControl.currentPage]
            app.tid = temptid[mygroupControl.currentPage]
            print(app.tid)
            
        }
    }
    
    
    //讀取相片後將資料放入uiimage中
    //轉乘database64 配合放入mysql儲存
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //print("99999")
        let imgTaken = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        takepictureBtn.setImage(imgTaken, for: .normal)
        
        let imgData = UIImageJPEGRepresentation(imgTaken, 0.3)
        
        let imgDataBase64 = imgData?.base64EncodedData()
        
        imgDataBase64String = imgData?.base64EncodedString()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_picker: UIImagePickerController){
        //        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    //讀取個人資料
    
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
    
    
    //讀取開團資料
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
                
                //                DispatchQueue.main.async {
                do{
                    
                    
                    let jsonobj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    var counter = 0
                    for a in  jsonobj as! [[String:String]] {
                        //                            if counter >= 5 {
                        //                                break
                        //                            }
                        self.subjectpic.append(a["subjectpic"]!)
                        self.subject.append(a["subject"]!)
                        self.temptid.append(a["tid"]!)
                        //                            print("我是揪團ＩＤ：\(self.temptid)")
                        //                            counter += 1
                        
                    }
                    sleep(1)
                    
                    print("我是選擇的揪團：\(self.temptid)")
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
                //                }
                
            })
            
            task.resume()
            
        }else {
            
            print("no account")
            
        }
    }
    
    
    //將陣列中的字串轉成圖片資料
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
        
        
        DispatchQueue.main.async {
            //print(subjectpic)
            //print(images)
            self.Mygroupimage.image = self.images[0]
            ////先以揪團ＴＩＤ顯示
            //        groupname.text =  self.subject[0]
            self.groupname.text =  self.temptid[0]
            
            self.app.tid = self.temptid[0]
            self.mygroupControl.numberOfPages = self.images.count
            
        }
        
        
    }
    
    func alertSaved() {
        let alertController = UIAlertController(title: "資料上傳", message: "資料已儲存", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確認", style: .default, handler: {(action) in
            //self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyborad(tapG: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        ////加入 點擊外面整個view回到原來位置
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = 0
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDB()
        //loadmygroup()
        let layer = takepictureBtn.layer
        layer.cornerRadius = takepictureBtn.frame.width / 2
        layer.masksToBounds = true
        
//        let groupViewLayer = Mygroupimage.layer
//        groupViewLayer.cornerRadius = 20.0
//        groupViewLayer.masksToBounds = true
        //手勢衝突時，判斷
//        Tap.require(toFail: SwipeRight)
//        Tap.require(toFail: SwipeLeft)
        print(self.subject)
        print(app.mid)
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(hideKeyborad(tapG:)))
        
        
        tapBack.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapBack)
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


//    @IBAction func editBtn(_ sender: Any) {
//
//        let nickname = nameText.text!
//        let description = testlabel.text!
//
//        let q = DispatchQueue.global()
//        q.sync {
//            do {
//
//                let url = URL(string: "https://together-seventsai.c9users.io/resumeEdit.php")
//                let session = URLSession(configuration: .default)
//                var request = URLRequest(url:url!)
//                request.httpBody = "account=\(self.app.account!)&nickname=\(nickname)&description=\(description)".data(using: .utf8)
//                request.httpMethod = "POST"
//
//                let task = session.dataTask(with: request, completionHandler: {(data, response , error) in
//
//                    if  error != nil {
//                        print("gg")
//                    }else{
//                        print("success")
//
//                    }
//
//                })
//
//                task.resume()
//
//            }catch{
//                print(error)
//            }
//
//        }
//        q.async {
//            sleep(1)
//            self.loadDB()
//        }
//
//    }

//    @IBOutlet weak var loadDetail: UIButton!

//    @IBAction func uploadsubmit(_ sender: Any) {
//
//        personalpic = imgDataBase64String
//        let url = URL(string: "https://together-seventsai.c9users.io/personalfileSavePic.php")
//        let session = URLSession(configuration: .default)
//        var req = URLRequest(url: url!)
//        req.httpBody = "account=\(app.account!)&data=\(personalpic!)".data(using:.utf8)
//        req.httpMethod = "POST"
//        let task = session.dataTask(with: req, completionHandler: {(data,response,error) in
//            if error == nil {
//                print("add success")
//                print(data)
//            }else{
//                print(error)
//            }
//        })
//        task.resume()
//    }

//    @IBAction func loaddetail(_ sender: Any) {
//
//        if self.subject.count == 0{
//            print("do not move")
//        }else {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "Gpdetail")
//            show(vc!, sender: self)
//
//        }
//
//    }


//    func imagePickerController(_picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
//        //print("")
//        let imgTaken = info[UIImagePickerControllerOriginalImage] as! UIImage
//        //imageView.image = imgTaken
//        takepictureBtn.setImage(imgTaken, for: .normal)
//
//        let imgData = UIImageJPEGRepresentation(imgTaken, 0.3)
//
//        let imgDataBase64 = imgData?.base64EncodedData()
//
//        imgDataBase64String = imgData?.base64EncodedString()
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_picker: UIImagePickerController){
//        dismiss(animated: true, completion: nil)
//    }

