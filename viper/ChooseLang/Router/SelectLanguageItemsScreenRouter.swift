import UIKit 

class SelectLanguageItemsScreenRouter {
    weak var view: UIViewController!
    
    func routeBack() {
        self.view.dismiss(animated: false, completion: nil)
    }
}
