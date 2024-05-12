//
//  AVPlayerHelper.swift
//  FeverApp
//
//  Created by Admin on 27/11/23.
//

import AVKit
import AVFoundation

class AVPlayerHelper: UIView {

	private	var player: AVPlayer!
	private var playerLayer: AVPlayerLayer!

	deinit{
        didStopVideoPlaying = nil
        NotificationCenter.default.removeObserver(self)
        print("Removed \(className) automatically from memory.")
	}
    
    var isEnableAutoPlay : Bool = false
    var didStopVideoPlaying : VoidClosure? = nil

    func configurePlayer(videoName: String, withExtension: String = "mp4", gravity: AVLayerVideoGravity = .resize){
        if let videoURL = Bundle.main.url(forResource: videoName, withExtension: withExtension) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = self.bounds
            playerLayer?.videoGravity = .resize
            
            if let playerLayer = playerLayer {
                self.layer.addSublayer(playerLayer)
            }
            
            NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem, queue: .main, using: { [weak self] _ in
                guard let self else { return }
                
                if isEnableAutoPlay{
                    player?.seek(to: CMTime.zero)
                    player?.play()
                }
                
                didStopVideoPlaying?()
            })
            
        }
    }
    
    func play(){
        player?.play()
    }
    
    func pause(){
        player?.pause()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutSubviews()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
