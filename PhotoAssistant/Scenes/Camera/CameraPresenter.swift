//
//  CameraPresenter.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

protocol CameraPresentationLogic
{
    func presentConfigureCamera(response: Camera.Configure.Response)
    func presentShowPreview(response: Camera.ShowPreview.Response)
    func presentUpdateOrientation(response: Camera.UpdateOrientation.Response)
    func presentCaptureImage(response: Camera.CaptureImage.Response)
    func presentSwitchCameras(response: Camera.SwitchCameras.Response)
    func presentToggleFlashLight(response: Camera.ToggleFlashLight.Response)
    func presentDrawFilter(response: Camera.DrawFilter.Response)
    func presentKeepHorizonLine(response: Camera.KeepHorizonLine.Response)
}

final class CameraPresenter: CameraPresentationLogic
{
    weak var viewController: CameraDisplayLogic?
    
    // MARK: - Present Configure Camera
    func presentConfigureCamera(response: Camera.Configure.Response) {
        let viewModel: Camera.Configure.ViewModel
        let error = response.error
        if let error = error {
            viewModel = Camera.Configure.ViewModel(errorMessage: error.localizedDescription)
        } else {
            viewModel = Camera.Configure.ViewModel(errorMessage: nil)
        }
        viewController?.displayConfigureCamera(viewModel: viewModel)
    }
    
    // MARK: - Present Show Preview
    
    func presentShowPreview(response: Camera.ShowPreview.Response) {
        let viewModel: Camera.ShowPreview.ViewModel
        if let error = response.error {
            viewModel = Camera.ShowPreview.ViewModel(errorMessage: error.localizedDescription, previewLayer: response.previewLayer)
        } else {
            viewModel = Camera.ShowPreview.ViewModel(errorMessage: nil, previewLayer: response.previewLayer)
        }
        viewController?.displayShowPreview(viewModel: viewModel)
    }
    
    // MARK: - Present Update Orientation
    
    func presentUpdateOrientation(response: Camera.UpdateOrientation.Response) {
        let angle = response.angle
        let viewModel = Camera.UpdateOrientation.ViewModel(angle: angle)
        viewController?.displayUpdateOrientation(viewModel: viewModel)
    }
    
    // MARK: - Present Capture Image
    
    func presentCaptureImage(response: Camera.CaptureImage.Response) {
        let viewModel: Camera.CaptureImage.ViewModel
        if let imageData = response.imageData {
            let image = UIImage(data: imageData)
            viewModel = Camera.CaptureImage.ViewModel(image: image, errorMessage: nil)
        } else {
            let errorMessage = response.error?.localizedDescription
            viewModel = Camera.CaptureImage.ViewModel(image: nil, errorMessage: errorMessage)
        }
        viewController?.displayCaptureImage(viewModel: viewModel)
    }
    
    // MARK: - Present Switch Cameras
    
    func presentSwitchCameras(response: Camera.SwitchCameras.Response) {
        let viewModel: Camera.SwitchCameras.ViewModel
        if let error = response.error {
            viewModel = Camera.SwitchCameras.ViewModel(errorMessage: error.localizedDescription)
        } else {
            viewModel = Camera.SwitchCameras.ViewModel(errorMessage: nil)
        }
        viewController?.displaySwitchCameras(viewModel: viewModel)
    }
    
    // MARK: - Present Toggle Flashlight
    
    func presentToggleFlashLight(response: Camera.ToggleFlashLight.Response) {
        let viewModel: Camera.ToggleFlashLight.ViewModel
        if response.state == .on {
            viewModel = Camera.ToggleFlashLight.ViewModel(image: #imageLiteral(resourceName: "Flashcircled"))
        } else {
            viewModel = Camera.ToggleFlashLight.ViewModel(image: #imageLiteral(resourceName: "Noflash"))
        }
        viewController?.displayToggleFlashlight(viewModel: viewModel)
    }
    
    // MARK: - Present Draw Filter
    
    func presentDrawFilter(response: Camera.DrawFilter.Response) {
        let viewModel = Camera.DrawFilter.ViewModel(image: response.image)
        viewController?.displayDrawFilter(viewModel: viewModel)
    }
    
    // MARK: - Keep Horizon Line
    
    func presentKeepHorizonLine(response: Camera.KeepHorizonLine.Response) {
        let color: UIColor
        let rotationAngle = response.rotation
        if ( (abs(abs(rotationAngle) - .pi) < 0.01  && rotationAngle > 3) || (abs((abs(rotationAngle) - .pi / 2)) < 0.01 && rotationAngle < 1.6)) {
            color = .green
        } else {
            color = .red
        }
        let viewModel = Camera.KeepHorizonLine.ViewModel(rotationAngle: response.rotation, strokeColor: color)
        viewController?.displayKeepHorizonLine(viewModel: viewModel)
    }
}
