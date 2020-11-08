//
//  FooterView.swift
//  IMusic
//
//  Created by Kirill Manvelov on 14.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    private var loadingLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        // needed to configure position in code
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
       return label
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(loadingLabel)
        addSubview(loader)
        
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        loadingLabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
        loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func showLoader() {
        loader.startAnimating()
        loadingLabel.text = "LOADING"
    }
    
    func stopLoader() {
        loader.stopAnimating()
        loadingLabel.text = ""
    }
    
}
