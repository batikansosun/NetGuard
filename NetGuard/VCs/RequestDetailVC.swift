//
//  RequestDetailVC.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import UIKit

final class RequestDetailVC: BaseVC {
    var requestModel:RequestModel?
    private lazy var tableViewList: UITableView = {
        let t = UITableView(style: .plain)
        t.separatorInset = .zero
        t.delegate = self
        t.dataSource = self
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 200
        t.tableFooterView = UIView(frame: .zero)
        t.register(ViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: ViewSectionHeader.identifier)
        t.register(DetailTextCell.self, forCellReuseIdentifier: DetailTextCell.identifier)
        return t
    }()
    
    private lazy var sectionList: [SectionModel] = {
        guard let requestModel = requestModel else { return []}
        
        
        let summarySection = SectionModel(title: SectionModelType.summary.description, detail: requestModel.summary, type: .summary)
        let requestHeaderSection =  SectionModel(title: SectionModelType.requestHeader.description, detail: requestModel.requestHeaderAttrText, type: .requestHeader)
        let requestBodySection =    SectionModel(title: SectionModelType.requestBody.description, detail: requestModel.dataRequestAttrText, type: .requestBody)
        let responseHeaderSection = SectionModel(title: SectionModelType.responseHeader.description, detail: requestModel.responseHeaderAttrText, type: .responseHeader)
        let responseBodySection =   SectionModel(title: SectionModelType.responseBody.description, detail:requestModel.dataResponseAttrText, type: .responseBody)
        return [summarySection,requestBodySection,responseBodySection,requestHeaderSection,responseHeaderSection]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustLayout()
    }
    
    private func adjustLayout() {
        title = requestModel?.url
        let buttonRight = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionRequest))
        buttonRight.tintColor = .black
        navigationItem.rightBarButtonItem = buttonRight
        navigationController?.navigationBar.tintColor = .black
        self.view.addSubview(tableViewList)
        tableViewList.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableViewList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableViewList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc private func actionRequest(){
        let textShare = [requestModel?.exportRequestDetails ?? ""]
        let activityViewController = UIActivityViewController(activityItems: textShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func action(text: NSAttributedString, type: DetailButtonActionType){
        switch type {
        case .share:
            let textShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        case .detail:
            let vc = RequestLineDetailedVC()
            vc.attributedText = NSMutableAttributedString(attributedString: text)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
extension RequestDetailVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = sectionList[section]
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewSectionHeader.identifier) as! ViewSectionHeader
        view.load(section: model)
        view.pressedButtonCompletion = { (detail, type) in
            self.action(text: detail, type: type)
        }
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTextCell.identifier, for: indexPath) as! DetailTextCell
        let cellModel = sectionList[indexPath.section]
        cell.loadcell(section: cellModel)
        return cell
    }
}

extension RequestDetailVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
