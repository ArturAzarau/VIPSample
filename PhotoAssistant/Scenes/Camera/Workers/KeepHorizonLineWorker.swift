//
//  KeepHorizonLineWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 01.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import CoreMotion
import CoreGraphics

final class KeepHorizonLineWorker {
    
    // MARK: - Properties
    
    let manager: CMMotionManager
    
    // MARK: - Object Life Cycle
    
    init() {
        manager = CMMotionManager()
    }
    func keepHorizonLine(completion: @escaping (Double) -> ()) {
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {(data, error) in
                if let gravity = data?.gravity {
                    let rotation = atan2(gravity.x, gravity.y)
                    completion(rotation)
                }
            })
        }
    }
    
    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
