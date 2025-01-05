//
//  TagCollectionViewCell.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import UIKit
import SwiftUI

class TagCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TagCollectionViewCell"
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = UIColor(Color.tagTextColor)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tag: Tag) {
        label.text = tag.name
        contentView.backgroundColor = UIColor(Color(hex: tag.color))
    }
}
