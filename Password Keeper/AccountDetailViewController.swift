//
//  AccountDetailViewController.swift
//  PasswordKeeper
//
//  Created by Onur ŞİMŞEK on 28/06/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit
import CoreData

class AccountDetailViewController: UIViewController {

    var accountDetail = NSObject()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var noteLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        println("AccountDetailViewController")
        
        titleLabel.text = accountDetail.valueForKey("title") as? String
        websiteLabel.text = accountDetail.valueForKey("website") as? String
        usernameLabel.text = accountDetail.valueForKey("username") as? String
        passwordLabel.text = accountDetail.valueForKey("password") as? String
        emailLabel.text = accountDetail.valueForKey("email") as? String
        noteLabel.text = accountDetail.valueForKey("note") as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AccountEditSegue" {
            
            let accountEditViewController = segue.destinationViewController as! AccountEditViewController
            accountEditViewController.accountEdit = accountDetail
            
        }
    }
    

}
