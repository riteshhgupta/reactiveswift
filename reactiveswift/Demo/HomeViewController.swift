//
//  ViewController.swift
//  reactiveswift
//
//  Created by Ritesh Gupta on 15/10/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import UIKit
import RGListKit
import ReactiveSwift
import Result
import ProtoKit
import SVProgressHUD

class HomeViewController: UIViewController {

    let viewModel = HomeViewModel()

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(TagListCell.self)
            collectionView.register(QuickStartListCell.self)
            collectionView.register(QuickStartCell.self)
            viewModel.listViewHolder = HomeListViewHolder(listView: collectionView)
        }
    }
    
    @IBOutlet var fetchDataButton: UIButton! {
        didSet {
            viewModel.reactive.fetchData <~ fetchDataButton.reactive.didTapSignal
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.reactive.showLoader <~ viewModel.shouldShowLoader
        reactive.showErrorAlert <~ viewModel.error
        reactive.submitAnalyticsEvent <~ fireAnalyticsEvent
    }

    var fireAnalyticsEvent: SignalProducer<AnalyticsEvent, NoError> {
        return SignalProducer.merge([
            fetchDataButton.reactive.didTapSignal.producer.map { .didTapFetchDataButton },
            viewModel.didSelectItem.producer.map { .didSelectItem }
            ])
    }
}

extension Reactive where Base: UIViewController {

    var showErrorAlert: BindingTarget<OverError> {
        return makeBindingTarget { controller, error in
            let alert = UIAlertController(title: "Error", message: "Something went wrong!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

extension Reactive where Base: UIViewController {

    var submitAnalyticsEvent: BindingTarget<AnalyticsEvent> {
        return makeBindingTarget { controller, event in
            // send analytics event
            print(event)
        }
    }
}

extension Reactive where Base: UIView {

    var showLoader: BindingTarget<Bool> {
        return makeBindingTarget { view, show in
            if show {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
