//
//  HomeController.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 20.12.2020.
//

import UIKit

class HomeController: UIViewController {
    
    private static let cellIdentifier = "RedditCell"
    
    fileprivate var refreshControl = UIRefreshControl()
    
    fileprivate var items = [ChildrenData]()
    fileprivate let networkService = NetworkService()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        requestTopEntries()
    }
    
    fileprivate func initViews() {
        initTableView()
        initRefreshControl()
    }

    fileprivate func initTableView() {
        tableView.register(UINib(nibName: HomeController.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeController.cellIdentifier)
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func initRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshEntries), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc fileprivate func refreshEntries() {
        refreshControl.beginRefreshing()
        requestTopEntries()
    }
    
    fileprivate func requestTopEntries() {
        networkService.requestTopEntries {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let items):
                        self?.items = items
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
                
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    fileprivate func loadNextPage() {
        networkService.loadNextPage { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let items):
                        self?.items.append(contentsOf: items)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    fileprivate func showFullImage(for entry: RedditEntry) {
        let imageController = ImageController(with: entry)
        present(imageController, animated: true, completion: nil)
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
        cell.didTapThumbnail = { [weak self] entry in
            self?.showFullImage(for: entry)
        }
        
        return cell
    }
}

extension HomeController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10.0 {
            loadNextPage()
        }
    }
}
