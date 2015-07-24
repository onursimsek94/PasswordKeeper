//
//  ViewController.swift
//  Password Keeper
//
//  Created by Onur ŞİMŞEK on 29/06/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(DeviceHelper().getDeviceModel())
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "PasswordKeeperLoginPassword")
        request.returnsObjectsAsFaults = false
        var result:NSArray = context.executeFetchRequest(request, error: nil)!
        
        var LoginAlert = UIAlertController(title: "Login", message: "Please enter your password", preferredStyle: UIAlertControllerStyle.Alert)
        LoginAlert.addTextFieldWithConfigurationHandler{
            (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }
        
        LoginAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in
            
            let passwordTextField = LoginAlert.textFields![0] as! UITextField
            
            if passwordTextField.text == ""{
                
                LoginAlert.title = "Warning"
                LoginAlert.message = "The password field blank impassable, please enter your password"
                self.presentViewController(LoginAlert, animated: true, completion: nil)
                
            } else if result[0].password == passwordTextField.text{
                
                let tabBarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarViewController") as! TabBarViewController
                self.presentViewController(tabBarViewController, animated: true, completion: nil)
                
            } else{
                
                LoginAlert.title = "Incorrect Password"
                LoginAlert.message = "You did the wrong password entry, please try again"
                self.presentViewController(LoginAlert, animated: true, completion: nil)
                
            }
        }))

//        LoginAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        if result.count > 0{
            
            self.presentViewController(LoginAlert, animated: true, completion: nil)
        
        } else {
            
            var SignUpAlert = UIAlertController(title: "Create Password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            SignUpAlert.addTextFieldWithConfigurationHandler{ (textField) in
                textField.placeholder = "Password"
                textField.secureTextEntry = true
            }
            
            SignUpAlert.addTextFieldWithConfigurationHandler{ (textField) in
                textField.placeholder = "Password Confirmation"
                textField.secureTextEntry = true
            }
            
            SignUpAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                (action) -> Void in
                
                let password = SignUpAlert.textFields![0] as! UITextField
                let confirmPassword = SignUpAlert.textFields![1] as! UITextField
                
                if password.text == "" || confirmPassword.text == ""{
                    
                    SignUpAlert.title = "Warning"
                    SignUpAlert.message = "The password field blank impassable"
                    self.presentViewController(SignUpAlert, animated: true, completion: nil)
                    
                } else if password.text == confirmPassword.text{
                    
                    var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                    var context:NSManagedObjectContext = appDel.managedObjectContext!
                    var newPassword = NSEntityDescription.insertNewObjectForEntityForName("PasswordKeeperLoginPassword", inManagedObjectContext: context) as! NSManagedObject
                    newPassword.setValue(password.text, forKey: "password")
                    context.save(nil)
                    
                    result = context.executeFetchRequest(request, error: nil)!
                    
                    self.presentViewController(LoginAlert, animated: true, completion: nil)
                    
                } else{
                    
                    SignUpAlert.title = "Warning"
                    SignUpAlert.message = "Confirm password is incorrect"
                    self.presentViewController(SignUpAlert, animated: true, completion: nil)
                    
                }
            }))

//            SignUpAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            
            self.presentViewController(SignUpAlert, animated: true, completion: nil)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



