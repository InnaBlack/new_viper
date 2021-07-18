import RxCocoa
import RxSwift

protocol SelectLanguageItemsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    var selectLanguageItemsTableManager: SelectLanguageItemsTableManagerProtocol! { get }
    var textManager: SelectLanguageItemsScreenTextManagerProtocol! { get }

    func searchForLang(query: String?)
    func closePressed()
    func itemTapped(index: Int)
}
