//
//  NetGuardRequestListVC.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import UIKit

class NetGuardRequestListVC: BaseVC {
    
    lazy var tableViewList: UITableView = {
        let t = UITableView(style: .plain)
        t.separatorInset = .zero
        t.separatorStyle = .none
        t.delegate = self
        t.dataSource = self
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 200
        t.tableFooterView = UIView(frame: .zero)
        t.register(RequestListCell.self, forCellReuseIdentifier: RequestListCell.identifier)
        return t
    }()
    
    var searchController:UISearchController?
    
    var searchText = ""{
        didSet{
            if searchText.isEmpty {
                filteredRequests = StorageManager.shared.requests
            }else{
                filteredRequests = StorageManager.shared.requests.filter { (request) -> Bool in
                    return request.url.lowercased().contains(searchText.lowercased())
                }
            }
            tableViewList.reloadData()
        }
    }
    var filteredRequests: [RequestModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingNavigationBarAndSearchController()
        NotificationCenter.default.addObserver(forName: RequestNotifications.fetchNewRequestNotification, object: nil, queue: nil) { [weak self] (notification) in
            DispatchQueue.main.sync { [weak self] in
                self?.searchText = self?.searchController?.searchBar.text ?? ""
            }
        }
        adjustLayout()
        filteredRequests = StorageManager.shared.requests
        tableViewList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    
    //MARK: Layout UI
    func adjustLayout() {
        self.view.addSubview(tableViewList)
        tableViewList.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableViewList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableViewList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    //MARK: Actions
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clearRequests(){
        StorageManager.shared.clearRequests()
        filteredRequests = StorageManager.shared.requests
        tableViewList.reloadData()
    }
    
    func settingNavigationBarAndSearchController(){
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search request by url"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController?.searchBar
        }
        definesPresentationContext = true
        
        let buttonLeft = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        buttonLeft.tintColor = .black
        let buttonRight = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearRequests))
        buttonRight.tintColor = .black
        navigationItem.rightBarButtonItem = buttonLeft
        navigationItem.leftBarButtonItem = buttonRight
        navigationController?.navigationBar.tintColor = .generic
        title = "NetGuard"
    }
    
    func openRequestDetailVC(model:RequestModel) {
        let vc = RequestDetailVC()
        vc.requestModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: RequestNotifications.fetchNewRequestNotification, object: nil)
    }
}

extension NetGuardRequestListVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestListCell.identifier, for: indexPath) as! RequestListCell
        let cellModel = filteredRequests[indexPath.row]
        cell.loadCell(model: cellModel)
        return cell
    }
    
    
}

extension NetGuardRequestListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if filteredRequests.count>0 {
            let cellModel = filteredRequests[indexPath.row]
            openRequestDetailVC(model:cellModel)
        }
    }
}

extension NetGuardRequestListVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text ?? ""
    }
}
