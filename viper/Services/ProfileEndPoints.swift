//
//  ProfileEndPoints.swift
//  viper
//
//  Created by  inna on 18/07/2021.
//

import Foundation

enum ProfileEndPoints{
    case obtainLocation(profile: Profile)
}

extension ProfileEndPoints: EndPointProtocol {
    var endUrl: String {
        switch self {
        case .obtainLanguages:
            return "api/get/language"
        }
    }
    
    var params: [String : Any]? {
        switch self {

        case .obtainLocation :
            return nil
       // other case if with parameter
        }
    }
}

