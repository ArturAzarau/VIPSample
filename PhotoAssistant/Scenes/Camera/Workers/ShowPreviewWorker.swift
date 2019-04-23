//
//  ShowPreviewWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit
import AVFoundation

final class ShowPreviewWorker {
    func showPreview(ofSize size: CGRect,configurator: CameraConfigurator) throws -> AVCaptureVideoPreviewLayer {
        guard let captureSession = configurator.captureSession, captureSession.isRunning else {
            throw CameraError.captureSessionIsMissing
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.masksToBounds = true
        previewLayer.frame = size
        return previewLayer
    }
}
