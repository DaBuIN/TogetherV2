//
//  AppDelegate.swift
//  together
//
//  Created by Seven Tsai on 2017/7/17.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    //帳號
    var account:String?
    
 //   var passwd:String?
    //memberID 使用者id
    var mid:String?
    var id:String?
    //togetherID 團名id
    var tid:String?
    //////查詢我的揪團 所選到的tid使用
    var myAllGroupSelectedTid:String?
    
    ///////選到的申請者mid
     var whojoinGroupSelectApplyUserMid:String?
    
    var whojoinGroupSelectMaid:String?
    
    
    
    
    /////////傳到detail頁面前。先知道這個開團者是誰
    var openGroupMid:String?
    
    
    ////////我申請的揪團用。 傳到detail頁面先知道
    var applyToDetailMastatus:String?

    
    
    
//    var mastername:String?
//    var sentToDetailId:String?
  //  var subjectpic:Array<Any> = []
  //  var subject:Array<String> = []
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

