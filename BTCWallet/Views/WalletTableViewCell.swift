//
//  WalletTableViewCell.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit
import SnapKit

class WalletTableViewCell: UITableViewCell {
    // MARK: - Public properties
    static let identifier = "WalletTableViewCell"
    
    var background = UIView()
    var iconImageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var amountlabel = UILabel()
    
    // MARK: - UITableViewCell Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Private Methods
    private func setStyle() {
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        background.layer.borderWidth = 0.05
        background.layer.borderColor = UIColor.black.cgColor
        background.layer.cornerRadius = 10
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 0.05
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(named: "Bitcoin")
                
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Bitcoin"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        subTitleLabel.numberOfLines = 2
        
        amountlabel.translatesAutoresizingMaskIntoConstraints = false
        amountlabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
    }
            
    private func setLayout() {
        contentView.addSubview(background)
        background.addSubview(iconImageView)
        background.addSubview(titleLabel)
        background.addSubview(subTitleLabel)
        background.addSubview(amountlabel)
        
        // SnapKit
        background.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        })
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(background)
            make.size.equalTo(48)
            make.left.equalTo(background).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(background).inset(10)
            make.left.equalTo(iconImageView.snp.right).offset(10)
        }
                    
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.size.equalTo(CGSize(width: 175, height: 30))
        }
        
        amountlabel.snp.makeConstraints { make in
            make.centerY.equalTo(background)
            make.right.equalTo(background.snp.right).offset(-12)
        }
    }
    
    // Configure view in TableView
    public func configure(with wallet: Wallet) {
        let editedBalance = Double(wallet.balance)
        guard let editedBalance = editedBalance else { return }
        let balance = String(format: "%.1f", editedBalance)
        
        subTitleLabel.text = wallet.address
        amountlabel.text = "\(balance) BTC"
    }
}
