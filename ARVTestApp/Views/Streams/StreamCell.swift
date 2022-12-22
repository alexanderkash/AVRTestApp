//
//  StreamCell.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 21.12.22.
//

import UIKit
import Kingfisher
import SnapKit

final class StreamCell: UICollectionViewCell {
    
    static let reuseIdentifier = "StreamCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func display(stream: Stream, aspectRatio: Double) {
        nameLabel.text = stream.title
        let width = Int(bounds.width)
        let height = Int(bounds.width / aspectRatio)
        let urlString = stream.thumbnailUrl
            .replacingOccurrences(of: "{width}x{height}",
                                  with: "\(width)x\(height)")
        let url = URL(string: urlString)
        imageView.kf.setImage(
            with: url,
            options: [.cacheOriginalImage]
        )
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        backgroundColor = .black
        
        nameLabel.font = .systemFont(ofSize: 13, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        
        imageView.kf.indicatorType = .activity
        imageView.kf.indicator?.view.tintColor = .white
        
        nameLabel.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top).offset(-5)
        }
    }
    
}
