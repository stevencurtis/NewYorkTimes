//
//  PastSearchTableViewController.swift
//  NYT
//
//  Created by Steven Curtis on 07/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class PastSearchesTableViewController: UITableViewController {
    
    weak var searchBar: UISearchBar?
    
    var viewModel : PastSearchModelProtocol = PastSearchViewModelBuilder.create()
    var dimmingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.searchesDidChange = { [weak self] result in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
        viewModel.fetchSearches()
    }
    
    func showLoading() {
        let dimmingView = UIView(frame: view.frame)
        dimmingView.backgroundColor = .darkGray
        view.addSubview(dimmingView)
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: dimmingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: dimmingView.centerYAnchor)
            ])
        activityIndicator.startAnimating()
        self.dimmingView = dimmingView
    }
    
    func removeLoading() {
        dimmingView?.removeFromSuperview()
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.previousSearches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // searchcell is in the storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath)
        cell.textLabel?.text = viewModel.previousSearches?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let search = viewModel.previousSearches?[indexPath.row] {
            showLoading()
            searchBar?.resignFirstResponder()
            searchBar?.text = viewModel.previousSearches![indexPath.row]
            
            // set the search term
            viewModel.addSearchTerm(search)
            viewModel.fetchArticle(searchTerms: search) {[weak self] result in
                guard let self = self else {return}
                
                switch result {
                case .success : break
                case .failure(let error):
                    let custerr = error as NSError
                    let notifMess = self.processError(custerr.code)
                    self.showNotification(title: notifMess.title, message: notifMess.message)
                }
                
                self.removeLoading()
                self.tableView.deselectRow(at: indexPath, animated: false)
                self.view.isHidden = true
            }
        }
    }
    
}

extension PastSearchesTableViewController: UISearchControllerDelegate {}


extension PastSearchesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        view.isHidden = false
    }
}

extension PastSearchesTableViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchContents(refresh: nil, completion: nil)
    }
    
    /// search bar search clicked when typed in
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showLoading()
        if let search = searchBar.text {
            viewModel.addSearchTerm(search)
            viewModel.fetchArticle(searchTerms: search) {[weak self] result in
                guard let self = self else {return}
                switch result {
                case .success: break
                case .failure(let error):
                    let custerr = error as NSError
                    let notifMess = self.processError(custerr.code)
                    self.showNotification(title: notifMess.title, message: notifMess.message)
                }
                
                self.removeLoading()
                self.view.isHidden = true
            }
        }
        
    }
}
