//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Alfonso Sosa on 22/09/15.
//  Copyright © 2015 Alfonso Sosa. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UICollectionViewController {
    
    //Collection flow layout to specify visual properties (e.g. item spacing), see viewDidLoad
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    //Meme text attributes from app delegate, adds font
    var memeTextAttributes: [String: NSObject] {
        get {
            var textAttributes = (UIApplication.sharedApplication().delegate as! AppDelegate).memeTextAttributes
            textAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)
            return textAttributes
        }
    }
 
    //Number of memes in the only section
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Cell to display for each meme
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        //Attributed text used to show the same text style throughout the app
        cell.topLabel!.attributedText = NSMutableAttributedString(string: meme.top, attributes: memeTextAttributes)
        cell.bottomLabel!.attributedText = NSMutableAttributedString(string: meme.bottom, attributes: memeTextAttributes)
        cell.memeImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.memeImage.image = meme.image
        return cell
    }

    //Triggered when user presses an item in the collection
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "collectionToDetailSegue"){
            let controller =  segue.destinationViewController as! MemeDetailViewController
            let index = (collectionView?.indexPathsForSelectedItems()![0].item)!
            controller.memeIndex = index
        }
    }
    
    //Invoked when the user presses '+' to add a meme
    @IBAction func addMeme(sender: UIBarButtonItem) {
        showMemeEditor(nil)
    }
    
    //Reloads data every time the view is presented
    override func viewWillAppear(animated: Bool) {
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
    }
    
    //Sets up the flow layout when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - 2*space) / 3.0
        let height = (view.frame.size.height - 3*space) / 7.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(width, height)
    }
}

