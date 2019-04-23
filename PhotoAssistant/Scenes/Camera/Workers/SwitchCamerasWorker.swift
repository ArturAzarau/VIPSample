//
//  SwitchCamerasWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 01.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import Foundation
import AVFoundation

final class SwitchCamerasWorker {
    
    // MARk: - Properties
    
    private let configuration: CameraConfigurator
    
    // MARK: - Object Life Cycle
    
    init(configuration: CameraConfigurator) {
        self.configuration = configuration
    }
    
    // MARK: - Methods
    
    func switchCameras() throws {
        guard let currentCameraPosition = configuration.currentCameraPosition, let captureSession = configuration.captureSession, captureSession.isRunning else { throw CameraError.captureSessionIsMissing }
        
        
        func switchToFrontCamera() throws {
            let inputs = captureSession.inputs
            guard let rearCameraInput = configuration.rearCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = configuration.frontCamera else { throw CameraError.invalidOperation }
            
            configuration.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(configuration.frontCameraInput!) {
                captureSession.addInput(configuration.frontCameraInput!)
                
                configuration.currentCameraPosition = .front
            }
                
            else { throw CameraError.invalidOperation }
        }
        
        func switchToRearCamera() throws {
            let inputs = captureSession.inputs
            guard let frontCameraInput = configuration.frontCameraInput, inputs.contains(frontCameraInput),
                let rearCamera = configuration.rearCamera else { throw CameraError.invalidOperation }
            
            configuration.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(configuration.rearCameraInput!) {
                captureSession.addInput(configuration.rearCameraInput!)
                
                configuration.currentCameraPosition = .rear
            }
                
            else { throw CameraError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front: try switchToRearCamera()
        case .rear: try switchToFrontCamera()
        }
    }
}
