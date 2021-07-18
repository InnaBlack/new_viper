//
//  TextManager.swift
//  viper
//
//  Created by  inna on 18/07/2021.
//


import Foundation
import SQLite3

public enum Language: String {
    case russian = "ru"
    case english = "en"
}

open class BaseTextManager {
  
    // MARK: private
    private let dbConnect = LocalDatabase.shared
    
    public init() {}
    
    // Key: ViewController.View.Name
    public func getValueWithKey(key: String) -> String {
        return dbConnect.obtainValueWithKey(key: key)
    }
}

public final class LocalDatabase {
    
    // MARK: Shared property
    public static let shared = LocalDatabase()
    private var db: OpaquePointer?
    
    private init(){
        guard let dbPath = Bundle.main.path(forResource: "Languages", ofType: "sqlite") else {
            return
        }
        //guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
        guard sqlite3_open_v2(dbPath, &db, SQLITE_OPEN_NOMUTEX | SQLITE_OPEN_READONLY, nil) == SQLITE_OK else {
            sqlite3_close(db)
            db = nil
            return
        }
    }
        
    public func obtainValueWithKey(key: String) -> String {
      // TODO
        return ""
    }
    
}

