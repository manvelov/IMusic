//
//  SearchViewController.swift
//  IMusic
//
//  Created by Kirill Manvelov on 29.07.2020.
//  Copyright (c) 2020 Kirill Manvelov. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?

    @IBOutlet weak var table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?
    private lazy var footerView = FooterView()
    weak var tabBarDelegate: MainTabBarController!
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    // MARK: - setupTableView
    
    private func setupTableView() {
        //table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        table.tableFooterView = footerView
    }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTableView()
    setupSearchBar()
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayCells(searchViewModel: let searchViewModel):
        self.searchViewModel = searchViewModel
        table.reloadData()
        footerView.stopLoader()
    case .displayFooterView:
        footerView.showLoader()
    }

  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: searchViewModel.cells[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let enterLabel = UILabel()
        enterLabel.text = "Please enter the search term..."
        enterLabel.textAlignment = .center
        enterLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        enterLabel.textColor = #colorLiteral(red: 0.4940669537, green: 0.4941543341, blue: 0.5241032243, alpha: 1)
        return enterLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]
        self.tabBarDelegate.maximazeTrackDetailsView(viewModel: cellViewModel)
       // let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
       // let trackDetailsView: TrackDetailsView = TrackDetailsView.loadFromNib()
       // trackDetailsView.set(viewModel: cellViewModel)
       // trackDetailsView.delegate = self
       // keyWindow?.addSubview(trackDetailsView)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
       
    }

}

  
// MARK: - TrackMovingDelegate
  
extension SearchViewController: TrackMovingDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let currentIndexPath = table.indexPathForSelectedRow else {return nil}
        table.deselectRow(at: currentIndexPath, animated: true)
        var nextIndexPath: IndexPath
        if isForwardTrack {
            nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)
            if nextIndexPath.row == 0 {
                nextIndexPath.row = searchViewModel.cells.count-1
            }
        }
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        return searchViewModel.cells[nextIndexPath.row]
    }
    
    
    func moveBackFromTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardFromTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
    }
    
      
  }
