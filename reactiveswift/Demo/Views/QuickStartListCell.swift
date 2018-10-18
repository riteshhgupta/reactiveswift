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

final class QuickStartListCellModel: ListViewItemModel {

    let list = MutableProperty<[QuickStartCellModel]?>(nil)
    let didSelectItem = MutableProperty<Void?>(nil)

    let id: String = UUID().uuidString
    let reuseIdentifier: String = QuickStartListCell.typeName
    let height: CGFloat = 200.0
    let width: CGFloat = UIScreen.main.bounds.width

    init(list: [QuickStartCellModel]) {
        self.list.value = list
    }

    var listViewHolder: HomeListViewHolder! {
        didSet {
            listViewHolder.reactive.sections <~ list
                .producer
                .skipNil()
                .map { [SectionModel(id: "QuickStartList", cells: $0)] }
                .delay(0.1, on: QueueScheduler.main)

            didSelectItem <~ listViewHolder
                .didSelectSignal
                .toVoid()
        }
    }
}

class QuickStartListCell: UICollectionViewCell, ReactiveListViewItemModelInjectable {

    let itemModel = MutableProperty<ListViewItemModel?>(nil)
    fileprivate var _listViewHolder: HomeListViewHolder!

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(QuickStartCell.self)
            _listViewHolder = HomeListViewHolder(listView: collectionView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        reactive.setupView <~ itemModel.producer(asType: QuickStartListCellModel.self)
    }
}

extension Reactive where Base: QuickStartListCell {

    var setupView: BindingTarget<QuickStartListCellModel> {
        return makeBindingTarget { cell, model in
            model.listViewHolder = cell._listViewHolder
        }
    }
}
