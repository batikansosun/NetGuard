//
//  DetailTextCell.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import UIKit

final class DetailTextCell: UITableViewCell {
    static let identifier = "IdentifierDetailTextCell"
    private static let readMoreLength = 300
    private lazy var textViewDetail: UITextView = {
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
        if section.detail.length > DetailTextCell.readMoreLength {
            let substr = section.detail.attributedSubstring(from: NSRange(location: 0, length: DetailTextCell.readMoreLength))
            let mutableString = NSMutableAttributedString(attributedString: substr)
            mutableString.append(NSAttributedString(string: "   \nTap to detail buton for show all details", attributes: [NSAttributedString.Key.foregroundColor : UIColor.generic, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold)]))
            textViewDetail.attributedText = mutableString
        } else {
            let cleanStr = section.detail.string.replacingOccurrences(of: " \n", with: "")
            textViewDetail.attributedText = cleanStr.count > 0 ? section.detail : NSAttributedString(string: NSLocalizedString("Empty", comment: ""))
        }
    }
    
    private func adjustLayout(){
        backgroundColor = .clear
        contentView.addSubview(textViewDetail)
        textViewDetail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        textViewDetail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        textViewDetail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        textViewDetail.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
    }
}
