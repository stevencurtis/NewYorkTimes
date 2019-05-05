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
    
    var cache: NSCache<AnyObject, AnyObject>?
    var contents : DisplayContent?
    
    private var dataManagerClass: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManagerClass = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    // called from the storyboard
    required init?(coder aDecoder: NSCoder) {
        self.dataManagerClass = DataManagerSingleton.createDataManager()
        super.init(coder: aDecoder)
    }

    func setup(contents: DisplayContent){
        titleLabel.text = contents.title
        snippetLabel.text = contents.abstract
        dateLabel.text = contents.date
        
        if let img = contents.image {
            imageView.isHidden = false
            if self.cache?.object(forKey: (img as AnyObject)) != nil {
                imageView.image = self.cache?.object(forKey: img as AnyObject as AnyObject) as? UIImage
                
            }else{
                // Do not have the image in the cache, so we go to download the image again
                dataManagerClass.fetchImageData(withURLString: img, completion: { result in
                    switch result {
                    case .failure(let error): print (error, "error") // fail gracefully
                    case .success(let data):
                        let img: UIImage! = UIImage(data: data)
                        self.imageView.image = img
                    }
                })
                
            }
            
        } else {
            imageView.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cache = Cache.getCache()
        
        if let contents = contents {
            setup(contents: contents)
        }
    }
    

}
