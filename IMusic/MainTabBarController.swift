//
//  MainTabBarController.swift
//  IMusic
//
//  Created by Kirill Manvelov on 27.07.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailsView()
    
    func maximazeTrackDetailsView(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStorybord()
    let trackDetailsView: TrackDetailsView = TrackDetailsView.loadFromNib()
    private var minimazedTopAnchorConstntaint: NSLayoutConstraint!
    private var maximizedTopAnchorConstntaint: NSLayoutConstraint!
    private var bottomAnchorConstntaint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.2140546441, blue: 0.4642721415, alpha: 1)
        let libraryVC = UIHostingController(rootView: Library(tabBarDelegate: self))
        viewControllers = [
            libraryVC,
            generateVC(rootViewController: searchVC, title: "Search", image: #imageLiteral(resourceName: "search"))
           // generateVC(rootViewController: LibraryViewController(), title: "Library", image: #imageLiteral(resourceName: "library"))
        ]
        libraryVC.tabBarItem.title = "Library"
        libraryVC.tabBarItem.image = #imageLiteral(resourceName: "library")
        searchVC.tabBarDelegate = self
        setTrackDetailsView()
    }
    
    private func generateVC(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
    private func setTrackDetailsView() {
        view.insertSubview(trackDetailsView, belowSubview: tabBar)
        trackDetailsView.tabBarDelegate = self
        trackDetailsView.delegate = searchVC
        // use auto layout
        trackDetailsView.translatesAutoresizingMaskIntoConstraints = false
        minimazedTopAnchorConstntaint = trackDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizedTopAnchorConstntaint = trackDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstntaint.isActive = true
        minimazedTopAnchorConstntaint.isActive = false
        bottomAnchorConstntaint = trackDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstntaint.isActive = true
        trackDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    func maximazeTrackDetailsView(viewModel: SearchViewModel.Cell?) {
        
        minimazedTopAnchorConstntaint.isActive = false
        maximizedTopAnchorConstntaint.isActive = true
        maximizedTopAnchorConstntaint.constant = 0
        bottomAnchorConstntaint.constant = 0
        trackDetailsView.miniTrackView.alpha = 0
        trackDetailsView.mainTrackView.alpha = 1
        UIView.animate(withDuration: 0.5,
                              delay: 0,
                              usingSpringWithDamping: 0.7,
                              initialSpringVelocity: 1,
                              options: .curveEaseOut,
                              animations: {
                               self.view.layoutIfNeeded()
                               self.tabBar.alpha = 0
                                 
               },
                              completion: nil)
        guard let viewModel = viewModel else {
            return
        }
        self.trackDetailsView.set(viewModel: viewModel)
    }
    
    
    
    func minimizeTrackDetailsView() {
        maximizedTopAnchorConstntaint.isActive = false
        bottomAnchorConstntaint.constant = view.frame.height
        minimazedTopAnchorConstntaint.isActive = true
        trackDetailsView.miniTrackView.alpha = 1
        trackDetailsView.mainTrackView.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
        },
                       completion: nil)
    }
    
    
}
