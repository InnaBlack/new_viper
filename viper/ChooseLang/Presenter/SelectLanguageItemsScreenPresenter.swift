import RxSwift
import RxCocoa
import SferaBase

protocol SelectLanguageItemsDelegate: AnyObject {
    func selectLang(lang: ProfileLanguage)
}

class SelectLanguageItemsScreenPresenter {
    private let disposeBag = DisposeBag()
    weak var view: SelectLanguageItemsScreenViewInput!
    var interactor: SelectLanguageItemsScreenInteractorInput!
    var router: SelectLanguageItemsScreenRouter!
    var textManager: SelectLanguageItemsScreenTextManagerProtocol!
    var selectLanguageItemsTableManager: SelectLanguageItemsTableManagerProtocol!
    
    private weak var delegate: LanguagesChangePresenterProtocol?

    private let forLang: Bool
    private var items = [ProfileLanguage]()

    init(forLang: Bool = true,
         delegate: LanguagesChangePresenterProtocol?) {
        
        self.delegate = delegate
        self.forLang = forLang
        
        BaseTextManager.onLanguageChanged.bind { [weak self] in
            self?.languageChanged()
        }.disposed(by: self.disposeBag)
    }
}

extension SelectLanguageItemsScreenPresenter: SelectLanguageItemsScreenPresenterProtocol {

    func viewDidLoad() {
      //  view?.setTitle(title: textManager.selectCountry)
    }
    
    private func languageChanged() {
        self.view.updateTexts()
    }
    
    func closePressed() {
        router.routeBack()
    }
    
    func searchForLang(query: String? = nil) {
        guard let searchLang = interactor.searchLang(query: query ?? "") else { return }
           
        searchLang
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onSuccess: { [weak self] lang in
                self?.updateItems(newItems: lang)
            }, onError: { [weak self] error in
                self?.updateItems(newItems: [])
            })
            .disposed(by: disposeBag)
    }
    
    private func updateItems(newItems: [ProfileLanguage]) {
        items = newItems
        selectLanguageItemsTableManager.setItems(items)
    }
}

extension SelectLanguageItemsScreenPresenter: SelectLanguageItemsTableManagerDelegate {
    func itemTapped(index: Int) {
        let items = self.items
        let item = items[index]
        delegate?.addLang(newItems: [item])

        self.closePressed()
    }
}
