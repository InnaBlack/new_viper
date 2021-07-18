import RxSwift

protocol LanguagesChangeInteractorInput: AnyObject {

    func saveLanguageListProfile(profile: Profile) -> Single<Profile>?
    func obtainLanguages(profile: Profile) -> Single<[ProfileLanguage]>?

}
