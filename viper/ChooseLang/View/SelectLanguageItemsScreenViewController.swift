import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension UIImage {
    enum Profile {
        static var dismissButton: UIImage { UIImage(named: "dismiss")! }
        static var searchProfile: UIImage { UIImage(named: "searchProfile")! }
    }
}

extension SelectLanguageItemsScreenViewController {
    struct Appearance {
        let closeButtonImage: UIImage = UIImage.Profile.dismissButton
        let titleColor: UIColor = UserColors.fontColor
        let titleFont: UIFont = .authSemiboldFont(with: 17)
        let tintSeachBarColor = .black
        let imageSearchBar = UIImage.Profile.searchProfile
        let sideMargin: CGFloat = 10.0
        let topMargin: CGFloat = 15.0
        let bottomMargin: CGFloat = 15.0
        let navigationButtonHeightWidth: CGFloat = 25.0
        let viewBorderGradient: GradientOption = (begin: CGPoint(x: 0.0, y: 0.5), end: CGPoint(x: 1.0, y: 0.5), colors: [ UIColor(rgb: 0x5E4C95).cgColor ,UIColor(rgb: 0x823E8B).cgColor])
        let borderViewWidth: CGFloat = 1.0
    }
}

extension SelectLanguageItemsScreenViewController: NavigationCustomizable {
    func shouldHideBackButton() -> Bool { true }
    func shouldHideNavigationBar() -> Bool { true }
}

final class SelectLanguageItemsScreenViewController: BaseViewController {
    
    private let appearance = Appearance() 
    private let disposeBag = DisposeBag()
    var presenter: SelectLanguageItemsScreenPresenterProtocol!
    
    private func makeButton(image: UIImage, with handler: @escaping () -> ()) -> UIButton {
        let button = UIButton(frame: .zero)
        button.setImage(image, for: .normal)
        button.rx.tap.bind(onNext: handler).disposed(by: disposeBag)
        return button
    }
    
    private lazy var closeButton: UIButton = {
        makeButton(image: appearance.closeButtonImage) { [weak self] in
            self?.presenter.closePressed()
        }
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = appearance.titleColor
        label.font = appearance.titleFont
        label.textAlignment = .center
        label.text = presenter?.textManager?.selectLang
        return label
    }()
    
    private lazy var searchField: BaseSearchBar = {
        let searchField = BaseSearchBar(frame: .zero)
        searchField.backgroundColor = .clear
        searchField.placeholder = presenter.textManager.selectPlaceholder
        let labelInsideUISearchBar = searchField.value(forKey: "searchField") as? UITextField
        labelInsideUISearchBar?.font = appearance.searchFontSize
        labelInsideUISearchBar?.tintColor = appearance.tintSeachBarColor
        searchField.setImage(appearance.imageSearchBar, for: .search, state: .normal)
        searchField.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] query in
                guard let query = query else { return }
                self?.presenter.searchForLang(query: query)
            }.disposed(by: disposeBag)
        return searchField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupUI()
        updateTexts()
        configureBindings()
        viewBackground.bounds = CGRect.init(x: 5, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        viewBackground.layer.insertSublayer(view.addGradientLayerProfileBackground(), at: 0)

    }
    
    func setupUI() {

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: view.frame.size)
        gradient.colors = [appearance.viewBorderGradient.colors[0],
                           appearance.viewBorderGradient.colors[1]]
        let shape = CAShapeLayer()
        shape.lineWidth = appearance.borderViewWidth
        shape.path = UIBezierPath(rect: view.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        view.layer.addSublayer(gradient)
        addSubviews()
        makeConstraints()
        presenter.selectLanguageItemsTableManager.setupTable(tableView: tableView)
    }
    
    func addSubviews() {
        viewBackground.addSubview(closeButton)
        viewBackground.addSubview(titleLabel)
        viewBackground.addSubview(searchField)
        viewBackground.addSubview(tableView)
    }
    
    func makeConstraints() {
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(appearance.sideMargin)
            make.top.equalTo(viewBackground.safeAreaLayoutGuide.snp.top).inset(appearance.topMargin)
            make.height.width.equalTo(appearance.navigationButtonHeightWidth)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton.snp.centerY)
            make.centerX.equalTo(viewBackground.snp.centerX)
            make.right.equalTo(closeButton.snp.left).inset(appearance.sideMargin)
        }
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(appearance.topMargin)
            make.left.right.equalTo(viewBackground).inset(appearance.sideMargin)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom).offset(appearance.topMargin)
            make.bottom.equalTo(viewBackground.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension SelectLanguageItemsScreenViewController: SelectLanguageItemsScreenViewInput {
    func updateTexts() {
        //object.setTitle(presenter?.textManager?.object, for: .normal)
    }
    
    func showLoader() {
        showActivityIndicator()
    }
    
    func hideLoader() {
        hideActivityIndicator()
    }
    
    func setTitle(title: String?) {
        titleLabel.text = title
    }
}

extension SelectLanguageItemsScreenViewController {
    private func configureBindings() {
        view.rx.tapGesture(configuration: { gestureRecognizer, delegate in
            gestureRecognizer.cancelsTouchesInView = false
        })
        .when(.recognized)
        .map{ _ in Void() }
        .subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
}
