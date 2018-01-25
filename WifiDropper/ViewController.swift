//
//  ViewController.swift
//  WifiDropper
//
//  Created by Marx, Brian on 1/5/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var buttonName: UIButton!
    let userDefaults = UserDefaults.standard
    
    @IBAction func didendEdit() {
        userDefaults.set(textfield.text, forKey: "ip")
        textfield.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonName.layer.shadowOpacity = 0.7
        buttonName.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        buttonName.setTitle(getWiFiSsid(), for: .normal)
        if let ipNumber = userDefaults.string(forKey: "ip") {
            let label = view.viewWithTag(123) as? UILabel
            label?.text = ipNumber
        }
    }

    @IBAction func openSettings(_ sender: UIButton) {
        //UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        let sharedApp = UIApplication.shared
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    let auto = interfaceInfo[kCNNetworkInfoKeySSID as! String] as! NSString?
                    
                    print(auto)
                }
            }
        }
        let url = URL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        if sharedApp.canOpenURL(url!) {
            if let theText = textfield.text {
                let label = view.viewWithTag(123) as? UILabel
                if theText == "" {
                    if let ip = userDefaults.string(forKey: "ip") {
                        label?.text = ip
                    } else {
                        label?.text = "0.0.0.0"
                    }
                } else {
                    UIPasteboard.general.string = theText
                    label?.text = theText
                }
            }
            textfield.resignFirstResponder()
            sharedApp.open(url!)
        } else {
            print("There was a problem")
        }
    }

    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString)
                    as NSDictionary? {
                    
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
