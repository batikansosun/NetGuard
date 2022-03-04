//
//  RequestLineDetailedVC.swift
//  NetGuard
//
//  Created by Batikan Sosun on 4.03.2022.
//

import UIKit

final class RequestLineDetailedVC: BaseVC {
    var attributedText:NSMutableAttributedString?
    private var searchController:UISearchController?
    private lazy var textViewDetail: UITextView = {
        let t = UITextView(forAutoLayout: true)
        t.textAlignment = .left
        t.font = .systemFont(ofSize: 14, weight: .regular)
        t.textColor = .black
        t.showsVerticalScrollIndicator = true
        t.showsHorizontalScrollIndicator = false
        t.isScrollEnabled = true
        t.isEditable = false
        return t
    }()
    
    private var searchText = ""{
        didSet{
            if searchText.isEmpty {
                textViewDetail.attributedText = attributedText
            }else{
                filterText()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustLayout()
        textViewDetail.attributedText = attributedText
        settingNavigationBarAndSearchController()
    }
    
    private func adjustLayout(){
        view.addSubview(textViewDetail)
        textViewDetail.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        textViewDetail.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        textViewDetail.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textViewDetail.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    private func settingNavigationBarAndSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = NSLocalizedString("Search request by keyword", comment: "")
        searchController?.searchBar.tintColor = .black
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController?.searchBar
        }
        definesPresentationContext = true
        navigationController?.navigationBar.tintColor = .generic
        title = NSLocalizedString("NetGuard", comment: "")
    }
    
    private func filterText() {
        if let attributedText = attributedText{
            let attributed = NSMutableAttributedString(attributedString: attributedText)
            do
            {
                let regex = try! NSRegularExpression(pattern: searchText, options: .caseInsensitive)
                for match in regex.matches(in: attributed.string, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: attributed.string.count)) as [NSTextCheckingResult] {
                    attributed.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: match.range)
                }
                textViewDetail.attributedText = attributed
            }
        }
    }
}

extension RequestLineDetailedVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text ?? ""
    }
}
