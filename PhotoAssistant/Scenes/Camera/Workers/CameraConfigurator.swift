//
//  CameraConfigurator.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraConfigurator: NSObject {
    // capture session
    fileprivate(set) var captureSession: AVCaptureSession?
    
    // cameras
    fileprivate(set) var frontCamera: AVCaptureDevice?
    fileprivate(set) var rearCamera: AVCaptureDevice?
    
    // device inputs
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    
    // output
    fileprivate(set) var photoOutput: AVCapturePhotoOutput?
    
    // preview
    fileprivate(set) var previewLayer: AVCaptureVideoPreviewLayer?
    
    // properties
    
    var flashMode = AVCaptureDevice.FlashMode.off
}

extension CameraConfigurator {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = session.devices.compactMap {$0}
            guard !cameras.isEmpty else {
                throw CameraError.noCamerasAvailable
            }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else {
                throw CameraError.captureSessionIsMissing
            }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                }
                
                self.currentCameraPosition = .rear
                
            } else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(frontCameraInput!) {
                    captureSession.addInput(frontCameraInput!)
                } else {
                    throw CameraError.inputsAreInvalid
                }
                
                self.currentCameraPosition = .front
                
            } else {
                throw CameraError.noCamerasAvailable
            }
            
            
        }
        
        // TODO: Configure a photo output object to pocess captured images
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])])
            
            if captureSession.canAddOutput(self.photoOutput!) {
                captureSession.addOutput(self.photoOutput!)
            }
            
            captureSession.startRunning()
            
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}
