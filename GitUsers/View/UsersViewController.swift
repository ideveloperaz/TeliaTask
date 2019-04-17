//
//  UsersViewController.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = UsersViewModel(manager: UsersManager.shared)
    var users: [User] = []
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataBinding()
    }
    
    // Data binding
    private func dataBinding() {
        // Refresh button's click
        bindRefreshButton()
        
        // Bind table view
        bindTableView()
    }
    
    // Bind refresh button
    private func bindRefreshButton() {
        refreshButton.rx.tap.asObservable()
            .subscribe(onNext: {
                // Scroll to top just not to fire willDispayCell for last cell
                self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)

                // Clear data
                self.users.removeAll()
                self.tableView.reloadData()
                
                // Load data from Web
                self.viewModel.loadUsers(online: true)
            })
            .disposed(by: disposeBag)
    }
    
    // Binds table view
    private func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.users.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "userViewCell"))(initCell)
            .disposed(by: disposeBag)
    }
    
    // Init cell
    private func initCell(row: Int, element: User, cell: UITableViewCell){
        cell.textLabel?.text = element.login
    }
    
    // Table delegate to init loading next portion of data 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.showingUserByIndex(userIndex: indexPath.row)
    }
}
