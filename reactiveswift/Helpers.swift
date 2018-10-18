//
//  Helpers.swift
//  reactiveswiftdemo
//
//  Created by Ritesh Gupta on 17/10/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import RGListKit

final class MockAPI {

    static func tagListMockAPI() -> SignalProducer<[TagListCellModel], OverError> {
        return SignalProducer { observer, _ in
            let tagModelList = ["One", "Two", "Three", "Four", "Five"].map { TagCellModel(title: $0)}
            let tagListModel = TagListCellModel(list: tagModelList)
            observer.send(value: [tagListModel])
            observer.sendCompleted()
            }
            .delay(2, on: QueueScheduler.main)
    }

    static func quickStartListMockAPI() -> SignalProducer<[QuickStartListCellModel], OverError> {
        return SignalProducer { observer, _ in
            let quickStartModelList = (0...10).map { _ in QuickStartCellModel() }
            let quickStartListModel = QuickStartListCellModel(list: quickStartModelList)
            observer.send(value: [quickStartListModel])
            observer.sendCompleted()
            }
            .delay(1, on: QueueScheduler.main)
    }

    static func templateListMockAPI() -> SignalProducer<[TemplateCellModel], OverError> {
        return SignalProducer { observer, _ in
            let quickStartModelList = (0...10).map { _ in TemplateCellModel() }
            observer.send(value: quickStartModelList)
            observer.sendCompleted()
            }
            .delay(3, on: QueueScheduler.main)
    }
}

class HomeListViewHolder: ReactiveDiffableListViewHolder {

    let (didSelectSignal, didSelectObserver) = Signal<IndexPath, NoError>.pipe()
}

extension HomeListViewHolder {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectObserver.send(value: indexPath)
    }
}
