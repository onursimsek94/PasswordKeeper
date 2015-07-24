//
//  SettingsViewController.swift
//  Password Keeper
//
//  Created by Onur ŞİMŞEK on 29/06/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var viewChanged: Bool = false

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBAction func saveButton(sender: UIButton) {
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "PasswordKeeperLoginPassword")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "password = %@", oldPasswordTextField.text)
        var result = context.executeFetchRequest(request, error: nil)!
        
        if oldPasswordTextField.text == "" || newPasswordTextField.text == "" || confirmPasswordTextField.text == ""{
            
            var emptyPasswordAlert = UIAlertController(title: "Warning", message: "The password field blank impassable", preferredStyle: UIAlertControllerStyle.Alert)
            emptyPasswordAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(emptyPasswordAlert, animated: true, completion: nil)
 
        } else if result.count == 0{
            
            var alert = UIAlertController(title: "Warning", message: "You did the wrong old password entry, please try again", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if newPasswordTextField.text != confirmPasswordTextField.text{
            
            var confirmPasswordIncorrectAlert = UIAlertController(title: "Warning", message: "Confirm password is incorrect", preferredStyle: UIAlertControllerStyle.Alert)
            confirmPasswordIncorrectAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(confirmPasswordIncorrectAlert, animated: true, completion: nil)
            
        } else{
            
            result[0].setValue(newPasswordTextField.text, forKey: "password")
            context.save(nil)
            
            var successAlert = UIAlertController(title: "Successful", message: "Password was successfully changed", preferredStyle: UIAlertControllerStyle.Alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(successAlert, animated: true, completion: {
                (action) -> Void in
                
                self.oldPasswordTextField.text = ""
                self.newPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
                
            })
        }
    }
    
    @IBAction func deleteAllAccountsButton(sender: UIButton) {
        
        var confirmationAlert = UIAlertController(title: "Warning", message: "All accounts will be deleted. Do you want to continue?", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: {
            (action) -> Void in
            
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "PasswordKeeperAccounts")
            var result = context.executeFetchRequest(request, error: nil)!
            
            for item in result {
                context.deleteObject(item as! NSManagedObject)
            }
            context.save(nil)
            
            var infoAlert = UIAlertController(title: "Successful", message: "All accounts have been deleted", preferredStyle: UIAlertControllerStyle.Alert)
            infoAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                (action) -> Void in
                
                var tabBarViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarViewController") as! TabBarViewController
                self.presentViewController(tabBarViewController, animated: true, completion: nil)
                
            }))
            self.presentViewController(infoAlert, animated: true, completion: nil)
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        self.presentViewController(confirmationAlert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println("SettingsViewController")
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        if viewChanged == true {
            
            textFieldEndEditViewAnimation()
            
        }
        
        return true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textFieldBeginEditViewAnimation()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if viewChanged == true {
            
            textFieldEndEditViewAnimation()
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        if viewChanged == true {
            
            textFieldEndEditViewAnimation()
            
        }
        
        self.view.endEditing(true)
        
    }
    
    func textFieldBeginEditViewAnimation() {
        
        switch DeviceHelper().getDeviceModel() {
        case "iPhone 4s":
            if confirmPasswordTextField.isFirstResponder() {
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.view.frame.origin.y += -160
                })
                viewChanged = true
                
            }
        default: break
        }
        
    }
    
    func textFieldEndEditViewAnimation() {
        
        viewChanged = false
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.frame.origin.y += 160
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
