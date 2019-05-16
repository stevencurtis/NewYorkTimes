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
    
    func clearAll(){
        activityIndicator.stopAnimating()
        spacer.backgroundColor = .clear
        titleLabel.text = ""
        snippetLabel.text = ""
        dateLabel.text = ""
        imageView.isHidden = true
    }
    
    public func configure(with content: DisplayContent? ) {
        guard let content = content else {clearAll(); return}
        activityIndicator.stopAnimating()
        spacer.backgroundColor = .lightGray
        titleLabel.text = content.title
        if let abstract = content.abstract{
            snippetLabel.text = abstract.trunc(length: 150)
        } else {
            snippetLabel.text = nil
        }
        dateLabel.text = content.date
        if content.image == nil {
            imageView.isHidden = true
        } else {
            imageView.isHidden = false
        }
    }

}
