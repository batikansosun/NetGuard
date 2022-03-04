//
//  RequestListCell.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import UIKit

final class RequestListCell: UITableViewCell {
    static let identifier = "IdentifierRequestListCell"
    private lazy var labelMethod: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.layer.borderWidth = 1
        l.layer.cornerRadius = 8
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    private lazy var labelHTTPCode: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.layer.borderWidth = 1
        l.layer.cornerRadius = 8
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    private lazy var labelUrl: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.textAlignment = .left
        l.numberOfLines = 4
        l.lineBreakMode = .byCharWrapping
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .black
        return l
    }()
    
    private lazy var labelDate: UILabel = {
        let l = UILabel(forAutoLayout: true)
        l.textAlignment = .left
        l.numberOfLines = 2
        l.font = .systemFont(ofSize: 10, weight: .regular)
        l.textColor = .gray
        return l
    }()
    
    private lazy var viewSeperator: UIView = {
        let v = UIView(autoLayout: true)
        v.backgroundColor = UIColor.lightGray
        return v
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
    
    private func adjustLayout(){
        accessoryType = .disclosureIndicator
        backgroundColor = .clear
        contentView.addSubview(labelUrl)
        contentView.addSubview(labelDate)
        contentView.addSubview(labelMethod)
        contentView.addSubview(labelHTTPCode)
        contentView.addSubview(viewSeperator)
        
        labelHTTPCode.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        labelHTTPCode.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        labelHTTPCode.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        labelMethod.topAnchor.constraint(equalTo: labelHTTPCode.bottomAnchor, constant: 3).isActive = true
        labelMethod.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        labelMethod.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        labelUrl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        labelUrl.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -3).isActive = true
        labelUrl.leftAnchor.constraint(equalTo: labelMethod.rightAnchor, constant: 10).isActive = true
        labelUrl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        labelDate.topAnchor.constraint(equalTo: labelMethod.bottomAnchor, constant: 1).isActive = true
        labelDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        labelDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        labelDate.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        viewSeperator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        viewSeperator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 32).isActive = true
        viewSeperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        viewSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(1.0)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-separatorHeight + 6 , width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor.lightGray
    }
    
    func loadCell(model:RequestModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd HH:mm:ss"
        if let url = URL(string: model.url){
            let hostAndHttpScheme = (url.scheme ?? "http") + "://" + (url.host ?? "")
            let urlAttrStr = NSMutableAttributedString().fontBoldGray15(hostAndHttpScheme + " \n")
            urlAttrStr.append(NSMutableAttributedString().font14(url.path + "\n"))
            labelUrl.attributedText = urlAttrStr
        }
        
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
