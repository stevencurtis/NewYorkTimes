//
//  ArticleCollectionViewCell.swift
//  NYT
//
//  Created by Steven Curtis on 30/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var spacer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with content: DisplayContent ) {
        activityIndicator.stopAnimating()
        spacer.backgroundColor = .lightGray
        titleLabel.text = content.title
        snippetLabel.text = content.abstract
        dateLabel.text = content.date
        if content.image == nil {
            imageView.isHidden = true
        } else {
            imageView.isHidden = false
        }
    }


}
