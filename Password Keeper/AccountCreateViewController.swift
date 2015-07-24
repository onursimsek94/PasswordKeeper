//
//  AccountCreateViewController.swift
//  PasswordKeeper
//
//  Created by Onur ŞİMŞEK on 28/06/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit
import CoreData

class AccountCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var viewChanged: Bool = false

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        if titleTextField.text != "" {
            
            var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            var context:NSManagedObjectContext = appDel.managedObjectContext!
            
            var newAccount = NSEntityDescription.insertNewObjectForEntityForName("PasswordKeeperAccounts", inManagedObjectContext: context) as! NSManagedObject
            newAccount.setValue(titleTextField.text, forKey: "title")
            newAccount.setValue(webSiteTextField.text, forKey: "website")
            newAccount.setValue(usernameTextField.text, forKey: "username")
            newAccount.setValue(passwordTextField.text, forKey: "password")
            newAccount.setValue(emailTextField.text, forKey: "email")
            newAccount.setValue(noteTextView.text, forKey: "note")
            
            context.save(nil)
            
            let tabBarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarViewController") as! TabBarViewController
            self.presentViewController(tabBarViewController, animated: true, completion: nil)

        } else {
            
            var alert = UIAlertController(title: "Warning", message: "The title field blank impassable", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println("AccountCreateViewController")
        
        titleTextField.delegate = self
        webSiteTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        noteTextView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        titleTextField.resignFirstResponder()
        webSiteTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
        
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if DeviceHelper().getDeviceModel() != "Device is not iPhone" {
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.frame.origin.y += -250
            })
            viewChanged = true
        
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if viewChanged == true {
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.frame.origin.y += 250
            })
            viewChanged = false
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        titleTextField.resignFirstResponder()
        webSiteTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
        
        if viewChanged == true {
            
            textFieldEndEditViewAnimation()
            
        }

        self.view.endEditing(true)
    
    }
    
    func textFieldBeginEditViewAnimation() {
        
        switch DeviceHelper().getDeviceModel() {
        case "iPhone 4 - 4s":
            if usernameTextField.isFirstResponder() || passwordTextField.isFirstResponder() || emailTextField.isFirstResponder(){
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.view.frame.origin.y += -160
                })
                viewChanged = true
                
            }
        case "iPhone 5 - 5s":
            if emailTextField.isFirstResponder(){
                
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
