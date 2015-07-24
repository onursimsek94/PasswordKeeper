//
//  AccountsViewController.swift
//  Password Keeper
//
//  Created by Onur ŞİMŞEK on 29/06/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit
import CoreData

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var accounts:NSArray = []
    
    @IBOutlet weak var accountsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println("AccountsViewController")
        
        self.getAccountsAndReloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAccountsAndReloadData(){
        
        accounts = []
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "PasswordKeeperAccounts")
        request.returnsObjectsAsFaults = false
        accounts = context.executeFetchRequest(request, error: nil)!
        
        accountsTableView.reloadData();
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = accountsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = accounts[indexPath.row].title
        println(accounts[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{

            var deleteAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
                (action) -> Void in
                
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let context: NSManagedObjectContext = appDel.managedObjectContext!
                let request = NSFetchRequest(entityName: "PasswordKeeperAccounts")
                var result = context.executeFetchRequest(request, error: nil)!
                
                for item in result {
                    if item as! NSManagedObject == self.accounts[indexPath.row] as! NSManagedObject{
                        context.deleteObject(item as! NSManagedObject)
                    }
                }
                context.save(nil)
                
                self.getAccountsAndReloadData()
                
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            
            self.presentViewController(deleteAlert, animated: true, completion: nil)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AccountDetailSegue"{
            
            let accountDetailViewController = segue.destinationViewController as! AccountDetailViewController
            let index = accountsTableView.indexPathForSelectedRow()?.row
            accountDetailViewController.accountDetail = accounts[index!] as! NSObject
            
        }
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
