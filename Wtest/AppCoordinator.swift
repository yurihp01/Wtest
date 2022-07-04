//
//  AppCoordinator.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import Foundation

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init() {
        navigationController = UINavigationController()
    }
    
    func start() {
        let childCoordinator = ViewCoordinator(navigationController: navigationController)
        childCoordinator.parentCoordinator = self
        add(childCoordinator)
        childCoordinator.start()
    }
}
