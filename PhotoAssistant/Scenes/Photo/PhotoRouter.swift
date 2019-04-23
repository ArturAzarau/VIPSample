//
//  PhotoRouter.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 03.04.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

@objc protocol PhotoRoutingLogic {
}

protocol PhotoDataPassing {
    var dataStore: PhotoDataStore? { get }
}

final class PhotoRouter: NSObject, PhotoRoutingLogic, PhotoDataPassing {
    weak var viewController: PhotoViewController?
    var dataStore: PhotoDataStore?
}
