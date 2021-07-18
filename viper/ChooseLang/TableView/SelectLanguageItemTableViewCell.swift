
import UIKit

struct SelectLanguageItemTableViewCellModel: TableViewCellModelProtocol {
    let title: String?
}

extension SelectLanguageItemTableViewCell {
    struct Appearance {
        let sideMargin: CGFloat = 16.0
        let textColor: UIColor = UserColors.fontColor
        let font: UIFont = .authRegularFont(with: 17)
    }
}

final class SelectLanguageItemTableViewCell: UITableViewCell {

    public var viewModel = SelectLanguageItemTableViewCellModel(title: nil) {
        didSet {
            if let title =  viewModel.title {
                label.text = String(title.prefix(1).capitalized + title.dropFirst())
            }
        }
    }
        
    private let appearance = Appearance()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.font
        label.textColor = appearance.textColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: Private methods
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(label)
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().inset(appearance.sideMargin)
        }
    }
}
