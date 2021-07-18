//
//  AppCordinator.swift
//  viper
//
//  Created by  inna on 18/07/2021.
//

import Foundation
import UIKit

// MARK: - AppCoordinatorProtocol declaration

protocol AppCoordinatorProtocol: AnyObject {
    func start() -> UIViewController?
    init()
    
}

// MARK: - AppCoordinator implementation

class AppCoordinator: AppCoordinatorProtocol {
    
    static var shared: AppCoordinator = {
        return AppCoordinator()
    }()
    
    weak var delegate: AppInteractorProtocol?
    
    private var disposeBag = DisposeBag()
    
    func start() -> UIViewController? {
        let view: UIViewController

        self.navigationController = UINavigationController()
        let languagesChangeAssembly = LanguagesChangeAssembly.assemble(networkService: delegate.profileNetworkService)
        self.navigationController?.setViewControllers(languagesChangeAssembly)
        
        return view
    }
}

