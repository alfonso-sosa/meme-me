//
//  UIViewController.swift
//  MemeMe
//
//  Created by Alfonso Sosa on 24/09/15.
//  Copyright © 2015 Alfonso Sosa. All rights reserved.
//

import UIKit

//Extension for all View Controllers, shows the Meme editor
extension UIViewController {
    
    //App Delegate's saved memes
    var memes: [Meme] {
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        }
    }
    
    
    //Presents the MemeEditorViewController
    func showMemeEditor(memeIndex: Int?){
        let editMemeVC = storyboard!.instantiateViewControllerWithIdentifier("editMemeVC") as! MemeEditorViewController
        editMemeVC.memeIndex = memeIndex
        editMemeVC.setupMeme = memeIndex != nil
        presentViewController(editMemeVC, animated: true, completion: nil)
    }
    
}
