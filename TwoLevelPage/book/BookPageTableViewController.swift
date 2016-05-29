//
//  BookPageTableViewController.swift
//  book
//
//  Created by lzy-os on 16/5/28.
//  Copyright © 2016年 lzy-os. All rights reserved.
//

import UIKit
import CoreData

class BookPageTableViewController: UITableViewController {

    var bookdate:String?
    var booklist:BookListTableViewController?
    var dataArr:Array<AnyObject> = []
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        print(NSHomeDirectory())
        
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    /// 读数据并刷新
    func refreshData(){
        try? context.save()
        let f = NSFetchRequest(entityName: "Page")
        let p = bookdate! as String
        let predicate = NSPredicate(format: "bookdate == '\(p)'")
        f.predicate = predicate
        try? dataArr = context.executeFetchRequest(f)
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }
    
    /// 新笔记本页数据设置
    func newPage(){
        
        let date:NSDate = NSDate()
        let name = "新建页"
        let text = ""
        let ink = NSData()
        
        context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Page", inManagedObjectContext: context)
        
        row.setValue(name, forKey: "name")
        row.setValue(date, forKey: "date")
        row.setValue(text, forKey: "text")
        row.setValue(self.bookdate, forKey: "bookdate")
        row.setValue(ink, forKey: "ink")
        
        try? context.save()
//        print("Page Save Done!")
        refreshData()
    }
    
    /// 增加新页面按钮动作
    @IBAction func AddPageBtn(sender: AnyObject) {
        newPage()
    }
    
    @IBAction func BackBtn(sender: AnyObject) {
        self.presentViewController(booklist!, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let lab = cell.viewWithTag(2) as! UILabel
        lab.text = dataArr[indexPath.row].valueForKey("name") as? String
        let date = dataArr[indexPath.row].valueForKey("bookdate") as? NSDate
        
        

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
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "您确定要删除本页吗？", preferredStyle: .Alert)
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
                                          message: "修改页名称",
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
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // 选中cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
               
        //page页面点击后
        
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
