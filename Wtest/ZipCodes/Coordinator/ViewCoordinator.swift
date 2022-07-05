//
//  ViewCoordinator.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import UIKit

class ViewCoordinator: Coordinator {
    
    // MARK: - Declaration and init

    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    func start() {
        let viewController = ViewController.instantiate(storyboardName: .main)
        viewController.coordinator = self
        viewController.viewModel = ViewModel(coreData: ZipCodeCoreData())
        navigationController.pushViewController(viewController, animated: true)
    }
}
