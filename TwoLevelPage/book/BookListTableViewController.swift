//
//  BookListTableViewController.swift
//  book
//
//  Created by lzy-os on 16/5/28.
//  Copyright © 2016年 lzy-os. All rights reserved.
//

import UIKit
import CoreData

class BookListTableViewController: UITableViewController {

    var dataArr:Array<AnyObject> = []
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        refreshData()
    }

    // 增加新笔记本数据
    func newBook(n:String){
        
        let date:NSDate = NSDate()
        let name = n
        let img = NSData()
        
        context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: context)
        
        row.setValue(name, forKey: "name")
        row.setValue(date, forKey: "date")
        row.setValue(img, forKey: "img")
        
        try? context.save()
//        print("Save Done!")
        refreshData()

    }
    
    /// 保存并刷新数据
    func refreshData(){
        try? context.save()
        let f = NSFetchRequest(entityName: "Book")
        try? dataArr = context.executeFetchRequest(f)
        tableView.reloadData()
    }
    
    /// 增加新笔记本按钮
    @IBAction func add(sender: AnyObject) {
        let alert = UIAlertController(title: "新笔记本",
                                      message: "请输入新笔记本的名字",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "好的",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                        let textField = alert.textFields![0] as UITextField
                                        self.newBook(textField.text!)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        // textfield 布局问题
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }

    // 构造cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let img = cell.viewWithTag(2) as! UIImageView
        let lab = cell.viewWithTag(3) as! UILabel
//        let view = cell.viewWithTag(4)! as UIView
        
        img.image = UIImage(named: "1")
        img.layer.cornerRadius = 10
        img.layer.borderWidth = 2
        img.layer.masksToBounds = true
        lab.text = dataArr[indexPath.row].valueForKey("name") as? String
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // 左划菜单
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "删除") { action, index in
            print("delete button tapped")
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "您确定要删除本笔记本吗？", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .Default,
                                         handler: { action in
                                            self.context.deleteObject(self.dataArr[indexPath.row] as! NSManagedObject)
                                            self.refreshData()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            try? self.context.save()
            
        }
        delete.backgroundColor = UIColor.redColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "修改") { action, index in
            let alert = UIAlertController(title: "系统提示",
                                          message: "修改笔记本名称",
                                          preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消",
                                             style: .Default) { (action: UIAlertAction!) -> Void in
            }
            let saveAction = UIAlertAction(title: "好的",
                                           style: .Default) { (action: UIAlertAction!) -> Void in
                                            let textField = alert.textFields![0] as UITextField
                                            let text = textField.text
                                            self.dataArr[indexPath.row].setValue(text, forKey: "name")
                                            self.tableView.reloadData()
            }
            // textfield 布局问题
            alert.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
                textField.text = self.dataArr[indexPath.row].valueForKey("name") as? String
            }
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [delete, share]
    }
 
    // 系统自带左划，未使用
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
        }
    }
    
    // 选中cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        //cell选中效果变为无
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        let f = NSFetchRequest(entityName: "Book")
//        let date = dataArr[indexPath.row].objectID as! String
        
        let date = dataArr[indexPath.row].valueForKey("date") as! NSDate
        
        let img = cell.viewWithTag(2) as! UIImageView
        let lab = cell.viewWithTag(3) as! UILabel
        let view = cell.viewWithTag(4)! as UIView
   
        img.image = UIImage(named: "1")
        img.layer.cornerRadius = 10
        img.layer.borderWidth = 2
        img.layer.masksToBounds = true
        view.backgroundColor = UIColor.whiteColor()
        lab.text = dataArr[indexPath.row].valueForKey("name") as? String
        
        let bookPage = self.storyboard?.instantiateViewControllerWithIdentifier("BookPage") as! BookPageTableViewController
        let booklist = self.storyboard?.instantiateViewControllerWithIdentifier("BookList") as! BookListTableViewController
        
        //Page的从属
        bookPage.bookdate = "\(date)"
        bookPage.booklist = booklist
        
        self.presentViewController(bookPage, animated: true, completion: nil)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
