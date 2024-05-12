//
//  AudioManagerVC.swift
//  HelperClasses
//
//  Created by Apple on 12/05/24.
//

import UIKit
import AVKit

class AudioManagerVC: UIViewController {
    
    private var rView : UIView!
    
    private var audioSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer?
    
    private var rippleLayers: [CAShapeLayer] = []
    
    private var isAllowed : Bool = false
    private var isErrorOccured : Bool = false

    var filePath = URLConstants.localFileUrl.appendingPathExtension("recorded_audio.m4a")
    private var outPutfilePath = URLConstants.localFileUrl.appendingPathComponent("recorded_audio_In_Wav.wav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}

//MARK: - Ripple Animation

extension AudioManagerVC {
    
   fileprivate func addRippleEffectAnimation(){
        let path = UIBezierPath(ovalIn: CGRect(x: 0,
                                               y: 0,
                                               width: rView.bounds.size.width,
                                               height: rView.bounds.size.width))

        let shapePosition = CGPoint(x: rView.bounds.size.width / 2.0, y: rView.bounds.size.height / 2.0)

        for i in 0..<3 {
            let rippleShape = CAShapeLayer()
            
            rippleShape.bounds = CGRect(x: 0, y: 0, width: rView.bounds.size.width, height: rView.bounds.size.height)
            rippleShape.path = path.cgPath
            rippleShape.fillColor = UIColor.clear.cgColor
            rippleShape.strokeColor = UIColor.black.cgColor // Add your stroke color
            rippleShape.lineWidth = 8
            rippleShape.position = shapePosition
            rippleShape.opacity = 0
            
            rippleLayers.append(rippleShape)
            rView.layer.addSublayer(rippleShape)
            
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(3, 3, 1.5))
            
            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.fromValue = 1
            opacityAnim.toValue = nil
            
            let animation = CAAnimationGroup()
            animation.animations = [scaleAnim, opacityAnim]
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.repeatCount = Float.infinity
            animation.duration = 1.8
            animation.isRemovedOnCompletion = false

            let timeInBetweenRipples = 0.6
            animation.timeOffset = timeInBetweenRipples * Double(i)
            animation.speed = 1
            rippleShape.add(animation, forKey: "rippleEffect\(i)")
        }
    }
    
    fileprivate func removeRippleEffectAnimation(){
        for rippleLayer in rippleLayers {
            rippleLayer.removeAllAnimations()
            rippleLayer.removeFromSuperlayer()
        }
        rippleLayers.removeAll()
    }
    
}

// MARK: - RECORD AUDIO

extension AudioManagerVC :
    AVAudioRecorderDelegate{
  
    private func setUpRecorder() {
        do {
            
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            audioSession.requestRecordPermission() { [weak self] allowed in
                guard let self = self else { return }
                self.isAllowed = allowed
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    executeAfterAuthorizationCheck()
                }
            }   // requestRecordPermission
        } catch let error {
            isErrorOccured = true
            print("Error occurred: \(error)")
        }
    }
    
    private func executeAfterAuthorizationCheck(){
        
        if isAllowed == false{
            
            showAlertPopUp(title: "Access denied!", message: "Please allow microphone to record voice message.", onClickBtnCancel: { [weak self] in
                guard let _ = self else { return }
                
            }, onClickBtnOk: { [weak self] in
                guard let _ = self else { return }
                ComonFunctions.openWebUrl(urlString: URLConstants.settingUrl)
            })
            
        } else {
            startRecording(success: { [weak self] in
                guard let self else { return }
//                updateUIForStopRecording()
                print("Started...")
                
            }, failure: { [weak self] message in
                guard let _ = self else { return }
                print("Error occured: ",message)
            })
        }
    }   // executeAfterAuthorization
    
    func startRecording(success: (() -> Void)?, failure: ((String) -> Void)?) {
        guard isAllowed == true else { return }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        deleteExistingFile(path: filePath)
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder.delegate = self
            
            // STOP PLAYER
            stopAudioPlaying()
            
            audioRecorder.record()
            
            success?()
        } catch let error {
            isErrorOccured = true
            failure?(error.localizedDescription)
            finishRecording()
        }
    }
    
    func finishRecording(recordingSuccess: ((URL) -> Void)? = nil) {
        audioRecorder?.stop()
        audioRecorder = nil
    }
 
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }else{
            
            // successfully recorded audio
            
            deleteExistingFile(path: filePath)
            
        }
        
    }   // audioRecorderDidFinishRecording
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
//        showToastMessage(message: "Error occured while recording. please try again.")
    }
    
}

// MARK: - PLAY AUDIO

extension AudioManagerVC : AVAudioPlayerDelegate{
    
    func preparePlayer(filePath : URL) {
        
        do {
            try audioSession.setCategory(.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
            try audioSession.setActive(true)
            
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
        }
        
        do {
            
            let data = try Data(contentsOf: filePath)
            
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
        } catch {
            audioPlayer = nil
            print("AVAudioPlayer error: \(error.localizedDescription)")
        }
    }
    
    func playAudio() {
        guard let player = audioPlayer else {
            print("Audio player is not initialized.")
            return
        }
        if !player.isPlaying {
            player.play()
        }
    }
    
    func stopAudioPlaying() {
        audioPlayer?.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio playback finished.")
    }
    
}

// MARK: - m4a -> wav conversion

extension AudioManagerVC {
    
    func convertAudio(_ url: URL) {
        
        deleteExistingFile(path: outPutfilePath)
        
        var error : OSStatus = noErr
        var destinationFile : ExtAudioFileRef? = nil
        var sourceFile : ExtAudioFileRef? = nil
        
        var srcFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
        var dstFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
        
        ExtAudioFileOpenURL(url as CFURL, &sourceFile)
        
        var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))
        
        ExtAudioFileGetProperty(sourceFile!,
                                kExtAudioFileProperty_FileDataFormat,
                                &thePropertySize, &srcFormat)
        
        dstFormat.mSampleRate = 44100  //Set sample rate
        dstFormat.mFormatID = kAudioFormatLinearPCM
        dstFormat.mChannelsPerFrame = 1
        dstFormat.mBitsPerChannel = 16
        dstFormat.mBytesPerPacket = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mBytesPerFrame = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mFramesPerPacket = 1
        dstFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked |
        kAudioFormatFlagIsSignedInteger
        
        // Create destination file
        error = ExtAudioFileCreateWithURL(
            outPutfilePath as CFURL,
            kAudioFileWAVEType,
            &dstFormat,
            nil,
            AudioFileFlags.eraseFile.rawValue,
            &destinationFile)
        reportError(error: error)
        
        error = ExtAudioFileSetProperty(sourceFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        reportError(error: error)
        
        error = ExtAudioFileSetProperty(destinationFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        reportError(error: error)
        
        let bufferByteSize : UInt32 = 32768
        var srcBuffer = [UInt8](repeating: 0, count: 32768)
        var sourceFrameOffset : ULONG = 0
        
        while(true){
            var fillBufList = AudioBufferList(
                mNumberBuffers: 1,
                mBuffers: AudioBuffer(
                    mNumberChannels: 2,
                    mDataByteSize: UInt32(srcBuffer.count),
                    mData: &srcBuffer
                )
            )
            var numFrames : UInt32 = 0
            
            if(dstFormat.mBytesPerFrame > 0){
                numFrames = bufferByteSize / dstFormat.mBytesPerFrame
            }
            
            error = ExtAudioFileRead(sourceFile!, &numFrames, &fillBufList)
            reportError(error: error)
            
            if(numFrames == 0){
                error = noErr;
                break;
            }
            
            sourceFrameOffset += numFrames
            error = ExtAudioFileWrite(destinationFile!, numFrames, &fillBufList)
            reportError(error: error)
        }
        
        error = ExtAudioFileDispose(destinationFile!)
        reportError(error: error)
        error = ExtAudioFileDispose(sourceFile!)
        reportError(error: error)
    }
    
    func reportError(error: OSStatus) {
        print(error)
    }
    
    func deleteExistingFile(path : URL){
        if FileManager.default.fileExists(atPath: outPutfilePath.path) {
            do {
                try FileManager.default.removeItem(at: outPutfilePath)
                print("Existing file deleted successfully")
            } catch {
                print("Failed to delete existing file: \(error)")
            }
        }
    }
    
}
