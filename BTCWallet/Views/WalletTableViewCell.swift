//
//  WalletTableViewCell.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit

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
                    
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalToSystemSpacingBelow: contentView.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            background.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            background.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: background.trailingAnchor, multiplier: 2),
            
            iconImageView.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalTo: background.heightAnchor, multiplier: 2 / 4),
            iconImageView.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1 / 9),
            iconImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: background.leadingAnchor, multiplier: 1.5),
            
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: background.topAnchor, multiplier: 1.5),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: iconImageView.trailingAnchor, multiplier: 1.5),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: iconImageView.trailingAnchor, multiplier: 1.5),
            subTitleLabel.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1 / 1.8),

            amountlabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            background.trailingAnchor.constraint(equalToSystemSpacingAfter: amountlabel.trailingAnchor, multiplier: 1.5)
        ])
    }
    
    public func configure(with wallet: Wallet) {
        subTitleLabel.text = wallet.addrStr // Wallet Address
        amountlabel.text = wallet.balance // Wallet Balance
    }
}
