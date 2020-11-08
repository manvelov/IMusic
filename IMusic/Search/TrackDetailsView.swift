//
//  TrackDetailsView.swift
//  IMusic
//
//  Created by Kirill Manvelov on 14.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: class {
    func moveBackFromTrack() -> SearchViewModel.Cell?
    
    func moveForwardFromTrack() -> SearchViewModel.Cell? 
}




class TrackDetailsView: UIView {
    
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniTrackTitleLable: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    
    
    @IBOutlet weak var mainTrackView: UIStackView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let scale: CGFloat = 0.8
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    var isMinimazed: Bool!
    
    var avPlayer: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    // MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTrackImageView()
        setupGestures()
    }
    
    // MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        // elements configuration
        trackTitleLabel.text = viewModel.trackName
        miniTrackTitleLable.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        miniPlayPauseButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        // imageViews configuration
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else {return}
        trackImageView.sd_setImage(with: url, completed: nil)
        miniTrackImageView.sd_setImage(with: url, completed: nil)
        
        // player run
        playTrack(url: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
    }
    
    private func playTrack(url: String?) {
        guard let url = URL(string: url ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
    
    private func setupTrackImageView() {
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
    }
    
    private func setupGestures(){
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    
    
    // MARK: - Gestures
    
    @objc private func handleTapGesture() {
        //print("tap tap")
        self.tabBarDelegate?.maximazeTrackDetailsView(viewModel: nil)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        //print("tap tap")
        switch gesture.state {
        case .changed:
            handlePanGestureChanged(gesture: gesture)
        case .ended:
            handlePanGestureEnded(gesture: gesture)
        @unknown default:
            return
        }
    }
    
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        //print("tap tap")
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            //print("\(translation.y)")
            if translation.y > 0 {
                mainTrackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseOut, animations: {
                            self.mainTrackView.transform = .identity
                            if translation.y > 50 {
                                self.tabBarDelegate?.minimizeTrackDetailsView()
                            }
            }, completion: nil)
        @unknown default:
            return
        }
    }
    
    
    
    private func handlePanGestureChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y/200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.mainTrackView.alpha = -translation.y/200
    }
    
    private func handlePanGestureEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview).y
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = .identity
                        if translation < -400 || velocity.y < -500 {
                            self.tabBarDelegate?.maximazeTrackDetailsView(viewModel: nil)
                        } else {
                            self.tabBarDelegate?.minimizeTrackDetailsView()
                        }
        },
                       completion: nil)
        
        
        
        // self.tabBarDelegate?.maximazeTrackDetailsView(viewModel: nil)
    }
    
    
    // MARK: - Time Setup
    
    private func monitorStartTime() {
        var times = [NSValue]()
        // Set initial time to 1/3 s
        let  time = CMTimeMake(value: 1, timescale: 3)
        times.append(NSValue(time: time))
        // set action in point of time
        avPlayer.addBoundaryTimeObserver(forTimes: times, queue: nil) { [weak self] in
            self?.enlargeTrackImageView()
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 1)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: nil) {[weak self] (currentTime) in
            self?.currentTimeLabel.text = currentTime.toString()
            guard let duration = self?.avPlayer.currentItem?.duration else {return}
            let leftTime = duration - currentTime
            self?.durationLabel.text = "-\(leftTime.toString())"
            self?.updateTimeSlider()
        }
    }
    
    private func updateTimeSlider() {
        let currentTime = CMTimeGetSeconds(avPlayer.currentTime())
        let duration = CMTimeGetSeconds(avPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentge = currentTime/duration
        self.currentTimeSlider.value = Float(percentge)
    }
    
    // MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        }, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func hadleCurrentTimeSlider(_ sender: Any) {
        let percantage = currentTimeSlider.value
        guard let duration = avPlayer.currentItem?.duration  else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percantage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        avPlayer.currentItem?.seek(to: seekTime, completionHandler: nil)
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        avPlayer.volume = volumeSlider.value
    }
    
    @IBAction func dragDownButtomTapped(_ sender: Any) {
        self.tabBarDelegate?.minimizeTrackDetailsView()
        // self.removeFromSuperview()
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        
        guard let cell = delegate?.moveBackFromTrack() else {return}
        self.set(viewModel: cell)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        guard let cell = delegate?.moveForwardFromTrack() else {return}
        self.set(viewModel: cell)
    }
    
    @IBAction func playPauseTrack(_ sender: Any) {
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            avPlayer.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }
    }
    
}
