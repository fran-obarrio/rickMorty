//
//  CustomCharacterCell.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

import UIKit
import SnapKit

class CustomCharacterCell: UICollectionViewCell {
    
    var character: Character? {
        didSet {
            guard let character = character else { return }
            titleLabel.text = character.name
            
            if let imageUrl = URL(string: character.image) {
                characterImageView.sd_setImage(with: imageUrl, completed: nil)
            }
            
            favoriteButton.isSelected = character.isFavorite
        }
    }
    
    weak var delegate: delegateTapFavorite?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heart_empty"), for: .normal)
        button.setImage(UIImage(named: "heart_filled"), for: .selected)
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    func roundTopCorners(for view: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 8, height: 8))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(containerView)
        
        containerView.addSubview(characterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(favoriteButton)
        
        // SnapKit Constraints
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
            make.height.equalTo(containerView.snp.width).inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(4)
            make.left.right.bottom.equalTo(containerView)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.right.equalTo(characterImageView).offset(-8)  // Place it 8pts from the right of the image
            make.top.equalTo(characterImageView).offset(8)     // Place it 8pts from the top of the image
            make.width.height.equalTo(32)                      // Assuming a size of 32x32 for the button
        }
        
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        
        DispatchQueue.main.async {
            self.roundTopCorners(for: self.characterImageView)
        }
    }
    
    @objc func didTapFavoriteButton() {
        delegate?.tapFavorite(rowID: self.tag)
    }
}
