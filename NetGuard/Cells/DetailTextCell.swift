//
//  DetailTextCell.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import UIKit

class DetailTextCell: UITableViewCell {
    static let identifier = "IdentifierDetailTextCell"
    
    lazy var textViewDetail: UITextView = {
        let t = UITextView(forAutoLayout: true)
        t.textAlignment = .left
        t.font = .systemFont(ofSize: 14, weight: .regular)
        t.textColor = .black
        t.showsVerticalScrollIndicator = false
        t.showsHorizontalScrollIndicator = false
        t.isScrollEnabled = false
        t.isEditable = false
        return t
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        textViewDetail.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        adjustLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadcell(section:SectionModel) {
        textViewDetail.attributedText = section.detail
    }
    

    func adjustLayout(){
        backgroundColor = .clear
        contentView.addSubview(textViewDetail)
        textViewDetail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        textViewDetail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        textViewDetail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        textViewDetail.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
    }
}
