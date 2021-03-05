//
//  RecordingViewController.swift
//  AudioVisualizer
//
//  Created by Ameed Sayeh on 05/03/2021.
//

import UIKit

class RecordingViewController: UIViewController {

    lazy var recordButton: UIButton = {
       
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        
        let iconImage = UIImage(systemName: "mic.fill")?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(iconImage, for: .normal)
        button.imageView?.tintColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews() {
        
        self.view.addSubview(self.recordButton)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            self.recordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.recordButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }


}

