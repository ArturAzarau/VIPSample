//
//  CameraRouter.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

@objc protocol CameraRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol CameraDataPassing {
    var dataStore: CameraDataStore? { get }
}

class CameraRouter: NSObject, CameraRoutingLogic, CameraDataPassing {
    
    weak var viewController: CameraViewController?
    var dataStore: CameraDataStore?
    
    // MARK: Routing
    
    @objc func routeToPhoto(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! PhotoViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToPhoto(source: dataStore!, destination: &destinationDS)
        }
    }
    
    func passDataToPhoto(source: CameraDataStore, destination: inout PhotoDataStore) {
        destination.imageData = source.imageData
    }
}
