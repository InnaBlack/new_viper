
import UIKit
import RxSwift

// MARK: - SelectLanguageItemsTableManagerDelegate
protocol SelectLanguageItemsTableManagerDelegate: AnyObject {
    func itemTapped(index: Int)
}

// MARK: - SelectLanguageItemsTableManagerProtocol
protocol SelectLanguageItemsTableManagerProtocol {
    init(withDelegate delegate: SelectLanguageItemsTableManagerDelegate?)
    func setItems(_ items: [ProfileLanguage])
    func setupTable(tableView: UITableView)
}

// MARK: - SelectLanguageItemsTableManager
final class SelectLanguageItemsTableManager: NSObject, SelectLanguageItemsTableManagerProtocol {
    weak var delegate: SelectLanguageItemsTableManagerDelegate?
    private weak var tableView: UITableView?
    private var items = [ProfileLanguage]()
    
    init(withDelegate delegate: SelectLanguageItemsTableManagerDelegate?) {
        self.delegate = delegate
    }
    
    func setItems(_ items: [ProfileLanguage]) {
        self.items = items
        tableView?.reloadData()
    }
    
    func setupTable(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        tableView.register(SelectLanguageItemTableViewCell.self,
                           forCellReuseIdentifier: SelectLanguageItemTableViewCell.reuseIdentifier)
    }
}

extension SelectLanguageItemsTableManager: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectLanguageItemTableViewCell.reuseIdentifier) as! SelectLanguageItemTableViewCell
        cell.selectionStyle = .none
        cell.viewModel = SelectLanguageItemTableViewCellModel(title: self.items[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.itemTapped(index: indexPath.row)
    }
}
