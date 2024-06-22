//
//  ViewController.swift
//  IconFinder
//
//  Created by Петр Постников on 22.06.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private enum Apperance {
        static let sectionEdgeInserts = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    private let viewModel = MainViewModel()
    private lazy var customView = self.view as? MainView
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Галерея"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MainView(frame: .zero,
                        collectionViewDelegate: self,
                        collectionViewDataSource: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupStateObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView?.reloadDataCollectionView()
    }
    
    private func setupStateObservers() {
        viewModel.$result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.customView?.reloadDataCollectionView()
            }
            .store(in: &viewModel.cancellables)
        viewModel.$isSaved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSaved in
                if let cell = self?.customView?.getCollectionView().visibleCells.first(where: {
                    if let cell = $0 as? ImageCollectionViewCell {
                        return cell.id == self?.viewModel.id ? true : false
                    }
                    return false
                }) as? ImageCollectionViewCell {
                    cell.setColorButton(isSaved: isSaved)
                }
            }
            .store(in: &viewModel.cancellables)
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getRequest(searchText: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getRequest(searchText: "")
    }
}

// MARK: UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.result?.icons.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseID)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseID, for: indexPath) as? ImageCollectionViewCell
        guard let cell,
              let icons = viewModel.result?.icons
        else { return UICollectionViewCell() }
        
        let icon = icons[indexPath.item]
        cell.configure(icon: icon)
        cell.tapButton = { [weak self] id in
            self?.viewModel.saveInfo(id: id)
        }
        cell.setColorButton(isSaved: viewModel.getIsSave(id: icon.iconID))
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 64)/3
        let height = width * 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Apperance.sectionEdgeInserts
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Apperance.sectionEdgeInserts.left
    }
}
