//
//  AccountEditViewController.swift
//  PasswordKeeper
//
//  Created by Onur ŞİMŞEK on 28/06/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit
import CoreData

class AccountEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var accountEdit = NSObject()
    var viewChanged: Bool = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!

    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "PasswordKeeperAccounts")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "title = %@", accountEdit.valueForKey("title") as! String)
        var result = context.executeFetchRequest(request, error: nil)!
        
        result[0].setValue(titleTextField.text, forKey: "title")
        result[0].setValue(webSiteTextField.text, forKey: "website")
        result[0].setValue(usernameTextField.text, forKey: "username")
        result[0].setValue(passwordTextField.text, forKey: "password")
        result[0].setValue(emailTextField.text, forKey: "email")
        result[0].setValue(noteTextView.text, forKey: "note")
        
        var successAlert = UIAlertController(title: "Successful", message: "Account information updated", preferredStyle: UIAlertControllerStyle.Alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in
            
            println(result[0])
            
            let tabBarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarViewController") as! TabBarViewController
            self.presentViewController(tabBarViewController, animated: true, completion: nil)
            
        }))
        self.presentViewController(successAlert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println("AccountEditViewController")
        
        titleTextField.delegate = self
        webSiteTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        noteTextView.delegate = self
        
        titleTextField.text = accountEdit.valueForKey("title") as! String
        webSiteTextField.text = accountEdit.valueForKey("website") as! String
        usernameTextField.text = accountEdit.valueForKey("username") as! String
        passwordTextField.text = accountEdit.valueForKey("password") as! String
        emailTextField.text = accountEdit.valueForKey("email") as! String
        noteTextView.text = accountEdit.valueForKey("note") as! String
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AccountEditCancelSegue"{
        
            let accountDetailViewController = segue.destinationViewController as! AccountDetailViewController
            accountDetailViewController.accountDetail = accountEdit
            
        }
        
    }
    

}
