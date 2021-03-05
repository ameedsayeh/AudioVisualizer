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
        
        button.addTarget(nil, action: #selector(didTapRecordButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var visualizerView: AudioVisualizerView = {
       
        let view = AudioVisualizerView()
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    var isRecording: Bool = false
    weak var audioMeteringDelegate: AudioMeteringDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        self.setupSubviews()
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews() {
        
        self.view.addSubview(self.recordButton)
        self.view.addSubview(self.visualizerView)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            self.recordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.recordButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.visualizerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64),
            self.visualizerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32),
            self.visualizerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32),
            self.visualizerView.bottomAnchor.constraint(equalTo: self.recordButton.topAnchor, constant: -64),
        ])
    }
    
    @objc func didTapRecordButton() {
        
    }
}


protocol AudioMeteringDelegate: NSObjectProtocol {
    
    func audioMeter(didUpdateAmplitude amplitude: Float)
}
