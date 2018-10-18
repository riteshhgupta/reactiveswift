//
//  HomeViewModel.swift
//  reactiveswiftdemo
//
//  Created by Ritesh Gupta on 18/10/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit
import RGListKit
import ReactiveSwift
import Result
import ProtoKit
import SVProgressHUD


class HomeViewModel {

    // datasource
    fileprivate let sections = MutableProperty<[SectionModel]?>(nil)

    // lists of data
    fileprivate let tagList = MutableProperty<[TagListCellModel]>([])
    fileprivate let quickStartList = MutableProperty<[QuickStartListCellModel]>([])
    fileprivate let templateList = MutableProperty<[TemplateCellModel]>([])

    // apis
    fileprivate let tagListAPIAction = Action(execute: MockAPI.tagListMockAPI)
    fileprivate let quickStartListAPIAction = Action(execute: MockAPI.quickStartListMockAPI)
    fileprivate let templateListAPIAction = Action(execute: MockAPI.templateListMockAPI)

    var listViewHolder: HomeListViewHolder! {
        didSet {
            listViewHolder.reactive.sections <~ sections.producer.skipNil().observe(on: QueueScheduler.main)
        }
    }

    init() {
        // linking lists with their corresponding apis
        tagList <~ tagListAPIAction.values
        quickStartList <~ quickStartListAPIAction.values
        templateList <~ templateListAPIAction.values

        // update datasource partially
        reactive.updateList <~ SignalProducer
            .merge([
                tagList.producer.toVoid(),
                quickStartList.producer.toVoid(),
                templateList.producer.toVoid()
                ])

        // update datasource at once
        //        reactive.updateList <~ SignalProducer
        //            .zip([
        //                tagList.producer.toVoid(),
        //                quickStartList.producer.toVoid(),
        //                templateList.producer.toVoid()
        //                ])
        //            .toVoid()
    }

    // hide loader at the end
    var shouldShowLoader: SignalProducer<Bool, NoError> {
        let hasError = error.producer.toVoid().map { false }
        let isAPIExecuting = SignalProducer
            .zip([
                tagListAPIAction.isExecuting.producer,
                quickStartListAPIAction.isExecuting.producer,
                templateListAPIAction.isExecuting.producer,
                ])
            .map { $0.reduce(false, { $0 || $1 }) }
        return SignalProducer
            .merge([
                isAPIExecuting,
                hasError
                ])
    }

    // hide loader immediately after first api
    //    var shouldShowLoader: SignalProducer<Bool, NoError> {
    //        let hasError = error.producer.toVoid().map { false }
    //        let isAPIExecuting = SignalProducer
    //            .merge([
    //                tagListAPIAction.isExecuting.producer,
    //                quickStartListAPIAction.isExecuting.producer,
    //                templateListAPIAction.isExecuting.producer,
    //                ])
    //        return SignalProducer
    //            .merge([
    //                isAPIExecuting,
    //                hasError
    //                ])
    //    }

    var error: SignalProducer<OverError, NoError> {
        return SignalProducer
            .merge([
                tagListAPIAction.errors.producer,
                quickStartListAPIAction.errors.producer,
                templateListAPIAction.errors.producer
                ])
    }

    var didSelectItem: SignalProducer<Void, NoError> {
        return SignalProducer.merge([
            listViewHolder.didSelectSignal.producer.toVoid(),
            quickStartList.producer.bind { SignalProducer.merge($0.map { $0.didSelectItem.producer.skipNil() }) },
            tagList.producer.bind { SignalProducer.merge($0.map { $0.didSelectItem.producer.skipNil() }) }
            ])
    }
}

extension Reactive where Base: HomeViewModel {

    var fetchData: BindingTarget<Void> {
        return makeBindingTarget { viewModel, _ in
            viewModel.tagListAPIAction.apply().start()
            viewModel.quickStartListAPIAction.apply().start()
            viewModel.templateListAPIAction.apply().start()
        }
    }

    var updateList: BindingTarget<Void> {
        return makeBindingTarget { viewModel, _ in
            let sections: [SectionModel] = [
                SectionModel(id: "TagList", cells: viewModel.tagList.value),
                SectionModel(id: "QuickStartList", cells: viewModel.quickStartList.value),
                SectionModel(id: "TemplateList", cells: viewModel.templateList.value)
            ]
            viewModel.sections.value = sections
        }
    }
}

extension HomeViewModel: ReactiveExtensionsProvider {}
