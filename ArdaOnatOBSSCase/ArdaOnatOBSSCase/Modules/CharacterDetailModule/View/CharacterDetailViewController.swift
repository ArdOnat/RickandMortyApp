//
//  CharacterDetailViewController.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 21.05.2021.
//

import UIKit

protocol CharacterDetailClosedDelegate: class {
    func onCharacterDetailClose()
}

protocol CharacterDetailViewProtocol: class {
    var presenter: CharacterDetailPresenterProtocol { get }
    
    func refreshUI(episodeName: String, airDate: String)
    func showLoading(shouldShow : Bool)
    func updateFavoriteButton(isFavorited: Bool)
}

class CharacterDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var originLocationNameLabel: UILabel!
    @IBOutlet private weak var lastKnownLocationNameLabel: UILabel!
    @IBOutlet private weak var lastSeenEpisodeInfoLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    // MARK: Private properties
    private var vSpinner : UIView?
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private var isFavorited: Bool? {
        didSet {
            guard let isFavorited = isFavorited else { return }
            isFavorited ? favoriteButton.setBackgroundImage(UIImage(named: UIImage.favoriteImageName), for: .normal) : favoriteButton.setBackgroundImage(UIImage(named: UIImage.unfavoriteImageName), for: .normal)
        }
    }
    
    // MARK: Public properties
    let presenter: CharacterDetailPresenterProtocol
    weak var closedDelegate: CharacterDetailClosedDelegate?
    
    // MARK: Initializers
    init(presenter: CharacterDetailPresenterProtocol, closedDelegate: CharacterDetailClosedDelegate) {
        self.presenter = presenter
        self.closedDelegate = closedDelegate
        super.init(nibName: nil, bundle: .main)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        presenter.fetchLastEpisodeInformation()
    }
    
    private func setupUI() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        guard let viewModel = presenter.viewModel, let characterId = viewModel.characterInformation?.id else { return }
        isFavorited = viewModel.getIsFavorited(for: characterId)
    }
    
    @IBAction private  func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.closedDelegate?.onCharacterDetailClose()
    }
    
    @IBAction private func favoriteButtonPressed(_ sender: Any) {
        presenter.favoriteButtonPressed()
    }
}

extension CharacterDetailViewController: CharacterDetailViewProtocol {
    func refreshUI(episodeName: String, airDate: String) {
        guard let viewModel = presenter.viewModel, let characterInformation = viewModel.characterInformation, let imageURL = characterInformation.image.url else { return }
        characterImageView.downloaded(from: imageURL)
        nameLabel.text = characterInformation.name
        statusLabel.text = characterInformation.status
        speciesLabel.text = characterInformation.species
        numberOfEpisodesLabel.text = viewModel.numberOfEpisodesText
        genderLabel.text = characterInformation.gender
        originLocationNameLabel.text = viewModel.originLocation
        lastKnownLocationNameLabel.text = viewModel.lastKnownLocation
        lastSeenEpisodeInfoLabel.text = "\(episodeName) - \(airDate)"
    }
    
    func showLoading(shouldShow: Bool) {
        shouldShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func updateFavoriteButton(isFavorited: Bool) {
        self.isFavorited = isFavorited
    }
}
