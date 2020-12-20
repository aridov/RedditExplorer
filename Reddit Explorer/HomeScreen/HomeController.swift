//
//  HomeController.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 20.12.2020.
//

import UIKit

class HomeController: UIViewController {
    private static let cellIdentifier = "RedditCell"
    fileprivate var items = [ChildrenData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        requestTopEntries()
    }

    fileprivate func initViews() {
        tableView.register(UINib(nibName: HomeController.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeController.cellIdentifier)
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func requestTopEntries() {
        NetworkService().requestTopEntries {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let items):
                        self?.items = items
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeController.cellIdentifier, for: indexPath) as! RedditCell
        let redditEntry = items[indexPath.row].data
        
        cell.setRedditEntry(redditEntry)
        
        return cell
    }
}
