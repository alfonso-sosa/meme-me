//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Alfonso Sosa on 22/09/15.
//  Copyright © 2015 Alfonso Sosa. All rights reserved.
//

import UIKit

//Table VC
class MemesTableViewController: UITableViewController {
    
    
    
    //Meme text attributes from app delegate, adds font
    var memeTextAttributes: [String: NSObject] {
        get {
            var textAttributes = (UIApplication.sharedApplication().delegate as! AppDelegate).memeTextAttributes
            textAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 25)
            return textAttributes
        }
    }
    
    //Sections in the table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Rows in the only section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Cell for each meme
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        //Attributed text to use the same font style throughout the app
        cell.topLabel!.attributedText = NSMutableAttributedString(string: meme.top, attributes: memeTextAttributes)
        cell.bottomLabel!.attributedText = NSMutableAttributedString(string: meme.bottom, attributes: memeTextAttributes)
        cell.memeImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.memeImage!.image = meme.image
        cell.layoutSubviews()
        return cell
    }
    
    //Allows editing rows
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //Commits deleting row to memory
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //Indicates user is trying to delete
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            //Removes meme from shared array
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            //Removes from the table view
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    //Triggered when user presses on a table row
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tableToDetailSegue"){
            let controller =  segue.destinationViewController as! MemeDetailViewController
            let index = (tableView?.indexPathForSelectedRow!.row)!
            controller.memeIndex = index
        }
    }
    
    //Invoked when the user presses '+' to add a meme
    @IBAction func addMeme(sender: UIBarButtonItem) {
        showMemeEditor(nil)
    }
    
    //Reloads table data every time the view is presented
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        //Disallows multiple selection for deleting items
        tableView.allowsMultipleSelectionDuringEditing = false
    }
}