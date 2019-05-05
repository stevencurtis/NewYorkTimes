//
//  HomeViewController.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

protocol PastSearchesDelegate {
    func setSearchTermsAndSearch(searchTerms: [String])
}

final class HomeViewController: UIViewController {
    
    private var dataManagerClass: DataManagerProtocol
    
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (style: UIActivityIndicatorView.Style.gray)

    init(dataManager: DataManagerProtocol) {
        self.dataManagerClass = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    // called from the storyboard
    required init?(coder aDecoder: NSCoder) {
        self.dataManagerClass = DataManagerSingleton.createDataManager()
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    var refreshControl : UIRefreshControl!

    
    let searchController = UISearchController(searchResultsController: nil)
    var searchTerms = [""]
    var collectionView : UICollectionView!
    var articles = [DisplayContent]()

    /// cache used to store images
    var cache: NSCache<AnyObject, AnyObject>?
    
    var previousSearches = [String]()
    
    var maxContents = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // retrieve the cache
        self.cache = Cache.getCache()

        // retrieve searched terms
        previousSearches = RecentKeywords.returnkeywords(forKey: UserDefaultsKey) ?? []
        
        let logo = UIImage(named: "NYTheader")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil);
        collectionView.register(nib, forCellWithReuseIdentifier: "ArticleCell")
        
        collectionView.backgroundColor = UIColor.clear
        
         self.view.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .automatic

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])

        view.bringSubviewToFront(activityIndicator)
        
        fetchArticles()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(fetchArticles), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search stories"
        searchController.delegate = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
    }
    

    func removeContainerView() {
        if containerView != nil && containerView.isDescendant(of: view) {
            containerView.removeFromSuperview()
        }
    }
    
    func createContainerView() {
        if containerView != nil && containerView.isDescendant(of: view) {
            containerView.removeFromSuperview()
        }
        
        // add container
        let localContainerView = UIView()
        localContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localContainerView)
        NSLayoutConstraint.activate([
            localContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            localContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            localContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            localContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            ])
        
        if let controller = storyboard!.instantiateViewController(withIdentifier: "past") as? PastSearchesTableViewController {
            
            controller.delegate = self
            controller.pastSearches = previousSearches
            
            addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            localContainerView.addSubview(controller.view)
            
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: localContainerView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: localContainerView.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: localContainerView.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: localContainerView.bottomAnchor)
                ])
            
            controller.didMove(toParent: self)
        }
        containerView = localContainerView
    }
    
    func processResult(_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData), Error>, _ firstLoad: Bool){
        switch result {
        case .failure(let error):
            let custerr = error as NSError
            processError(custerr.code)
        case .success(let res):
            self.displayContent(res.content, res.metadata, firstLoad)
            
        }
    }
    
    /// refresh delivers the same initial page content
    @objc func fetchArticles(sender:AnyObject? = nil)
    {
        fetchArticle(sender: sender) { (result, refresh) in
            self.processResult(result, sender != nil ? false : true)
        }
    }
    
    func fetchArticle(sender: AnyObject? = nil, completion: ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData), Error>, _ firstLoad: Bool) -> Void)? = nil ) {
        if searchTerms != [""] {
            dataManagerClass.fetchArticles(withAPI: .searchArticles(query: searchTerms.joined(separator: " "), pageIndex: nil), refresh: sender == nil ? false : true)
            {  result in
                if let completion = completion {
                    completion(result, sender != nil ? false : true)
                }
            }
        }
        else {
            dataManagerClass.fetchArticles(withAPI: .getContents(pageIndex: nil, pageSize: nil), refresh: sender == nil ? false : true)
            {  result in
                if let completion = completion {
                    completion(result, sender != nil ? false : true)
                }
            }
        }
    }
    
    /// process the error message for the UI
    func processError(_ code: Int){
        var message = String()
        var title = String()

        if (code == -1009) {
            title = "Connection error"
            message = "The Internet appears to be offline"
        }
        else {
            title = "Error"
            message = "An error has occured"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func displayContent(_ content: [DisplayContent], _ meta: DisplayContentMetaData, _ firstLoad: Bool) {
        self.activityIndicator.stopAnimating()
        guard meta.hits != 0 else { self.resultsLabel.isHidden = false; return }
        self.resultsLabel.isHidden = true
        self.maxContents = meta.hits
        if firstLoad {
            self.articles += content
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
        else {
            self.refreshControl.endRefreshing()
            self.articles = content
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath)

        if let articleCell = cell as? ArticleCollectionViewCell {
            if indexPath.row == articles.count {
                
                // TODO: Will also display if there are no results!!
                if indexPath.row > 1 {
                    articleCell.activityIndicator.startAnimating()
                    fetchArticles()
                }
                return cell
            }
  
            articleCell.configure(with: articles[indexPath.row])
            
            // Images are multimedia in order of size (asc)
            let imgURL = articles[indexPath.row].image ?? articles[indexPath.row].thumbnailImageString

            if let imgURL = imgURL {
            if self.cache?.object(forKey: (imgURL as AnyObject)) != nil {
                articleCell.imageView?.image = self.cache?.object(forKey: imgURL as AnyObject as AnyObject) as? UIImage
            } else {
                DataManager.shared.fetchImageData(withURLString: imgURL, completion: { [weak self] result in
                guard let self = self else {return}

                switch result {
                case .failure(let error): print (error, "image error") // User will be unaware of the silent failure
                case .success(let data):
                    let img: UIImage! = UIImage(data: data)
                    self.cache?.setObject(img, forKey: imgURL as AnyObject)
                    articleCell.imageView.image = img
                }
            })
            }
            }
        }
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.articles.indices.contains(indexPath.row), let _ = self.articles[indexPath.row].image {
            return CGSize(width: view.bounds.width, height: 500)
        }
        return CGSize(width: view.bounds.width, height: 400)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        performSegue(withIdentifier: "articlesseque", sender: indexPath.item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articlesseque" {
            let articlesVC = segue.destination as! DetailsViewController
            let index = sender as! Int
            
            if index - 1 >= 0 {
                articlesVC.leftContents = articles[index - 1]
            }
            
            if index + 1 < maxContents {
                articlesVC.rightContents = articles[index + 1]
            }

            articlesVC.contents = articles[index]
        }
    }

}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.articles.removeAll()
        
        let newSearch = searchTerms.joined(separator: " ")
        
        previousSearches.append(newSearch)
        
            while previousSearches.count > savedSearches {
                previousSearches.removeFirst()
            }
            
            if !previousSearches.contains(newSearch) {
                previousSearches.removeFirst()
                previousSearches.append(newSearch)
            }
        
        RecentKeywords.set(newSearch, forKey: UserDefaultsKey)

        removeContainerView()
        activityIndicator.startAnimating()
        collectionView.reloadData()
        collectionView.isHidden = true
        self.resultsLabel.isHidden = true
        fetchArticles()
    }
}

extension HomeViewController: PastSearchesDelegate {
    // delegate
    func setSearchTermsAndSearch(searchTerms: [String]) {
        
        removeContainerView()

        // resign the searchbar, and thekeyboard
        searchController.isActive = false
        
        self.searchTerms = searchTerms
        fetchArticles(sender: "past" as AnyObject)
    }
}

extension HomeViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        createContainerView()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchTerms = [""]
        previousSearches.append(searchTerms.joined(separator: " "))

        self.articles.removeAll()
        removeContainerView()
        collectionView.reloadData()
        activityIndicator.startAnimating()
        collectionView.isHidden = true
        self.resultsLabel.isHidden = true
        fetchArticles()
    }
}

extension HomeViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        searchTerms = (searchController.searchBar.text?.components(separatedBy: " ")) ?? [""]
    }
}

