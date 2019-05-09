//
//  HomesViewController.swift
//  NYT
//
//  Created by Steven Curtis on 06/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (style: UIActivityIndicatorView.Style.gray)

    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var refreshControl : UIRefreshControl!
    
    fileprivate var pastSearchViewController: PastSearchesTableViewController!

    fileprivate var searchController: UISearchController!
    var articlesCollectionView : UICollectionView!

    var cache: NSCache<AnyObject, AnyObject>?

    var viewModel : HomeViewModelProtocol = HomeViewModelBuilder.create()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "NYTheader")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        articlesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        articlesCollectionView.dataSource = self
        articlesCollectionView.delegate = self
        
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil);
        articlesCollectionView.register(nib, forCellWithReuseIdentifier: "ArticleCell")
        
        articlesCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(articlesCollectionView)
        
        articlesCollectionView.contentInsetAdjustmentBehavior = .automatic
        articlesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articlesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            articlesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            articlesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            articlesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        
        view.bringSubviewToFront(activityIndicator)

        fetchArticlesFromViewModel()
        
        // when the viewmodel's articles change, reload the collectionview
        viewModel.articlesDidChange = { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.articlesCollectionView.reloadData()
            }
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(fetchArticles), for: .valueChanged)
        articlesCollectionView.addSubview(refreshControl)
        
        // Setup the Search Controller
        guard let storyboard = storyboard else {return}
        pastSearchViewController = (storyboard.instantiateViewController(withIdentifier: "pastsearch") as? PastSearchesTableViewController)
        searchController = UISearchController(searchResultsController: pastSearchViewController)
        searchController.searchResultsUpdater = pastSearchViewController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search stories", comment: "")
        searchController.searchBar.delegate = pastSearchViewController
        
        pastSearchViewController.searchBar = searchController.searchBar
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func fetchArticles(sender:AnyObject? = nil)
    {
        fetchArticlesFromViewModel(refresh: true)
    }
    
    func fetchArticlesFromViewModel(refresh: Bool? = true) {
        guard let refresh = refresh else {return}
        if refresh {
            viewModel.fetchArticle(refresh: true) { [weak self] res in
                guard let self = self else {return}
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                if case .failure(let error) = res {
                    let err = error as NSError
                    let notifMess = self.processError(err.code)
                    self.showNotification(title: notifMess.title, message: notifMess.message)
                }
            }
        } else {
            viewModel.fetchMore(completion: nil)
        }
    }
    
    /// process the error message for the UI
    func processError(_ code: Int) -> (title: String, message: String){
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
        return (title, message)
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let articlesCount = viewModel.articles?.count {
            return articlesCount + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath)
        
        if let articleCell = cell as? ArticleCollectionViewCell {

            guard let articles = viewModel.articles else {return cell}
            
            if (indexPath.row == articles.count) && indexPath.row > 1 {

                articleCell.activityIndicator.startAnimating()
                fetchArticlesFromViewModel(refresh: false)
                return articleCell
            }
            
            if let articles = viewModel.articles, (articles.count - 1 > indexPath.row) {
                
                articleCell.configure(with: articles[indexPath.row])
                
                // Images are multimedia in order of size (asc)
                let imgURL = articles[indexPath.row].image ?? articles[indexPath.row].thumbnailImageString
                
                if let imgURL = imgURL {
                    
                    if self.cache?.object(forKey: (imgURL as AnyObject)) != nil {
                        articleCell.imageView?.image = self.cache?.object(forKey: imgURL as AnyObject as AnyObject) as? UIImage
                    } else {
                        
                        viewModel.retrieveImage(imgURL: imgURL) { result in
                            switch result {
                            case .failure(let error): print (error, "image error") // User will be unaware of the silent failure here
                            case .success(let data):
                                if let img: UIImage = UIImage(data: data) {
                                    self.cache?.setObject(img, forKey: imgURL as AnyObject)
                                    articleCell.imageView.image = img
                                }
                            }
                        }
                    }
                }
            } else {
                articleCell.configure(with: nil)
                return articleCell
            }
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let articles = viewModel.articles, articles.indices.contains(indexPath.row), let _ = articles[indexPath.row].image{
            return CGSize(width: view.bounds.width, height: 550)
        }
        return CGSize(width: view.bounds.width, height: 400)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "articlesseque", sender: indexPath.item)
    }
    
    func prepBeforeAfterArticles(index: Int, articles: [DisplayContent], VC: inout DetailsViewControllerProtocol) {
        if index - 1 >= 0 {
            VC.leftContents = articles[index - 1]
        }
        
        if (index + 1 < viewModel.metaData?.hits ?? index) {
            if articles.indices.contains(index + 1) {
                VC.rightContents = articles[index + 1]
            } else {
                // we didn't get back the data to display in the content.
                // we wait to get that next piece of content before segue to the next page
                viewModel.fetchMore{ [weak self] result in
                    guard let self = self else {return}
                    self.activityIndicator.startAnimating()
                    switch result {
                    case .failure(let error):
                        let err = error as NSError
                        let notifMess = self.processError(err.code)
                        self.showNotification(title: notifMess.title, message: notifMess.message)
                    case .success:
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
        VC.contents = articles[index]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articlesseque" {
            guard var articlesVC = segue.destination as? DetailsViewControllerProtocol else {return}
                if let index = sender as? Int, let articles = viewModel.articles {
                    prepBeforeAfterArticles(index: index, articles: articles, VC: &articlesVC)
                }
        }
    }
    
}




