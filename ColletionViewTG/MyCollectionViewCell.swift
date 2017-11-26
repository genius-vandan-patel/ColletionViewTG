//
//  MyCollectionViewCell.swift
//  ColletionViewTG
//
//  Created by Vandan Patel on 11/25/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    
    var isEditing: Bool = false {
        didSet {
            selectionImage.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                selectionImage.image = isSelected ? #imageLiteral(resourceName: "Checked") : #imageLiteral(resourceName: "Unchecked")
            }
        }
    }
}
