//
//  HomeController.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 20.12.2020.
//

import UIKit

class HomeController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        requestTopEntries()
    }

    fileprivate func initViews() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    fileprivate func requestTopEntries() {
        NetworkService().requestTopEntries { result in
            switch result {
                case .success(let response):
                    print(response.count)
                    let topItem = response.first
                    print(topItem as Any)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}
