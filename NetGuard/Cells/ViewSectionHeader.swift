//
//  ViewSectionHeader.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import UIKit

class ViewSectionHeader: UITableViewHeaderFooterView {
    
    var pressedButtonCompletion:((NSMutableAttributedString)->Void)?
    
    static let identifier = "IdentifierViewSectionHeader"
    var sectionModel: SectionModel?
    lazy var labelTitle: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.textAlignment = .left
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    lazy var buttonShare: UIButton = {
        let b = UIButton(forAutoLayout: true)
        b.setImage(UIImage(named: "share"), for: .normal)
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
    
    func adjustLayout() {
        self.backgroundColor = .generic
        addSubview(labelTitle)
        addSubview(buttonShare)
        
        //labelTitle.topAnchor.constraint(equalTo: topAnchor, constant: 2.5).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        //labelTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2.5).isActive = true
        labelTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
       // buttonShare.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0).isActive = true
        buttonShare.leftAnchor.constraint(equalTo: labelTitle.rightAnchor, constant: 10).isActive = true
       // buttonShare.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0).isActive = true
        buttonShare.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        buttonShare.heightAnchor.constraint(equalToConstant: 22).isActive = true
        buttonShare.widthAnchor.constraint(equalToConstant: 22).isActive = true
        buttonShare.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    func load(section:SectionModel) {
        sectionModel = section
        labelTitle.text = section.title
    }
    
    
    
    @objc func buttonAction(){
        self.pressedButtonCompletion?(sectionModel?.detail ?? NSMutableAttributedString(string: ""))
    }
    
}
