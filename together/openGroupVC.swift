//
//  openGroupVC.swift
//  together
//
//  Created by Seven Tsai on 2017/7/17.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

///////////**********開揪團頁面

import UIKit
import MapKit

//因委託給自己所以要加  UIPickerViewDelegate, UIPickerViewDataSource
class openGroupVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate , UITextFieldDelegate  {

//    @IBOutlet weak var imgViewSbj: UIImageView!
    @IBOutlet weak var btnPicOutlet: UIButton!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var textFieldSubject: UITextField!
//    @IBOutlet weak var classLabel: UILabel!

    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var textViewDetail: UITextView!
    
   
    
    var listClass = ["美食","運動","旅遊","團康","其他"]   //////揪團類別
    
    var selectClass:String?  //class select的資料儲存
    
    var formatter: DateFormatter! = nil
    var formatter2: DateFormatter! = nil
    var formatterForShow: DateFormatter! = nil
//    var formatter2: DateFormatter! = nil

    var subject:String?
    var location:String?
    var starttime:String?
    var starttimeForShow:String?
    var endtime:String?
    var endtimeForShow:String?
    var classType:String?
    var detail:String?
    var subjectpicString:String?
//    var lat:String?
//    var lng:String?
    //會員id
    var mid:String?
    //    var imgTaken:UIImage?
    var imgDataBase64String:String?
    
    
    var locationAddr:String?
    var locationLat:CLLocationDegrees?
    var locationLng:CLLocationDegrees?
    
    let dataEmpty:String = ""
    
    /////for 點鍵盤 畫面上移用
    private var currentTextField: UITextField?
    private var isKeyboardShown = false
    
    
    // 選取地點
    @IBAction func pickMapPlace(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "opengroupmapvc") as! openGroupMapPickVC
        show(vc, sender: self)
    }
    
    @IBAction func pickPlaceDone(_ sender: UIStoryboardSegue) {
        let segId:String = sender.identifier!
        print(segId)
        if segId == "segPickPlaceDone" {
            print("取得地點座標及地址")
            print("經度: \(locationLat!), 緯度: \(locationLng!)")
        }
    }
    
    @IBAction func cancelGroup(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarvc")
        self.present(vc!, animated: true, completion: nil)

    }
    
    /////////////開團按鈕
    @IBAction func openGroup(_ sender: Any) {
        
        let alertController = UIAlertController(title: "您開團嗎?", message: "送出後即開團成功", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "送出", style: .default, handler: {(action) in

            
            print(self.starttime!)
            print(self.endtime!)
            
            if self.starttime! > self.endtime! {
                print("大於")
//
                
                self.alert(title: "開團失敗", message: "結束日期不能小於開團日期", actionTitle: "返回")
                
            }else if self.starttime! < self.endtime!{
                print("小魚")
                self.sentGroupData()
                self.presentToManagevc()
                
            }else if self.starttime! == self.endtime!{
                print("等於")
                self.sentGroupData()
                self.presentToManagevc()

            }

            
            

        })
        let cancelaction = UIAlertAction(title: "取消", style: .default, handler: {(action) in
//            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okaction)
        alertController.addAction(cancelaction)

        self.present(alertController, animated: true, completion: nil)
        
    

    }
  
    ////////開團錯誤的alert
    func alert(title:String,message:String,actionTitle:String){
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "\(actionTitle)", style: .default, handler: {(action) in
            
        })
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    //////present to managevc。 API
    func presentToManagevc() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarvc")
        self.present(vc!, animated: true, completion: nil)
//        self.tabBarController?.selectedIndex = 2
//        tabBarController?.delegate = self as! UITabBarControllerDelegate
        
    
    }
    
    //////開團 傳資料到後端 API
    func sentGroupData(){
        subject = textFieldSubject.text
        location = "地點"
        detail = textViewDetail.text
        if detail == nil {
            detail = "空無一物"
        }else if detail == ""{
            detail = "空無一物"
        }else {
            detail = textViewDetail.text
        }
        
//        print(subject!)
//        print(location!)
//        print(starttime!)
//        print(endtime!)
//        print(classType!)
//        print(detail!)
        //        print(subjectpicString!)
        
        let url = URL(string: "https://together-seventsai.c9users.io/openGroup.php")
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: url!)
        
        ////STRING == 拍照或擷取相簿的base64String 用來傳給後端
        subjectpicString = imgDataBase64String
        
        //如果subjectpicString != nil 傳data參數至後端
        if subjectpicString != nil {
            req.httpBody = "mid=\(mid!)&subject=\(subject!)&location=\(location!)&lat=\(locationLat!)&lng=\(locationLng!)&starttime=\(starttime!)&endtime=\(endtime!)&class=\(classType!)&detail=\(detail!)&data=\(subjectpicString!)".data(using: .utf8)
            
            
            print("has photo")
        }else {
            ////如果沒有選照片 subjectpicString = nil 則傳送data空字串參數至後端
            req.httpBody = "mid=\(mid!)&subject=\(subject!)&location=\(location!)&lat=\(locationLat!)&lng=\(locationLng!)&starttime=\(starttime!)&endtime=\(endtime!)&class=\(classType!)&detail=\(detail!)".data(using: .utf8)
            print("no photo")
        }
        
 
        
        req.httpMethod = "POST"
        

        let task = session.dataTask(with: req, completionHandler: {(data,response,error) in
            if error == nil {
                
                print("add success")
                let source = String(data: data!, encoding: .utf8)
                print(source!)
                
            }else{ print(error)}
            
            
        })
                task.resume()
    
    }
    

    
    ////拍照按鈕

    @IBAction func btnTakePic(_ sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "使用相機", style: .default, handler: {(action) in
            openCamera()
        })
        let libraryAction = UIAlertAction(title: "使用相簿", style: .default, handler: {(action) in
            openLibrary()
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: {(action) in
            //self.dismiss(animated: true, completion: nil)
        })
        
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view as? UIView
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            
        }
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        //相機拍照function
        
        func openCamera(){
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imgPickerTakeVC = UIImagePickerController()
                imgPickerTakeVC.sourceType = .camera
                imgPickerTakeVC.delegate = self
                
                show(imgPickerTakeVC, sender: self)
                
            }
        }
        
        //取library function
        func openLibrary(){
            let imgPickGetVC = UIImagePickerController()
            imgPickGetVC.sourceType = .photoLibrary
            imgPickGetVC.delegate = self
            
            //規定要跳出(ipad需要)
            
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = view as? UIView
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                
            }
            present(imgPickGetVC, animated: true, completion: nil)
            
            
            //        imgPickGetVC.modalPresentationStyle = .popover
            //        let popover = imgPickGetVC.popoverPresentationController
            //        popover?.sourceView = self.view as? UIView
            //
            //        popover?.sourceRect = self.view.bounds
            //        popover?.permittedArrowDirections = .any
            //
            //        show(imgPickGetVC, sender: self)
            
            
        }
        
        
    }
    
    //拍照finish 實作
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("mid:\(mid!)")
        
        let imgTaken = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
//        imgViewSbj.image = imgTaken
        
        btnPicOutlet.setImage(imgTaken, for: .normal)
        
        //將UIImage 變為 jpeg   即為data
        let imgData = UIImageJPEGRepresentation(imgTaken, 0.3)
        
        
        
        
        
        let imgDataBase64 =  imgData?.base64EncodedData()
        //將imgData 轉為base64字串
        imgDataBase64String = imgData?.base64EncodedString()
        
        
        
        //                    print("aaaaaaa\(imgDataBase64)")
        
        //        print("bbbbbbbbbb\(imgDataBase64String!)")
        
        
        
        //            print(imgDataBase64String)
        
        //        let url = URL(string: "https://together-seventsai.c9users.io/savePhoto.php")
        //        //
        //        let session = URLSession(configuration: .default)
        //        var req = URLRequest(url: url!)
        //        // 將base64字串以字串形式傳到後端
        //        req.httpBody = "mid=\(mid!)&data=\(imgDataBase64String!)".data(using: .utf8)
        //        req.httpMethod = "POST"
        //
        //        let task = session.dataTask(with: req, completionHandler: {(data,response,error) in
        //            if error != nil{
        //                print(data)
        //                print(response)
        //            }
        //
        //        })
        //
        //
        //
        //
        //        task.resume()
        
        
        
        
        //順便存為相簿圖檔
        //       let imgInLib = UIImageWriteToSavedPhotosAlbum(imgTaken, nil, nil, nil)
        
        
        
        //將相片儲存到雲端
        
        //https://together-seventsai.c9users.io/photo/groupimg/
        
        //時間
        //        let interval = Date.timeIntervalSinceReferenceDate
        //                let docDir = NSHomeDirectory() + "/Documents"
        
        //        let imgRelativePath = "/saveimg/\(app.account!)_\(interval).jpg"
        
        //圖片的命名(其路徑含名稱)
        //        let imgFile = "\(docDir)\(imgRelativePath)"
        //        print("imgFile:\(imgFile)")
        //pathString to url
        //        let urlFilePath = URL(fileURLWithPath: imgFile)
        
        //        var account = "account1"
        //        var groupid = "gid1"
        //
        //        let c9Path = "https://together-seventsai.c9users.io/photo/groupimg/"
        //        let imgFilePath = "\(c9Path)\(account)_\(groupid)_\(interval).jpg"
        //
        //        let urlImgFilePath = URL(fileURLWithPath: imgFilePath)
        //        print(urlImgFilePath)
        //
        //        do {
        //            //將data 存下來
        //
        //
        //            try data?.write(to: urlImgFilePath)
        //
        //            print("save ok")
        //        }catch {
        //            print(error)
        //        }
        
        
        dismiss(animated: true, completion: nil)
        

        
    }
    
    //拍照cancel 實作
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // class Picker API。建構一個classPicker
    func setClassPicker(array:Array<String>){
        
        ////////////class PickerView 用
        //實作一個pickerView 出來
        let myPickerView = UIPickerView()
        
        
        //委託給自己
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        //將textField(用拉的) 鍵盤改為pickView
        classTextField.inputView = myPickerView
        
        
        let array = array
        
        //預設text為
        classTextField.text = array[0]
        
        
        //讓classType(傳值用)
        classType = classTextField.text
        
        
        classTextField.tag = 100
    }
    
    
    //////////Class Picker 實作
    //幾個滾筒
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //多少筆資料
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        if component == 0 {
        return listClass.count
        //        }
    }
    
    //資料內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        if component == 0 {
        
        return listClass[row]
    }
    //    }
    
    //使用者選擇的資料
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            
            
            
            
            let field  = self.view.viewWithTag(100) as? UITextField
            
            field?.text = listClass[row]
            
            //        print("selectClass:\(listClass[row])")
            
            classType = field?.text
            
            
            print("select:\(classType!)")
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //////////DatePicker API  建構一個datePicker 取代鍵盤
    func setStartDatePicker(textField:UITextField){
        formatter = DateFormatter()   //date picker 初始化 日期格式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterForShow = DateFormatter()
        formatterForShow.dateFormat = "yyyy日MM月dd日 HH時mm分"
        
        
        
        var textField = textField
        
        //實作一個date picker
        let myDatePicker = UIDatePicker()
        
        //模式
        myDatePicker.datePickerMode = .dateAndTime
        
        //時區
        myDatePicker.locale = Locale(identifier: "zh_TW")
        
        //預設日期
        
        
        myDatePicker.date = Date()
        
        myDatePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
        
        //鍵盤置換
        textField.inputView = myDatePicker
        
        //預設內容
       formatter.string(from: myDatePicker.date)
        textField.text = formatterForShow.string(from: myDatePicker.date)
        textField.tag = 200
        
        
        
        //讓變數starttime 取得改變後的值 以利後續傳值至後端  (格式化得值)
        starttime = formatter.string(from: myDatePicker.date)
        
    }
    
    
    ////////////datePicker的實作
    
    
    //startDatePicker 實作
    func datePickerChanged(datePicker:UIDatePicker) {
        // 依據元件的 tag 取得 UITextField
        
        //指定tag
        let textField = self.view.viewWithTag(200) as? UITextField
        //        let textField2 = self.view.viewWithTag(300) as? UITextField
        
        //改變日期時 文字也改變
//        textField?.text = formatter.string(for: datePicker.date)
        textField?.text = formatterForShow.string(for: datePicker.date)

        //        textField2?.text = formatter2.string(from: datePicker.date)
        //        starttime = textField?.text
        
        //讓變數starttime 取得改變後的值 以利後續傳值至後端
        starttime = formatter.string(for: datePicker.date)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // endDatePicker 的 API  建構一個mydatePicker2
    func setEndDatePicker(textField:UITextField){
        formatter2 = DateFormatter()   //date picker 初始化 日期格式
        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterForShow = DateFormatter()
        formatterForShow.dateFormat = "yyyy日MM月dd日 HH時mm分"
        
        
        var textField2 = textField
        
        //實作一個date picker
        let myDatePicker2 = UIDatePicker()
        
        //模式
        myDatePicker2.datePickerMode = .dateAndTime
        
        //時區
        myDatePicker2.locale = Locale(identifier: "zh_TW")
        
        //預設日期
        
        
        myDatePicker2.date = Date()
        
        myDatePicker2.addTarget(self, action: #selector(datePickerChanged2(datePicker:)), for: .valueChanged)
        
        //鍵盤置換
        textField2.inputView = myDatePicker2
        
        //預設內容
        textField2.text = formatterForShow.string(from: myDatePicker2.date)
        
        textField2.tag = 300
        
        
        //讓變數endtime 取得改變後的值 以利後續傳值至後端
        endtime = formatter2.string(from: myDatePicker2.date)
    }
    
    
    //endDatePicker 實作
    func datePickerChanged2(datePicker:UIDatePicker) {
        // 依據元件的 tag 取得 UITextField
        
        //指定tag
        //        let textField = self.view.viewWithTag(200) as? UITextField
        let textField2 = self.view.viewWithTag(300) as? UITextField
        
        //改變日期時 文字也改變
        //        textField?.text = formatter.string(for: datePicker.date)
        textField2?.text = formatterForShow.string(from: datePicker.date)
        //        starttime = textField?.text
        
        //讓變數endtime 取得改變後的值 以利後續傳值至後端
        
        endtime = formatter2.string(from: datePicker.date)
    }
    
    
    
    
    
    
    
    
    //隱藏鍵盤手勢(點擊其他地方)
    func hideKeyborad(tapG: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        ////加入 點擊外面整個view回到原來位置
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = 0
        })

    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        //結束編輯 把鍵盤隱藏 view放下
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = 0
        })
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textView:UITextField) {
        //view彈起
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = -210
        })
    }
    
    
    /////////鍵盤出現 畫面上移
    // 開始編輯時 view上移
     func textViewDidBeginEditing(_ textView: UITextView) {
        //view 往上移
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = -210
        })
    }
    // 結束編輯時 view下移
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        currentTextField = textField
//    }
//    
//    func keyboardWillShow(note: NSNotification) {
//        if isKeyboardShown {
//            return
//        }
//        if (currentTextField != textFieldSubject) {
//            return
//        }
//        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
//        let duration = TimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
//        let keyboardFrameValue = keyboardAnimationDetail[UIKeyboardFrameBeginUserInfoKey]! as! NSValue
//        let keyboardFrame = keyboardFrameValue.cgRectValue
//        
//        UIView.animate(withDuration: duration, animations: { () -> Void in
//            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -keyboardFrame.size.height)
//        })
//        isKeyboardShown = true
//    }
//    
//    func keyboardWillHide(note: NSNotification) {
//        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
//        let duration = TimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
//        UIView.animate(withDuration: duration, animations: { () -> Void in
//            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
//        })
//        isKeyboardShown = false
//    }
    
    
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //// get memberID
        let app = UIApplication.shared.delegate as! AppDelegate
        mid = app.mid
        
        if mid == nil {
            mid = "0"
        }
        
        print("我是使用者：\(mid!)")
        /////主題藍 填寫時清空
        textFieldSubject.clearsOnInsertion = true
        
        
        
        //// location temp
        locationLat  = Double(23.2)
        locationLng = Double(121.1)
        
      
        
        //取得screenSize 似乎沒用到
        let fullScreenSize = UIScreen.main.bounds.size
        
        
        
   
        
        ////////////class PickerView 用
        setClassPicker(array: listClass)
        
        //startdate picker API  參數為 要作為點選的textfield 與  要紀錄的變數 此為textFieldStartDate這個textField(storyboard拉的)
        
        
        setStartDatePicker(textField: textFieldStartDate)
        //enddate picker API
        setEndDatePicker(textField: textFieldEndDate)
        
        
        
        /////////點擊空白返回鍵盤(被我們改為picker了)
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(hideKeyborad(tapG:)))
        
        
        tapBack.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapBack)
        
//        /////for 點鍵盤 畫面上移用
//        NotificationCenter.default.addObserver(
//            self,
//            selector: "keyboardWillShow:",
//            name: NSNotification.Name.UIKeyboardWillShow,
//            object: nil)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: "keyboardWillHide:",
//            name: NSNotification.Name.UIKeyboardWillHide,
//            object: nil)
        
            }

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
