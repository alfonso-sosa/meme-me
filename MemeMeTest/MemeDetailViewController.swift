//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Alfonso Sosa on 08/10/15.
//  Copyright © 2015 Alfonso Sosa. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeIndex: Int!
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    //Meme text attributes from app delegate, adds font
    var memeTextAttributes: [String: NSObject] {
        get {
            var textAttributes = (UIApplication.sharedApplication().delegate as! AppDelegate).memeTextAttributes
            textAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            return textAttributes
        }
    }
    
    //Sets up the memed image
    override func viewWillAppear(animated: Bool) {
        let meme = memes[memeIndex]
        memedImageView.image = meme.image
        memedImageView.contentMode = UIViewContentMode.ScaleAspectFit
        topLabel.attributedText = NSAttributedString(string: meme.top, attributes: memeTextAttributes)
        bottomLabel.attributedText = NSAttributedString(string: meme.bottom, attributes: memeTextAttributes)
    }
    
    //Invoked when 'Edit' button is pressed
    @IBAction func edit(sender: UIBarButtonItem) {
        showMemeEditor(memeIndex)
    }
    
}
