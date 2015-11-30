//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Alfonso Sosa on 23/09/15.
//  Copyright © 2015 Alfonso Sosa. All rights reserved.
//

import UIKit

//Collection VC cell
class MemeCollectionViewCell: UICollectionViewCell {
    
    //View that shows the meme image
    @IBOutlet weak var memeImage: UIImageView!
    
    //Labels for top & bottom text
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    //Bug in iOS where the imageView does not initally cover all the cell
    //SO 
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}
