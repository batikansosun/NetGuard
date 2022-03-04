//
//  ViewSectionHeader.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import UIKit

enum DetailButtonActionType {
    case share, detail
}

final class ViewSectionHeader: UITableViewHeaderFooterView {
    
    var pressedButtonCompletion:((NSMutableAttributedString, DetailButtonActionType)->Void)?
    static let identifier = "IdentifierViewSectionHeader"
    private var sectionModel: SectionModel?
    private lazy var labelTitle: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.textAlignment = .left
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    private lazy var buttonShare: UIButton = {
        let b = UIButton(forAutoLayout: true)
        if let image = UIImage(named: "share") {
            b.setImage(image, for: .normal)
        } else {
            b.setTitle("share", for: .normal)
        }
        b.tintColor = .black
        b.contentMode = .scaleAspectFit
        b.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return b
    }()
    
    private lazy var buttonDetail: UIButton = {
        let b = UIButton(forAutoLayout: true)
        if let image = UIImage(named: "detail") {
            b.setImage(image, for: .normal)
        } else {
            b.setTitle("detail", for: .normal)
        }
        b.tintColor = .black
        b.contentMode = .scaleAspectFit
        b.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return b
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        adjustLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func adjustLayout() {
        contentView.backgroundColor = .genericLightGray
        addSubview(labelTitle)
        addSubview(buttonDetail)
        addSubview(buttonShare)
        
        labelTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        labelTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonDetail.leftAnchor.constraint(equalTo: labelTitle.rightAnchor, constant: 10).isActive = true
        buttonDetail.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        buttonDetail.heightAnchor.constraint(equalToConstant: 22).isActive = true
        buttonDetail.widthAnchor.constraint(equalToConstant: 22).isActive = true
        buttonShare.leftAnchor.constraint(equalTo: buttonDetail.rightAnchor, constant: 10).isActive = true
        buttonShare.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        buttonShare.heightAnchor.constraint(equalToConstant: 22).isActive = true
        buttonShare.widthAnchor.constraint(equalToConstant: 22).isActive = true
        buttonShare.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    func load(section:SectionModel) {
        sectionModel = section
        labelTitle.text = section.title
    }
    
    @objc private func buttonAction(_ sender: UIButton){
        var type: DetailButtonActionType = .share
        if sender == buttonDetail {
            type = .detail
        }
        self.pressedButtonCompletion?(sectionModel?.detail ?? NSMutableAttributedString(string: ""), type)
    }
}
