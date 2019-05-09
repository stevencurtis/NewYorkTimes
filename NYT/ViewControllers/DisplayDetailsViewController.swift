//
//  DisplayDetailsViewController.swift
//  NYT
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

final class DisplayDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel : DisplayDetailsViewModel?

    var cache: NSCache<AnyObject, AnyObject>?
    var contents : DisplayContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cache = Cache.getCache()
        
        if let contents = contents {
            viewModel = DisplayDetailsModelBuilder.create(contents: contents)
            setup(contents: contents)
        }
    }
    
    func setup(contents: DisplayContent){
        titleLabel.text = viewModel?.contents?.title
        snippetLabel.text = viewModel?.contents?.abstract
        dateLabel.text = viewModel?.contents?.date
        
        if let imgURL = contents.image {
            imageView.isHidden = false
            if self.cache?.object(forKey: (imgURL as AnyObject)) != nil {
                imageView.image = self.cache?.object(forKey: imgURL as AnyObject as AnyObject) as? UIImage
            } else {
                
                viewModel?.retrieveImage(imgURL: imgURL) { result in
                    switch result {
                    case .failure(let error): print (error, "image error") // User will be unaware of the silent failure here
                    case .success(let data):
                        if let img: UIImage = UIImage(data: data) {
                            self.cache?.setObject(img, forKey: imgURL as AnyObject)
                            self.imageView.image = img
                        }
                    }
                }
            }
        }
        else
        {
            imageView.isHidden = true
        }
        
    }
    
}
