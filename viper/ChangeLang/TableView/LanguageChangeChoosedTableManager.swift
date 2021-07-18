//
//  LanguageChageChoosedListTableView.swift
//  Sfera
//
//  Created by  inna on 31/03/2021.
//  Copyright © 2021 Sfera. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - SelectLanguageItemsTableManagerDelegate
protocol LanguageChangeChoosedTableManagerDelegate: AnyObject {
    func itemTapped(index: Int)
}

// MARK: - LanguageChangeChoosedTableManagerProtocol
protocol LanguageChangeChoosedTableManagerProtocol: AnyObject {
    init(withDelegate delegate: LanguagesChangePresenter?)
    func setModelItems(_ modelItems: [LangChoosedViewModel])
    func setupTable(tableView: UITableView)
}

// MARK: - LanguageChangeChoosedTableManager
final class LanguageChangeChoosedTableManager: NSObject, LanguageChangeChoosedTableManagerProtocol {
    weak var delegate: LanguagesChangePresenter?
    private weak var tableView: UITableView?
    private var modelItems = [LangChoosedViewModel]()

    init(withDelegate delegate: LanguagesChangePresenter?) {
        self.delegate = delegate
    }

    func setModelItems(_ modelItems: [LangChoosedViewModel]) {
        self.modelItems = modelItems
        tableView?.reloadData()
    }

    func setupTable(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(LanguageChangeChoosedTableViewCell.self,
                                 forCellReuseIdentifier:LanguageChangeChoosedTableViewCell.reuseIdentifier)
    }
}

extension LanguageChangeChoosedTableManager: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.modelItems.count)
        return self.modelItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  LanguageChangeChoosedTableViewCell.reuseIdentifier) as! LanguageChangeChoosedTableViewCell
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.viewModelItem = self.modelItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleted = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.modelItems[indexPath.row].onDel(indexPath.row)
            completion(true)
        }

        let config = UISwipeActionsConfiguration(actions: [deleted])
        config.performsFirstActionWithFullSwipe = true

        return config
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.modelItems[indexPath.row].onTap()
    }
}
