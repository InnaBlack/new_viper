import RxSwift
import SferaBase

class LanguagesChangeInteractor {
    let networkService: ProfileNetworkServiceProtocol?
}

extension LanguagesChangeInteractor: LanguagesChangeInteractorInput {

    
    func obtainLanguages(profile: Profile) -> Single<[ProfileLanguage]>? {
        return networkService?.obtainLanguages(profile: profile)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    
    }
    
}
