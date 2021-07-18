//
//  ProfileNetworkService.swift
//  viper
//
//  Created by  inna on 18/07/2021.
//

import RxSwift
import Alamofire


protocol ProfileNetworkServiceProtocol: AnyObject {
    func obtainLanguages(profile: Profile) -> Single<[ProfileLanguage]>?
}

class ProfileNetworkService {
    private let sessionManager: SessionManagerProtocol!
    private let disposeBag = DisposeBag()
    
    init() {
        self.sessionManager = SessionManager(storage: nil, baseUrl: SessionManagerBaseURL.profile)
    }
    
    private func makeRequest<E: EndPointProtocol>(
        from endPoint: E,
        method: HTTPMethod,
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makeRequest(url: endPoint.endUrl, method: method, params: endPoint.params) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeMediaRequest<E: EndPointProtocol>(
        from endPoint: E,
        method: HTTPMethod,
        completion: @escaping (Result<Data, Error>) -> ()) -> DataRequest {
        self.sessionManager.makeAsapMediaRequest(url: endPoint.endUrl, method: method, params: endPoint.params) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeUploadMediaRequest<E: EndPointProtocol>(
        from endPoint: E,
        data: Data,
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makeUploadDataStream(data: data, toUrl: endPoint.endUrl) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeUploadMultiplyData<E: EndPointProtocol>(
        from endPoint: E,
        data: [Data],
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makeUploadDataAvatar(data: data, toUrl: endPoint.endUrl) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeUploadPhotoData<E: EndPointProtocol>(
        from endPoint: E,
        data: Data,
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makeUploadDataPhoto(data: data, toUrl: endPoint.endUrl) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeGetPhotoRequest<E: EndPointProtocol>(
        from endPoint: E,
        method: HTTPMethod,
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makePhotoRequest(url: endPoint.endUrl, method: .get) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeDeletePhotoRequest<E: EndPointProtocol>(
        from endPoint: E,
        method: HTTPMethod,
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makeDeletePhotoRequest(url: endPoint.endUrl, method: method) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeUploadPhotoToAvatar<E: EndPointProtocol>(
        from endPoint: E,
        data: Data,
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makeUploadPhotoToAvatar(data: data, toUrl: endPoint.endUrl) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    private func makeReplaceDataPhoto<E: EndPointProtocol>(
        from endPoint: E,
        data: Data,
        completion: @escaping (Result<Data, Error>) -> ()) {
        self.sessionManager.makeReplaceDataPhoto(data: data, toUrl: endPoint.endUrl) { response in
            completion(.success(response))
        } failure: { error in
            completion(.failure(error))
        }
    }
}

extension ProfileNetworkService: ProfileNetworkServiceProtocol {

    func obtainProfile(profileId: UInt) -> Single<Profile?> {
        
        return .create{ [weak self] obsever in
            guard
                let strongSelf = self
            else {
                return Disposables.create()
            }
            self?.makeRequest(from: ProfileEndPoints.obtainProfile(profileId: profileId), method: .get) { result in
                switch result {
                case .success(let response):
                    if let json = try? JSONSerialization.jsonObject(with: response, options: []),
                       let profile = Profile.fromJson(json) {
                        obsever(.success(profile))
                    } else {
                        obsever(.success( nil ))
                    }
                case .failure(let error):
                    obsever(.error(SError(error: error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    func removePhoto(profileId: UInt, photoId: UInt) -> Single<String> {
        return .create{ [weak self] observer in
            guard
                let strongSelf = self
            else {
                return Disposables.create()
            }
            
            strongSelf.makeDeletePhotoRequest(from: ProfileEndPoints.removePhoto(profileId: profileId, photoId: photoId) , method:  .delete) { result in
                switch result {
                case .success(let response):
                    if let dic = [String:String].fromJson(response), let result = dic["status"] {
                        observer(.success(result))
                    } else {
                        observer(.error(SError(message: "Media files can't be upload")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteCurrentAvatar(profile: Profile, resourceId: UInt) -> Single<Void> {
        return .create{ [weak self] observer in
            guard
                let strongSelf = self
            else {
                return Disposables.create()
            }
            
            strongSelf.makeRequest(from: ProfileEndPoints.deleteCurrentAvatar(profile: profile, resourceId: resourceId), method: .delete) { result in
                switch result {
                case .success( _ ):
                    observer(.success(()))
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func setPhotoToAvatar(profileId: UInt, photoId: UInt, data: Data) -> Single<Int> {
        return .create{ [weak self] observer in
            guard
                let strongSelf = self
            else {
                return Disposables.create()
            }
            
            strongSelf.makeUploadPhotoToAvatar(from:  ProfileEndPoints.setPhotoToAvatar(profileId: profileId, photoId: photoId), data: data) { result in
                switch result {
                case .success(let response):
                    if let dic = [String:Int].fromJson(response), let result = dic["id"] {
                        observer(.success(result))
                    } else {
                        observer(.error(SError(message: "Фото не может быть загружено")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func replacePhoto(profileId: UInt, photoId: UInt, data: Data) -> Single<String> {
        return .create{ [weak self] observer in
            guard
                let strongSelf = self
            else {
                return Disposables.create()
            }
            
            strongSelf.makeReplaceDataPhoto(from:  ProfileEndPoints.removePhoto(profileId: profileId, photoId: photoId),
                                            data: data) { result in
                switch result {
                case .success(let response):
                    if let dic = [String:String].fromJson(response), let result = dic["status"] {
                        observer(.success(result))
                    } else {
                        observer(.error(SError(message: "Фото не заменено")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func obtainLocation(profile: Profile) -> Single<[ProfileCity]> {
        return .create{ [weak self] obsever in
            guard
                let self = self,
                profile.location != 0 else {
                obsever(.success([]))
                return Disposables.create()
            }
            
            self.makeRequest(from: ProfileEndPoints.obtainLocation(profile: profile), method: .get) { result in
                switch result {
                case .success(let response):
                    if let json = try? JSONSerialization.jsonObject(with: response, options: []),
                       let city = ProfileCity.fromJson(json) {
                        obsever(.success([city]))
                    } else {
                        obsever(.success([]))
                    }
                case .failure(let error):
                    obsever(.error(SError(error: error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func obtainLanguages(profile: Profile) -> Single<[ProfileLanguage]>? {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.obtainLanguages, method: .get) { result in
                switch result {
                case .success(let response):
                    // Map
                    if let json = try? JSONSerialization.jsonObject(with: response, options: []),
                       let langs = [ProfileLanguage].fromJson(json) {
                        let langsChecked = langs.filter { profileLang -> Bool in
                            return ((profile.language?.contains(where: {$0.uppercased() == profileLang.code.uppercased()})) ?? false)
                        }
                        observer(.success(langsChecked))
                    } else {
                        observer(.success([]))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    
    func obtainGifts(profile: Profile, offset: Int, pageSize: Int) -> Single<[Gift]>? {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.obtainGifts(profile: profile, offset: offset, pageSize: pageSize), method: .get) { result in
                switch result {
                case .success(let response):
                    // Map
                    if let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                       let gifts = [Gift].fromJson(json["data"]) {
                        observer(.success(gifts))
                    } else {
                        observer(.success([]))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
        
    }
    
    func obtainChronicles(profile: Profile, offset: Int, pageSize: Int) -> Single<[ChronicleModel]>? {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.obtainChronicles(profile: profile, offset: offset, pageSize: pageSize), method: .get) { result in
                switch result {
                case .success(let response):
                    // Map
                    if let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                       let data = [ChronicleModel].fromJson(json["data"]) {
                        observer(.success(data))
                    } else {
                        observer(.success([]))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func getReProfileCity(location: Int) -> Single<ProfileCity> {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.getReProfileCity(location: location), method: .get) { result in
                switch result {
                case .success(let response):
                    // Map
                    if let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                       let data = ProfileCity.fromJson(json) {
                        observer(.success(data))
                    } else {
                        observer(.error(SError(message: "ProfileCity can't be obtain")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func unfollowProfile(profileId: UInt, unfollowId: UInt) -> Single<Void> {
        return .create{ [weak self] obsever in
            guard
                let self = self else {
                obsever(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.unfollowProfile(profileId: profileId, unfollowId: unfollowId), method: .delete) { result in
                switch result {
                case .success:
                    obsever(.success(()))
                case .failure(let error):
                    obsever(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func followProfile(profileId: UInt, followId: UInt) -> Single<Void> {
        return .create{ [weak self] obsever in
            guard
                let self = self else {
                obsever(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.followProfile(profileId: profileId, followId: followId), method: .post) { result in
                switch result {
                case .success:
                    obsever(.success(()))
                case .failure(let error):
                    obsever(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func updateAboutMe(profileId: UInt, text: String) -> Single<Void> {
        return .create{ [weak self] obsever in
            guard
                let self = self else {
                obsever(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.updateAboutMe(profileId: profileId, text: text), method: .put) { result in
                switch result {
                case .success:
                    obsever(.success(()))
                case .failure(let error):
                    obsever(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }

    func getUploadUrl() -> Single<String> {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            let task = self.makeMediaRequest(from: ProfileEndPoints.getUploadUrl, method: .get) { result in
                switch result {
                case .success(let response):
                    if let dic = [String:String].fromJson(response), let url = dic["url"] {
                        observer(.success(url))
                    } else {
                        observer(.error(SError(message: "Media files can't be upload")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            
            return Disposables.create { task.cancel() }
        }
    }
    
    func uploadAvatar(profileId: UInt, key: String, data: Data) -> Single<String> {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeUploadMediaRequest(from: ProfileEndPoints.uploadAvatar(profileId: profileId, key: key), data: data) { result in
                switch result {
                case .success(let response):
                    // Map
                    if let dic = [String:String].fromJson(response), let url = dic["url"] {
                        observer(.success(url))
                    } else {
                        observer(.error(SError(message: "Media files can't be upload")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
        
    }
    
    func createAvatar(profileId: UInt, origUrl: String, previewUrl: String) -> Single<(Int, String)> {
        return .create{ [weak self] observer in
                guard
                    let self = self else {
                    observer(.error(SError(message: "")))
                    return Disposables.create()
                }
                self.makeRequest(from: ProfileEndPoints.createAvatar(profileId: profileId, origUrl: origUrl, previewUrl: previewUrl), method: .post) { result in
                    switch result {
                    case .success(let response):
                        // Map
                        if let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                           let id = json["id"] as? Int {
                            observer(.success((id, previewUrl)))
                        } else {
                            observer(.error(SError(message: "Map error")))
                        }
                    case .failure(let error):
                        observer(.error(SError(error: error)))
                    }
                }
        
            return Disposables.create()
        }
    }
    
    func setCurrentAvatar(profile: Profile, resourceId: UInt) -> Single<Void> {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeRequest(from: ProfileEndPoints.setCurrentAvatar(profile: profile, resourceId: resourceId), method: .post) { result in
                switch result {
                case .success(_):
                    observer(.success(()))
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    // Новое апи для аватаров и фото
    ///  Создать аватар
    func createAvatar(profileId: UInt, key: String, data: [Data]) -> Single<Int> {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeUploadMultiplyData(from: ProfileEndPoints.createAvatarMulty(profileId: profileId, key: "", data: data), data: data) { result in
                switch result {
                case .success(_):
                    observer(.success((200)))
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    /// Добавить фото
    func createPhoto(profileId: UInt, data: Data) -> Single<Int> {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeUploadPhotoData(from: ProfileEndPoints.createPhoto(profileId: profileId, data: data), data: data){ result in
                switch result {
                case .success(_):
                    observer(.success((200)))
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func obtainPhotos(profile: Profile) -> Single<[MediaResource]>? {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeGetPhotoRequest(from: ProfileEndPoints.obtainPhotos(profile: profile), method: .get){ result in
                switch result {
                case .success(let data):
                    if let dic = [MediaPhoto].fromJson(data) {
                        var mediaResources = [MediaResource]()
                        for res in dic {
                            let content = [MediaContentImage(mediaFileId: res.id,
                                                             contentId: res.id,
                                                             url: res.orig,
                                                             localPath: "",
                                                             preview: "",
                                                             isDownloaded: false)]
                            mediaResources.append(MediaResource(resourceId: UInt(res.id), content: content))
                        }
                        //for
                        observer(.success(mediaResources))
                    } else {
                        observer(.error(SError(message: "Media files can't be upload")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func obtainPhotosfromId(id: Int64) -> Single<[MediaPhoto]> {
        return .create{ [weak self] observer in
            guard
                let self = self else {
                observer(.error(SError(message: "")))
                return Disposables.create()
            }
            self.makeGetPhotoRequest(from: ProfileEndPoints.obtainPhotosFromId(profileId: id), method: .get){ result in
                switch result {
                case .success(let data):
                    if let photos = [MediaPhoto].fromJson(data) {
                        observer(.success(photos))
                    } else {
                        observer(.error(SError(message: "Media files can't be downloaded")))
                    }
                case .failure(let error):
                    observer(.error(SError(error: error)))
                }
            }
            return Disposables.create()
        }
    }
    
    
    func obtainPhotosfromIds(ids: [Int64]) -> Single<[PhotoLinker]> {
        return .create{ [weak self] event  in
            guard
                let self = self else {
                event(.error(SError(message: "")))
                return Disposables.create()
            }
            
            guard !ids.isEmpty else {
                event(.success([]))
                return Disposables.create()
            }
            
            var photoLinker = [PhotoLinker]()
            
            ids.forEach { id in
                self.obtainPhotosfromId(id: id)
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
                    .subscribe(onSuccess: { peerMedia in
                        photoLinker.append(.init(accoutnId: id, photos: peerMedia))
                        if photoLinker.endIndex == ids.endIndex { event(.success(photoLinker)) }
                    }, onError: { (error) in
                        photoLinker.append(.init(accoutnId: id, photos: []))
                        if photoLinker.endIndex == ids.endIndex { event(.success(photoLinker)) }
                    }).disposed(by: self.disposeBag)
                
            }
            return Disposables.create()
        }
    }
    
    
    
}


