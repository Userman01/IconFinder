//
//  ImageCollectionViewCell.swift
//  IconFinder
//
//  Created by Петр Постников on 22.06.2024.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "ImageCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    var id: Int?
    
    var tapButton: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(button)
        contentView.addSubview(stackView)
        contentView.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: button.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentView.bounds.width),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emptyView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(icon: Icon) {
        id = icon.iconID
        let iconURL = URLWorker().getURLImage(icon: icon, format: .png)
        guard let iconURL = iconURL, let url = URL(string: iconURL) else { return }
        imageView.downloadImage(from: url, id: icon.iconID)
        addLabel(icon: icon)
        saveTags(icon: icon)
    }
    
    func configure(model: DataModel) {
        imageView.image = UIImage(data: model.imageData)
        addLabel(tags: model.tags)
        id = model.id
    }
    
    func getImage() -> UIImage? {
        imageView.image
    }
    
    func setColorButton(isSaved: Bool) {
        if isSaved  {
            button.tintColor = .black
        } else {
            button.tintColor = .blue
        }
    }
    
    @objc private func didTapButton() {
        guard let id else { return }
        tapButton?(id)
    }
    
    private func addLabel(icon: Icon) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        let count = icon.tags.count <= 10 ? icon.tags.count : 10
        for i in 0..<count {
            let label = UILabel()
            if !icon.tags[i].isEmpty {
                label.text = icon.tags[i]
                stackView.addArrangedSubview(label)
            }
        }
    }
    
    private func addLabel(tags: [String]) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        let count = tags.count <= 10 ? tags.count : 10
        for i in 0..<count {
            let label = UILabel()
            if !tags[i].isEmpty {
                label.text = tags[i]
                stackView.addArrangedSubview(label)
            }
        }
    }
    
    private func saveTags(icon: Icon) {
        DataImageStore.dataImageStore.tags[icon.iconID] = icon.tags
    }
}
