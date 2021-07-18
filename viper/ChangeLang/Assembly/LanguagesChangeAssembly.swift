import UIKit

class LanguagesChangeAssembly {

    static func assemble(networkService: ProfileNetworkServiceProtocol) -> UIViewController {
        let view = LanguagesChangeViewController()
        let router = LanguagesChangeRouter()
        let presenter = LanguagesChangePresenter(profile: profile)
        let interactor = LanguagesChangeInteractor()
        interactor.networkService = networkService
        let textManager = LanguagesChangeTextManager()
        let languageChangeChoosedTableManager = LanguageChangeChoosedTableManager(withDelegate: presenter)

        view.presenter = presenter
        presenter.view = view
        presenter.delegate = delegate
        presenter.interactor = interactor
        presenter.textManager = textManager
        presenter.languageChangeChoosedTableManager = languageChangeChoosedTableManager
        presenter.router = router
        router.view = view

        return view
    }
}
