//
//  CaptureImageWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 01.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit
import AVFoundation

final class CaptureImageWorker: NSObject {
    
    // MARK: - Properties
    
    private let configuration: CameraConfigurator
    private var completionBlock: ((Data?, Error?) -> Void)?
    
    // MARK: - Object Life Cycle
    
    init(configuration: CameraConfigurator) {
        self.configuration = configuration
    }
    
    // MARK: - Methods
    
    func captureImage(completion: @escaping (Data?, Error?) -> Void) {
        guard let captureSession = configuration.captureSession, captureSession.isRunning else {
            completion(nil,CameraError.captureSessionIsMissing)
            return
        }
        let settings = AVCapturePhotoSettings()
        settings.flashMode = configuration.flashMode
        
        configuration.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.completionBlock = completion
    }
}

extension CaptureImageWorker: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            completionBlock?(nil, error)
        } else if let data = photo.fileDataRepresentation() {
            completionBlock?(data,nil)
        } else {
            completionBlock?(nil,CameraError.unknown)
        }
    }
}
