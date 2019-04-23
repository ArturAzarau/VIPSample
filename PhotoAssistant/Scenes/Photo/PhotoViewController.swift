//
//  PhotoViewController.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 03.04.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

protocol PhotoDisplayLogic: class {
    func displayShowPhoto(viewModel:  Photo.ShowPhoto.ViewModel)
}

final class PhotoViewController: UIViewController, PhotoDisplayLogic {

    // MARK: - Properties

    var interactor: PhotoBusinessLogic?
    var router: (NSObjectProtocol & PhotoRoutingLogic & PhotoDataPassing)?
    
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
        let interactor = PhotoInteractor()
        let presenter = PhotoPresenter()
        let router = PhotoRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let request = Photo.ShowPhoto.Request()
        interactor?.showPhoto(request: request)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet var photoImageView: UIImageView!
    
    func displayShowPhoto(viewModel: Photo.ShowPhoto.ViewModel) {
        photoImageView.image = viewModel.image
    }
}
