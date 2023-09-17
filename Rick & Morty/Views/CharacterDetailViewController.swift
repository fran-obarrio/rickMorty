//
//  CharacterDetailViewController.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

import UIKit
import SDWebImage
import SnapKit

class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: CharacterDetailViewModel!
    weak var coordinator: AppCoordinator?
    
    private var lottieAnimation: LottieAnimationsManager = LottieAnimationsManager()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()
    
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let episodesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    // MARK: - Initializer    
    init(viewModel: CharacterDetailViewModel, coordinator: AppCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLottieAnimation()
        configureData()
    }
    
    // MARK: - Private Methods
    private func setupLottieAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self = self else { return }
            self.lottieAnimation = LottieAnimationsManager()
            self.lottieAnimation.setup(
                view: self.view,
                animation: .lottieMorty,
                loop: true,
                isMainLoader: true,
                backgroundColor: .clear,
                contentMode: .scaleAspectFit)
            self.lottieAnimation.play()
        }
    }
    
    private func removeAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.lottieAnimation.stop()
            self.lottieAnimation.removeAnimationView()
            self.setupUI()
        }
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        
        containerView.addSubview(characterImageView)
        containerView.addSubview(characterNameLabel)
        containerView.addSubview(genderLabel)
        containerView.addSubview(speciesLabel)
        containerView.addSubview(originLabel)
        containerView.addSubview(locationLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.greaterThanOrEqualTo(300)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(180)
            make.width.equalTo(180)
        }
        
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(characterNameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        speciesLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        originLabel.snp.makeConstraints { make in
            make.top.equalTo(speciesLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(originLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
    }
    
    private func configureData() {
        if let imageURL = URL(string: viewModel.characterImageURL) {
            characterImageView.sd_setImage(with: imageURL)
        }
        
        characterNameLabel.text = viewModel.characterName
        genderLabel.text = "Gender: \(viewModel.characterGender)"
        speciesLabel.text = "Species: \(viewModel.characterSpecies)"
        originLabel.text = "Species: \(viewModel.characterOrigin)"
        locationLabel.text = "Last known location: \(viewModel.characterLocationName)"

        viewModel.fetchLocation { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_): 
                DispatchQueue.main.async {
                    self.removeAnimation()
                    let locationName = self.viewModel.characterLocationName
                    let locationType = self.viewModel.characterLocationType
                    let locationDimension = self.viewModel.characterLocationDimension
                    
                    self.locationLabel.text = "Last known location: \(locationName) Type: \(locationType) Dimension: \(locationDimension)"
                }
            case .failure(let error):
                print(error)
            }
        }

        
    }
}

