//
//  RequestListCell.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import UIKit

class RequestListCell: UITableViewCell {
    
    static let identifier = "IdentifierRequestListCell"
    
    lazy var labelMethod: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.layer.borderWidth = 1
        l.layer.cornerRadius = 8
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    lazy var labelHTTPCode: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.layer.borderWidth = 1
        l.layer.cornerRadius = 8
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    lazy var labelUrl: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.textAlignment = .left
        l.numberOfLines = 2
        l.lineBreakMode = .byTruncatingTail
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .black
        return l
    }()
    
    lazy var labelDate: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.textAlignment = .center
        l.numberOfLines = 1
        l.font = .systemFont(ofSize: 10, weight: .regular)
        l.textColor = .gray
        return l
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        adjustLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustLayout(){
        accessoryType = .disclosureIndicator
        backgroundColor = .clear
        contentView.addSubview(labelUrl)
        contentView.addSubview(labelDate)
        contentView.addSubview(labelMethod)
        contentView.addSubview(labelHTTPCode)
        
        labelHTTPCode.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        labelHTTPCode.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        labelHTTPCode.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        labelMethod.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        labelMethod.bottomAnchor.constraint(equalTo: labelDate.topAnchor, constant: -2).isActive = true
        labelMethod.leftAnchor.constraint(equalTo: labelHTTPCode.rightAnchor, constant: 10).isActive = true
        labelMethod.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        labelUrl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        labelUrl.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10).isActive = true
        labelUrl.leftAnchor.constraint(equalTo: labelMethod.rightAnchor, constant: 10).isActive = true
        labelUrl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        labelDate.topAnchor.constraint(equalTo: labelHTTPCode.bottomAnchor, constant: 1).isActive = true
        labelDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        labelDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        labelDate.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(1.0)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-separatorHeight + 6 , width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor.lightGray
        self.addSubview(additionalSeparator)
    }
    
    func loadCell(model:RequestModel){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd HH:mm:ss"
        labelUrl.text = model.url
        labelMethod.text = model.method
        labelHTTPCode.text = String(model.code)
        labelDate.text = dateFormatter.string(from: model.date)
        var color: UIColor = .generic
        switch model.code {
        case 200..<300:
            color = .successful
        case 300..<400:
            color = .redirection
        case 400..<500:
            color = .clientError
        case 500..<600:
            color = .serverError
        default:
            color = .generic
        }
        labelHTTPCode.textColor = color
        labelMethod.textColor = labelHTTPCode.textColor
        labelMethod.layer.borderColor = labelHTTPCode.textColor.cgColor
        labelHTTPCode.layer.borderColor = labelHTTPCode.textColor.cgColor
    }
}
