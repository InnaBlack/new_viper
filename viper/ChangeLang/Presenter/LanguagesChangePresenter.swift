import UIKit
import RxCocoa
import RxSwift
import SferaBase

struct ProfileLanguage: Codable {
    var id: Int
    var code: String
    var en: String
    var title: String
    var capital: String
    var isChecked: Bool? = false
}

final class LangChoosedViewModel {

    var title: String?
    var code: String?
    var img: UIImage?
    var onTap: ()->Void?
    var onDel: (_ ind: Int)->Void?
    var isMov: Bool

    init(title: String?, img: UIImage?, code: String?, onTap: @escaping ()->Void?, onDel: @escaping (_ ind: Int)->Void?, isMov: Bool = false) {
        self.title = title
        self.img = img
        self.code = code
        self.onTap = onTap
        self.onDel = onDel
        self.isMov = isMov
    }
    
    //Row viewmodel
    convenience init(title: String?, img: UIImage?, code: String?, onDel: @escaping (_ ind: Int)->Void?, isMov: Bool) {
        self.init(title: title,
                  img: img,
                  code: code,
                  onTap: {},
                  onDel: onDel,
                  isMov: true)
    }

    class func makeViewModelItems(items: [ProfileLanguage], onDel: @escaping (_ ind: Int)->Void?)  -> [LangChoosedViewModel] {
        return items.map { lang -> LangChoosedViewModel in
            return LangChoosedViewModel(title: lang.title,
                                        img: UIImage(named: "double_line"),
                                        code: lang.code,
                                        onDel: { ind in
                                            onDel(ind)
                                        },
                                        isMov: false)
        }
    }
}

extension LangChoosedViewModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }

    static func ==(lhs: LangChoosedViewModel, rhs: LangChoosedViewModel) -> Bool {
        return lhs.code == rhs.code
    }
}

class LanguagesChangePresenter {
    private let disposeBag = DisposeBag()
    private var viewModelItems = [LangChoosedViewModel]()
    weak var view: LanguagesChangeViewInput!
    var interactor: LanguagesChangeInteractorInput!
    var router: LanguagesChangeRouter!
    var textManager: LanguagesChangeTextManagerProtocol!
    var currentProfile: Profile
    weak var delegate: LanguagesChangePresenterDelegate?
    var languagesChangeTextManager: LanguagesChangeTextManagerProtocol!
    var languageChangeChoosedTableManager: LanguageChangeChoosedTableManagerProtocol!
    
    init(profile: Profile) {
        self.currentProfile = profile
        BaseTextManager.onLanguageChanged.bind {[weak self] in
            self?.view.updateTexts()
        }.disposed(by: self.disposeBag)
    }
}

extension LanguagesChangePresenter: LanguagesChangePresenterProtocol {

    func getTextManager() -> LanguagesChangeTextManagerProtocol { self.textManager }
    
    func viewDidLoad() {
        guard let languagesObtainer = self.interactor?.obtainLanguages(profile: self.currentProfile) else { return }
        languagesObtainer
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] langs in
                guard let strongSelf = self else { return }
                strongSelf.processing(newItems: langs)
            },onError: { [weak self] error in
                guard let strongSelf = self,
                      let serror = error as? SError else { return }
                strongSelf.view.showError(with: serror.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func saveActionCalled() {
        guard let profileUpdater = self.interactor.saveLanguageListProfile(profile: currentProfile) else {
            return
        }
        profileUpdater.observeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let strongSelf = self,
                      let profile = self?.currentProfile else { return }
                self?.delegate?.updateLanguage(with: profile)
                self?.router.popViewController()
            } onError: { [weak self] error in
                guard let strongSelf = self,
                      let serror = error as? SError else { return }
                strongSelf.view.showError(with: serror.localizedDescription)
            }.disposed(by: disposeBag)
    }

    func searchLang(query: String) {
        guard let searchLangugue = self.interactor?.obtainLanguages(profile: self.currentProfile) else { return }

        searchLangugue
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onSuccess: { [weak self] lang in
                self?.addLang(newItems: lang)
            }, onError: { [weak self] error in
                self?.addLang(newItems: [])
            })
            .disposed(by: disposeBag)
    }
    
    private func processing(newItems: [ProfileLanguage]) {
        viewModelItems.append(contentsOf: makeViewModelItemsWithDelete(newItems: newItems))
        languageChangeChoosedTableManager.setModelItems(viewModelItems)
    }

    private func makeViewModelItemsWithDelete(newItems:  [ProfileLanguage]) -> [LangChoosedViewModel]{
        return LangChoosedViewModel.makeViewModelItems(items: newItems,
                                                onDel: { ind in
                                                   self.removeLang(ind: ind)
                                                })
    }

    func addLang(newItems: [ProfileLanguage]) {
        viewModelItems =  Array(Set(makeViewModelItemsWithDelete(newItems: newItems))
                                    .union(viewModelItems))
        self.currentProfile.language?.removeAll()
        viewModelItems.forEach { viewModel in
            if let code = viewModel.code {
                self.currentProfile.language?.append(code)
            }
        }
        languageChangeChoosedTableManager.setModelItems(viewModelItems)
    }
    
    
    func itemTapped() {
        self.router.showLang(profile: self.currentProfile, delegate: self)
    }

    private func removeLang(ind: Int) {
        self.currentProfile.language = self.currentProfile.language?.filter(){$0 != viewModelItems[ind].code}
        viewModelItems.remove(at: ind)
        languageChangeChoosedTableManager.setModelItems(viewModelItems)
    }
}

