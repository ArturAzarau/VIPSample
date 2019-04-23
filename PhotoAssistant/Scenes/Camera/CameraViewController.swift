//
//  CameraViewController.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilterCell"

protocol CameraDisplayLogic: class {
    func displayConfigureCamera(viewModel: Camera.Configure.ViewModel)
    func displayShowPreview(viewModel: Camera.ShowPreview.ViewModel)
    func displayUpdateOrientation(viewModel: Camera.UpdateOrientation.ViewModel)
    func displayCaptureImage(viewModel: Camera.CaptureImage.ViewModel)
    func displaySwitchCameras(viewModel: Camera.SwitchCameras.ViewModel)
    func displayToggleFlashlight(viewModel: Camera.ToggleFlashLight.ViewModel)
    func displayDrawFilter(viewModel: Camera.DrawFilter.ViewModel)
    func displayKeepHorizonLine(viewModel:Camera.KeepHorizonLine.ViewModel)
}

final class CameraViewController: UIViewController, CameraDisplayLogic {

    // MARK: - Properties
    
    var interactor: CameraBusinessLogic?
    var router: (NSObjectProtocol & CameraRoutingLogic & CameraDataPassing)?
    
    // MARK: -
    
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CameraInteractor()
        let presenter = CameraPresenter()
        let router = CameraRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            print(scene)
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCamera()
        updateOrientaion()
        keepHorizonLine()
    }
    
    // MARK: - Configure Camera
    
    private func configureCamera() {
        let request = Camera.Configure.Request()
        interactor?.configureCamera(request: request)
    }
    
    // MARK: -
    
    func displayConfigureCamera(viewModel: Camera.Configure.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            showAlert(withTitle: "Error", and: errorMessage)
        } else {
            showPreview()
        }
    }
    
    // MARK: - Show Preview
    
    @IBOutlet var previewView: UIView!
    
    private var previewLayer: CALayer!
    
    private func showPreview() {
        let request = Camera.ShowPreview.Request(size: previewView.bounds)
        interactor?.showPreview(request: request)
    }
    
    // MARK: -
    
    func displayShowPreview(viewModel: Camera.ShowPreview.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            showAlert(withTitle: "Error", and: errorMessage)
        } else if let layer = viewModel.previewLayer{
            previewView.layer.insertSublayer(layer, at: 0)
            previewLayer = layer
        }
    }
    
    // MARK: - UpdateOrienation
    
    @IBOutlet var switchCamerasButton: UIButton!
    @IBOutlet var toggleFlashlightButton: UIButton!
    @IBOutlet var chooseFilterButton: UIButton!
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet var viewTakenPhotoButton: UIButton! {
        didSet {
            viewTakenPhotoButton.layer.cornerRadius = viewTakenPhotoButton.bounds.height / 2
        }
    }
    
    
    private func updateOrientaion() {
        let request = Camera.UpdateOrientation.Request()
        interactor?.updateOrientation(request: request)
    }
    
    // MARK: -
    
    func displayUpdateOrientation(viewModel: Camera.UpdateOrientation.ViewModel) {
        let angle = viewModel.angle
        UIView.animate(withDuration: 0.3) {
            self.switchCamerasButton.transform = CGAffineTransform(rotationAngle: angle)
            self.toggleFlashlightButton.transform = CGAffineTransform(rotationAngle: angle)
            self.chooseFilterButton.transform = CGAffineTransform(rotationAngle: angle)
            self.takePhotoButton.transform = CGAffineTransform(rotationAngle: angle)
            self.viewTakenPhotoButton.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    // MARK: - Capture Image
    
    @IBAction func captureImage(_ sender: UIButton) {
        let request = Camera.CaptureImage.Request()
        interactor?.captureImage(request: request)
    }
    
    
    func displayCaptureImage(viewModel: Camera.CaptureImage.ViewModel) {
        if let image = viewModel.image {
            viewTakenPhotoButton.setImage(image, for: .normal)
        } else if let errorMessage = viewModel.errorMessage {
            showAlert(withTitle: "Error", and: errorMessage)
        }
    }
    
    // MARK: - Switch Cameras
    
    @IBAction func switchCameras(_ sender: UIButton) {
        let request = Camera.SwitchCameras.Request()
        interactor?.switchCameras(request: request)
    }
    
    func displaySwitchCameras(viewModel: Camera.SwitchCameras.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            showAlert(withTitle: "Error", and: errorMessage)
        }
    }
    
    // MARK: - Toggle Flashlight
    
    @IBAction func toggleFlashLight(_ sender: UIButton) {
        let request = Camera.ToggleFlashLight.Request()
        interactor?.toggleFlashlight(request: request)
    }
    
    func displayToggleFlashlight(viewModel: Camera.ToggleFlashLight.ViewModel) {
        toggleFlashlightButton.setImage(viewModel.image, for: .normal)
    }
    
    // MARK: - Collection View
    
    @IBOutlet var filtersCollectionView: FiltersCollectionVIew!
    
    @IBAction func showAndHideFilters(_ sender: UIButton) {
        showAndHideFilters()
    }
    
    private func showAndHideFilters() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            if let weakSelf = self {
                weakSelf.filtersCollectionView.isHidden = !weakSelf.filtersCollectionView.isHidden
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        filtersCollectionView.isHidden = true
    }
    
    // MARK: - Draw Filter
    
    @IBOutlet var filterView: UIImageView!
    @IBOutlet var topFilterViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomFilterViewConstraint: NSLayoutConstraint!
    
    func displayDrawFilter(viewModel: Camera.DrawFilter.ViewModel) {
        filterView.image = viewModel.image
    }
    
    // MARK: - Keep Horizon Line
    
    @IBOutlet var horizonLine: HorizonView!
    
    private func keepHorizonLine() {
        let request = Camera.KeepHorizonLine.Request()
        interactor?.keepHorizonLine(request: request)
    }
    
    func displayKeepHorizonLine(viewModel: Camera.KeepHorizonLine.ViewModel) {
        let rotationAngle = viewModel.rotationAngle
        horizonLine.transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
        horizonLine.strokeColor = viewModel.strokeColor
        horizonLine.setNeedsDisplay()
    }
}

extension CameraViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FilterCell else {
            fatalError("Cannot deque a filter cell")
        }
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.yellow.cgColor
        cell.layer.borderWidth = 1
        let width: CGFloat = indexPath.item == 2 ? cell.bounds.size.height / ((1 + sqrt(5)) / 2) : cell.bounds.size.width
        cell.filterImageView.image = interactor?.filterForItem(item: indexPath.item, size: CGSize(width: width, height: cell.bounds.size.height))
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

extension CameraViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size.width / 4
        return CGSize(width: size, height: size)
    }
}

extension CameraViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAndHideFilters()
        let item = indexPath.item
        let heightToSubtract = view.bounds.size.width * ((1 + sqrt(5))/2)
        let unnacesseryHight = (view.bounds.size.height - heightToSubtract) / 2
        if item == 2 {
            
            bottomFilterViewConstraint.constant = -unnacesseryHight
            topFilterViewConstraint.constant = unnacesseryHight
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                self.previewLayer.position = CGPoint(x: self.previewView.bounds.midX, y: self.previewView.bounds.midY)
                self.previewLayer.bounds = self.previewView.bounds
            }
            
        } else if item != 4 {
            bottomFilterViewConstraint.constant = 0
            topFilterViewConstraint.constant = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })
            self.previewLayer.position = CGPoint(x: self.previewView.bounds.midX, y: self.previewView.bounds.midY)
            
            self.previewLayer.bounds = self.previewView.bounds
        } else {
            
        }
        let request = Camera.DrawFilter.Request(item: item, size: filterView.bounds.size)
        interactor?.drawFilter(request: request)
    }
}
