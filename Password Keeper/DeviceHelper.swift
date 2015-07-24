//
//  DeviceHelper.swift
//  Password Keeper
//
//  Created by Onur ŞİMŞEK on 23/07/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit

class DeviceHelper: NSObject {
    
    func getDeviceModel() -> String{
        var deviceModel: String = ""
        
        var width = UIScreen.mainScreen().bounds.size.width
        var height = UIScreen.mainScreen().bounds.size.height
        
        if UIDevice.currentDevice().model == "iPhone" || UIDevice.currentDevice().model == "iPhone Simulator" {
        
            if width == 320.0 && height == 480.0 {
                deviceModel = "iPhone 4 - 4s"
            } else if width == 320.0 && height == 568.0 {
                deviceModel = "iPhone 5 - 5s"
            } else if width == 375.0 && height == 667.0 {
                deviceModel = "iPhone 6"
            } else if width == 414.0 && height == 736.0 {
                deviceModel = "iPhone 6 Plus"
            }
        } else {
            deviceModel = "Device is not iPhone"
        }
        
        return deviceModel
    }
   
}
