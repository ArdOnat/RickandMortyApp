//
//  CharacterListViewController.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CharacterListViewProtocol: class {
    var presenter: CharacterListPresenterProtocol { get }
    
    func refreshUIWithSuccess()
    func showLoading(shouldShow : Bool)
    func showError()
    func refreshSelectedCell()
}

final class CharacterListViewController: UIViewController {

    private struct Constants {
        static let contentInsets: Int = 12
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var listTableView: UITableView!
    @IBOutlet private weak var gridCollectionView: UICollectionView!
    
    // MARK: Private properties
    private var vSpinner : UIView?
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private var searchTerm: String?
    private var selectedStatus: CharacterStatus?
    private var selectedCellIndex: IndexPath?
    
    // MARK: Public properties
    let presenter: CharacterListPresenterProtocol
    
    // MARK: Initializers
    init(presenter: CharacterListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCharacters(shouldResetData: false)
    }
    
    private func setupUI() {
        listTableView.delegate = self
        listTableView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        searchBar.delegate = self
        
        segmentedControl?.addTarget(self, action: #selector(self.viewSegmentedControlChanged(_:)), for: .valueChanged)
        statusSegmentedControl?.addTarget(self, action: #selector(self.statusSegmentedControlChanged(_:)), for: .valueChanged)
        
        listTableView.register(UINib(nibName: CharacterListTableViewCell.ReuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: CharacterListTableViewCell.ReuseIdentifier)
        gridCollectionView.register(UINib(nibName: CharacterListCollectionViewCell.ReuseIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: CharacterListCollectionViewCell.ReuseIdentifier)
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    @objc private func statusSegmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            selectedStatus = nil
        case 1:
            selectedStatus = .Alive
        case 2:
            selectedStatus = .Dead
        default:
            selectedStatus = .Unknown
        }
        fetchCharacters(shouldResetData: true)
    }
    
    @objc private func viewSegmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        guard let characterCount = presenter.viewModel?.characterCount,
              characterCount != 0 else { return }
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            listTableView.isHidden = false
            gridCollectionView.isHidden = true
        case 1:
            listTableView.isHidden = true
            gridCollectionView.isHidden = false
        default:
            break
        }
    }
    
    private func fetchCharacters(shouldResetData: Bool) {
        presenter.fetchCharacters(searchTerm: self.searchTerm, status: self.selectedStatus, shouldResetData: shouldResetData)
        
        guard shouldResetData else { return }
        listTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        gridCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension CharacterListViewController: CharacterListViewProtocol {
    func refreshSelectedCell() {
        guard let indexPath = self.selectedCellIndex else { return }
        listTableView.reloadRows(at: [indexPath], with: .automatic)
        gridCollectionView.reloadItems(at: [indexPath])
    }
    
    func refreshUIWithSuccess() {
        listTableView.reloadData()
        gridCollectionView.reloadData()
        segmentedControl.sendActions(for: .valueChanged)
    }
    
    func showLoading(shouldShow: Bool) {
        shouldShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func showError() {
        listTableView.isHidden = true
        gridCollectionView.isHidden = true
        self.showToast(message: "Could not find any results.", font: .systemFont(ofSize: 12))
    }
}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModel?.characterCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CharacterListTableViewCell = tableView.dequeueReusableCell(withIdentifier: CharacterListTableViewCell.ReuseIdentifier, for : indexPath) as! CharacterListTableViewCell
        guard let viewModel = presenter.viewModel,
              let character = viewModel.getCharacterInformation(at: indexPath),
              let imageURL = character.image.url else { return UITableViewCell() }
        
        cell.configure(characterImageURL: imageURL, name: character.name, status: CharacterStatus(rawValue: character.status) ?? .Unknown, species: character.species, isFavorited: viewModel.favoritedCharactersId.contains(character.id))
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = presenter.viewModel, !viewModel.isLastPage, (presenter.viewModel?.characterCount ?? 0) - 1 == indexPath.row else { return }
        fetchCharacters(shouldResetData: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let character = presenter.viewModel?.getCharacterInformation(at: indexPath), let navigationController = self.navigationController else { return }
        presenter.presentCharacterDetail(with: navigationController, characterInformation: character)
        self.selectedCellIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CharacterListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.viewModel?.characterCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CharacterListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterListCollectionViewCell.ReuseIdentifier, for: indexPath) as! CharacterListCollectionViewCell
        guard let viewModel = presenter.viewModel,
              let character = presenter.viewModel?.getCharacterInformation(at: indexPath),
              let imageURL = character.image.url else { return UICollectionViewCell() }
        cell.configure(characterImageURL: imageURL, name: character.name, status: CharacterStatus(rawValue: character.status) ?? .Unknown, species: character.species, isFavorited: viewModel.favoritedCharactersId.contains(character.id))
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.layer.bounds.width - CGFloat(Constants.contentInsets)) / 2, height: collectionView.layer.bounds.height / 2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = presenter.viewModel, !viewModel.isLastPage, (presenter.viewModel?.characterCount ?? 0) - 1 == indexPath.row else { return }
        fetchCharacters(shouldResetData: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = presenter.viewModel?.getCharacterInformation(at: indexPath), let navigationController = self.navigationController else { return }
        presenter.presentCharacterDetail(with: navigationController, characterInformation: character)
        self.selectedCellIndex = indexPath
    }
}

extension CharacterListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTerm = searchBar.text
        fetchCharacters(shouldResetData: true)
    }
}
