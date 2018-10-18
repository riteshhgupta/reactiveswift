//
//  TagCollectionViewCell.swift
//  reactiveswift
//
//  Created by Ritesh Gupta on 15/10/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import UIKit
import RGListKit
import ReactiveSwift

struct TagCellModel: ListViewItemModel {

    let title: String
    let backgroundColor: UIColor = .blue

    let id: String = UUID().uuidString
    let reuseIdentifier: String = TagCell.typeName
    let height: CGFloat = 44.0
    let width: CGFloat = 100.0
}

class TagCell: UICollectionViewCell, ReactiveListViewItemModelInjectable {

    let itemModel = MutableProperty<ListViewItemModel?>(nil)

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleLabelBackgroundView: UIView! {
        didSet {
            titleLabelBackgroundView.applyRoundedCorners()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let model = itemModel.producer(asType: TagCellModel.self)
        titleLabel.reactive.text <~ model.map { $0.title }
        titleLabelBackgroundView.reactive.backgroundColor <~ model.map { $0.backgroundColor }
    }
}
