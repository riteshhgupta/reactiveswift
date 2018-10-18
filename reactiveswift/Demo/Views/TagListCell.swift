//
//  TagListCollectionViewCell.swift
//  reactiveswiftdemo
//
//  Created by Ritesh Gupta on 15/10/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import UIKit
import RGListKit
import ReactiveSwift

final class TagListCellModel: ListViewItemModel {

    let list = MutableProperty<[TagCellModel]?>(nil)
    let didSelectItem = MutableProperty<Void?>(nil)

    let id: String = UUID().uuidString
    let reuseIdentifier: String = TagListCell.typeName
    let height: CGFloat = 64.0
    let width: CGFloat = UIScreen.main.bounds.width

    init(list: [TagCellModel]) {
        self.list.value = list
    }

    var listViewHolder: HomeListViewHolder! {
        didSet {
            listViewHolder.reactive.sections <~ list
                .producer
                .skipNil()
                .map { [SectionModel(id: "TagList", cells: $0)] }
                .delay(0.1, on: QueueScheduler.main)

            didSelectItem <~ listViewHolder
                .didSelectSignal
                .toVoid()
        }
    }
}

class TagListCell: UICollectionViewCell, ReactiveListViewItemModelInjectable {

    let itemModel = MutableProperty<ListViewItemModel?>(nil)
    fileprivate var _listViewHolder: HomeListViewHolder!

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(TagCell.self)
            _listViewHolder = HomeListViewHolder(listView: collectionView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        reactive.setupView <~ itemModel.producer(asType: TagListCellModel.self)
    }
}

extension Reactive where Base: TagListCell {

    var setupView: BindingTarget<TagListCellModel> {
        return makeBindingTarget { cell, model in
            model.listViewHolder = cell._listViewHolder
        }
    }
}
