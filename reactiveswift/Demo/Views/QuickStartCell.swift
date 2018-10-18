//
//  QuickStartCell.swift
//  reactiveswiftdemo
//
//  Created by Ritesh Gupta on 17/10/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import UIKit
import RGListKit
import ReactiveSwift

struct TemplateCellModel: ListViewItemModel {

    let id: String = UUID().uuidString
    let reuseIdentifier: String = QuickStartCell.typeName
    let height: CGFloat = 200.0
    let width: CGFloat = 160.0
}

struct QuickStartCellModel: ListViewItemModel {

    let id: String = UUID().uuidString
    let reuseIdentifier: String = QuickStartCell.typeName
    let height: CGFloat = 200.0
    let width: CGFloat = 200.0
}

class QuickStartCell: UICollectionViewCell {}
