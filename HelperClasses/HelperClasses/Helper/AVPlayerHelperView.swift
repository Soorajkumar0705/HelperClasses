//
//  AVPlayerHelperView.swift
//  FeverApp
//
//  Created by Admin on 27/11/23.
//

import AVKit
import AVFoundation

class AVPlayerHelperView: UIView {

	private	var player: AVPlayer!
	private var playerLayer: AVPlayerLayer!

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupPlayer()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupPlayer()
	}

	deinit{
		NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
	}

	private func setupPlayer() {
		self.player = AVPlayer()
		self.playerLayer = AVPlayerLayer(player: self.player)
	}

	func startPlayWithURL(videoURL:String?){
		guard let videoURLString = videoURL else { return }
		guard let videoURL = URL(string: videoURLString) else { return }
		playVideo(videoURL: videoURL)
	}

	func startPlay(fileName: String, ofType: String) {
		guard let videoURL = Bundle.main.url(forResource: fileName, withExtension: ofType) else {
			print("Error while fetching the video path")
			return
		}
		playVideo(videoURL: videoURL)
	}

	private func playVideo(videoURL: URL){

		player = AVPlayer(url: videoURL)
		playerLayer = AVPlayerLayer(player: player)
		playerLayer.repeatCount = .greatestFiniteMagnitude
		playerLayer.repeatDuration = .greatestFiniteMagnitude
		layer.addSublayer(playerLayer)

		NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlaying(_ :)), name: .AVPlayerItemDidPlayToEndTime, object: nil)

		layoutSubviews()
	}

	func play(){
		self.player?.play()
	}

	func pause(){
		self.player.pause()
	}
	
	func removePlayer(){
		self.player = nil
		self.playerLayer = nil
		NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
	}

	@objc private func playerEndPlaying(_ : Notification){
		player.seek(to: CMTime.zero)
		player.play()
		print(#function)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer.frame = bounds
	}
}
