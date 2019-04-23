//
//  ToggleFlashlightWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 01.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import AVFoundation

final class ToggleFlashlightWorker {
    
    // MARK: - Properties
    
    private let configuration: CameraConfigurator
    
    // MARK: - Object Life Cycle
    
    init(configuration: CameraConfigurator) {
        self.configuration = configuration
    }
    
    // MARK: - Methods
    
    func toggleFlashLight() -> AVCaptureDevice.FlashMode {
        if configuration.flashMode == .on {
            configuration.flashMode = .off
            return .off
        } else {
            configuration.flashMode = .on
            return .on
        }

    }
}
