//
//  UIViewController.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2016 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc open class func vc() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
}
