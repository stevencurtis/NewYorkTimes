//
//  PastSearchesViewControllerTableViewController.swift
//  NYT
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

final class PastSearchesTableViewController: UITableViewController {
    
    var pastSearches = [String]()
    var delegate : PastSearchesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastSearches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath)
        cell.textLabel?.text = pastSearches[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSearch = pastSearches[indexPath.row]
        pastSearches.append(newSearch)
        delegate?.setSearchTermsAndSearch(searchTerms: [newSearch] )
    }

}
