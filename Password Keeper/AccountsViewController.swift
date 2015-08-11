//
//  AccountsViewController.swift
//  Password Keeper
//
//  Created by Onur ŞİMŞEK on 29/06/15.
//  Copyright (c) 2015 Onur ŞİMŞEK. All rights reserved.
//

import UIKit
import CoreData

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var accounts:NSArray = []
    var filteredAccounts:NSMutableArray = []
    
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var accountsSearchBar: UISearchBar!
    
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
        filteredAccounts = []
        accountsSearchBar.text = ""
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "PasswordKeeperAccounts")
        request.returnsObjectsAsFaults = false
        var sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        accounts = context.executeFetchRequest(request, error: nil)!
        
        accountsTableView.reloadData();
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredAccounts.count > 0 {
            return filteredAccounts.count
        } else {
            return accounts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = accountsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        if filteredAccounts.count > 0 {
            cell.textLabel?.text = filteredAccounts[indexPath.row].title
        } else {
            cell.textLabel?.text = accounts[indexPath.row].title
        }
        
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
                
                if self.filteredAccounts.count > 0 {
                    
                    for item in result {
                        if item as! NSManagedObject == self.filteredAccounts[indexPath.row] as! NSManagedObject{
                            context.deleteObject(item as! NSManagedObject)
                        }
                    }
                    
                    
                } else {
                    
                    for item in result {
                        if item as! NSManagedObject == self.accounts[indexPath.row] as! NSManagedObject{
                            context.deleteObject(item as! NSManagedObject)
                        }
                    }
                    
                }
                
                context.save(nil)
                
                self.getAccountsAndReloadData()
                
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            
            self.presentViewController(deleteAlert, animated: true, completion: nil)
            
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredAccounts = []
        if count(accountsSearchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) >= 2 {
            
            for item in accounts {
                
                if count(accountsSearchBar.text) <= count(item.title!!) && accountsSearchBar.text.lowercaseString == item.title!!.substringToIndex(advance(item.title!!.startIndex, count(accountsSearchBar.text))).lowercaseString {
                    
                    filteredAccounts.addObject(item)
                    
                }
                
            }
            
        }
        accountsTableView.reloadData();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AccountDetailSegue"{
            
            let accountDetailViewController = segue.destinationViewController as! AccountDetailViewController
            let index = accountsTableView.indexPathForSelectedRow()?.row
            if filteredAccounts.count > 0 {
                
                accountDetailViewController.accountDetail = filteredAccounts[index!] as! NSObject
            
            } else {
            
                accountDetailViewController.accountDetail = accounts[index!] as! NSObject
            
            }
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
