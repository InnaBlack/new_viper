import RxCocoa
import RxSwift

protocol LanguagesChangePresenterProtocol: AnyObject {
    func viewDidLoad()

    var languageChangeChoosedTableManager: LanguageChangeChoosedTableManagerProtocol! { get }
    var currentProfile: Profile { get }
    
    func getTextManager() -> LanguagesChangeTextManagerProtocol
    func saveActionCalled()
    func addLang(newItems: [ProfileLanguage]) 
    func searchLang(query: String)
    func itemTapped()
}

protocol LanguagesChangePresenterDelegate: AnyObject {
    func updateLanguage(with profile: Profile)
}
