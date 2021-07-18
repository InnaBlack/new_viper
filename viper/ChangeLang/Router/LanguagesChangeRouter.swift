import UIKit 

class LanguagesChangeRouter {
    weak var view: UIViewController!

    private func makePushViewController(viewController: UIViewController, animated: Bool) {
        if let view = self.view {
            view.navigationController?.pushViewController(viewController, animated: animated)
        }
    }

    private func makePresentViewController(viewController: UIViewController, animated: Bool) {

        if let view = self.view {
            view.navigationController?.present(viewController, animated: animated)
        }
    }

    func popViewController() {
        view.navigationController?.popViewController(animated: true)
    }

    func showLang(profile: Profile, delegate: LanguagesChangePresenterProtocol?) {
        let view = SelectLanguageItemsScreenAssembly.assemble(profile: profile, delegate: delegate)
        makePresentViewController(viewController: view, animated: true)
    }
}
