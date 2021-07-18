//
//  LanguageChangeChoosedTableViewCell.swift
//  Sfera
//
//  Created by  inna on 31/03/2021.
//  Copyright © 2021 Sfera. All rights reserved.
//

import UIKit


extension LanguageChangeChoosedTableViewCell {
    struct Appearance {
        let sideMargin: CGFloat = 16.0
        let leftSideMarginImageView = 10.00
        let rightSideMarginImageView = 8.00
        let widthImageView = 48.00
        let textColor: UIColor = UserColors.fontColor
        let font: UIFont = .authRegularFont(with: 17)
    }
}

final class LanguageChangeChoosedTableViewCell: UITableViewCell {

    public var viewModelItem = LangChoosedViewModel(title: nil, img: nil, code: nil, onTap: {}, onDel: {_ in }, isMov: false){
        didSet {
            if let title =  viewModelItem.title {
                label.text = String(title.prefix(1).capitalized + title.dropFirst())
            }
            imageView?.image = viewModelItem.img
        }
    }

    private let appearance = Appearance()

    private lazy var imageLeftView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.font
        label.textColor = appearance.textColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    // MARK: Lifecycle

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
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        contentView.backgroundColor = .clear
        addSubviews()
        makeConstraints()
        
        let border = CALayer()
        border.backgroundColor = UIColor(rgb: 0xEBEBF5).withAlphaComponent(0.30).cgColor
        border.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height, width: UIScreen.main.bounds.width, height: 1.0)
        contentView.layer.addSublayer(border)
    }

    private func addSubviews() {
        contentView.addSubview(imageLeftView)
        contentView.addSubview(label)
    }

    private func makeConstraints() {

        imageLeftView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(appearance.widthImageView)
            make.left.equalToSuperview().inset(appearance.leftSideMarginImageView)
        }

        label.snp.makeConstraints { make in
            make.left.equalTo(imageLeftView.snp.right).inset(appearance.rightSideMarginImageView)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.superview?.subviews.first?.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}

