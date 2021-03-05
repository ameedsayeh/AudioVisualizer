//
//  RecordingViewController.swift
//  AudioVisualizer
//
//  Created by Ameed Sayeh on 05/03/2021.
//

import UIKit
import AVFoundation

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
    
    var audioRecorder: AVAudioRecorder?
    var isRecording: Bool = false {
        
        didSet {
            self.recordButton.backgroundColor = isRecording ? UIColor.systemRed : UIColor.systemBlue
        }
    }
    
    var meteringTimer: Timer?
    // record value every 0.08 seconds.
    var meteringFrequency = 0.08
    
    weak var audioMeteringDelegate: AudioMeteringDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        self.audioMeteringDelegate = self.visualizerView
        
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func startRecording() {
        
        self.visualizerView.drawVisualizerCircles()
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        self.audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
        
        self.audioRecorder?.prepareToRecord()
        self.audioRecorder?.isMeteringEnabled = true
        self.audioRecorder?.record()
        
        self.runMeteringTimer()
    }
    
    private func stopRecording() {
        
        self.visualizerView.removeVisualizerCircles()
        
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        
        self.stopMeteringTimer()
    }
    
    @objc func didTapRecordButton() {
        
        if isRecording {
            self.stopRecording()
        } else {
            self.startRecording()
        }
        
        self.isRecording.toggle()
    }
}

extension RecordingViewController {
    
    fileprivate func runMeteringTimer() {
        
        self.meteringTimer = Timer.scheduledTimer(withTimeInterval: self.meteringFrequency, repeats: true, block: { [weak self] (_) in
            
            guard let self = self else { return }
            
            self.audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            
            // 1.1 to increase the feedback for low voice - due to noise cancellation.
            let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
            let clampedAmplitude = min(max(amplitude, 0), 1)
            
            self.audioMeteringDelegate?.audioMeter(didUpdateAmplitude: clampedAmplitude)
        })
        
        self.meteringTimer?.fire()
    }
    
    fileprivate func stopMeteringTimer() {
        
        self.meteringTimer?.invalidate()
        self.meteringTimer = nil
    }
}

protocol AudioMeteringDelegate: NSObjectProtocol {
    
    func audioMeter(didUpdateAmplitude amplitude: Float)
}
