import UIKit
import RxCocoa

class SelectLanguageItemsScreenAssembly {
    
    enum TypeScreen {
       case view
       case select
    }

    static func assemble(profile: Profile, typeScreen: TypeScreen = .select, delegate: LanguagesChangePresenterProtocol?) -> UIViewController {
        
        let view = SelectLanguageItemsScreenViewController()
        let router = SelectLanguageItemsScreenRouter()
        let presenter = SelectLanguageItemsScreenPresenter(delegate: delegate)
        let interactor = SelectLanguageItemsScreenInteractor()
        let textManager = SelectLanguageItemsScreenTextManager()
        let selectLanguageItemsTableManager = SelectLanguageItemsTableManager(withDelegate: presenter)

        view.presenter = presenter
        interactor.profile = profile
        interactor.typeScreen = typeScreen
        presenter.view = view
        presenter.interactor = interactor
        presenter.textManager = textManager
        presenter.router = router
        presenter.selectLanguageItemsTableManager = selectLanguageItemsTableManager
        router.view = view
        
        return view
    }

}
