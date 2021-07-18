import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension LanguagesChangeViewController {
    struct Appearance {
        let bottomMarging = 56.0
        let tableBottomMarging = 23.5
        
        let leftSideMarginImageView = 16.00
        let rightSideMarginImageView = 8.00
        let heightImageView = 24.00
        let widthImageView = 24.00
        let addButtonHeight = 44.00
        let textColor: UIColor = .black
        
        let borderColor: CGColor = UIColor(red: 0.92, green: 0.92, blue: 0.96, alpha: 0.3).cgColor
    }
}

final class LanguagesChangeViewController: UIViewController {

    private let appearance = Appearance() 
    private let disposeBag = DisposeBag()
    var presenter: LanguagesChangePresenterProtocol!


    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.transform = CGAffineTransform (scaleX: 1, y: -1)
        tableView.contentInset = UIEdgeInsets.init(top: 1, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var addButton: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        view.addBorder(toSide: .bottom, withColor: appearance.borderColor, andThickness: 1.0)
        let imageView = UIImageView(image: UIImage(named: "add_row"))
        let label = UILabel(frame: .zero)
        label.font = appearance.fontText
        label.textColor = appearance.textColor
        label.numberOfLines = 0
        label.textAlignment = .left
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(appearance.heightImageView)
            make.width.equalTo(appearance.widthImageView)
            make.left.equalToSuperview().inset(appearance.leftSideMarginImageView)
        }

        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-appearance.rightSideMarginImageView)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: nil, action: nil)
        tapGesture.rx.event.bind { [weak self] gesture in
            self?.presenter?.itemTapped()
        }.disposed(by: disposeBag)
        
        view.addGestureRecognizer(tapGesture)
        
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupUI()
        updateTexts()
        view.layer.insertSublayer(view.addGradientLayerProfileBackgroundDark(), at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presenter.saveActionCalled()
    }

    func setupUI() {
        addSubviews()
        makeConstraints()
        presenter.languageChangeChoosedTableManager.setupTable(tableView: tableView)
    }

    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(addButton)
    }

    func makeConstraints() {
        
        addButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(appearance.addButtonHeight)
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.equalTo(viewBackground.safeAreaLayoutGuide.snp.bottom).inset(appearance.bottomMarging)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(viewBackground.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(addButton.snp.top)
        }
    }
}

extension LanguagesChangeViewController: LanguagesChangeViewInput {
    func updateTexts() {
        guard let textManager = presenter?.getTextManager() else { return }
        title = textManager.titleLabel
    }
    
    func showLoader() {
        super.showActivityIndicator()
    }
    
    func hideLoader() {
        super.hideActivityIndicator()
    }
    
    func showError(with message: String) {
        super.showProfileAlert(message: message)
    }
}

