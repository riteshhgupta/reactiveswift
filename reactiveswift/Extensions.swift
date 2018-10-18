//
//  Extensions.swift
//  reactiveswift
//
//  Created by Ritesh Gupta on 15/10/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit
import RGListKit
import ProtoKit
import ReactiveSwift
import Result

extension Reactive where Base: UIButton {

    var didTapSignal: Signal<Void, NoError> {
        return controlEvents(.touchUpInside)
            .toVoid()
    }
}

extension Signal where Error == NoError {

    func toVoid() -> Signal<Void, NoError> {
        return map { _ in () }
    }
}

extension SignalProducer where Error == NoError {

    func toVoid() -> SignalProducer<Void, NoError> {
        return map { _ in () }
    }
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }

    func applyRoundedCorners() {
        DispatchQueue.main.async {
            let view = self
            let layer = view.layer
            layer.cornerRadius = view.frame.height/2.0
            layer.masksToBounds = true
        }
    }
}

extension ListableView {

    func register<Cell: Nibable & Describable>(_ cellType: Cell.Type) {
        registerItem(
            with: cellType.nib,
            for: cellType.typeName
        )
    }
}

extension MutableProperty {

    func producer<T>(asType: T.Type) -> SignalProducer<T, NoError> {
        return producer
            .map { $0 as? T }
            .skipNil()
    }
}

extension SignalProducer {
    
    func bind<U>(_ closure: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
        return flatMap(.latest, { closure($0) })
    }
}

extension Signal {
    
    func bind<U>(_ transform: @escaping (Value) -> Signal<U, Error>) -> Signal<U, Error> {
        return flatMap(.latest, transform)
    }
}
