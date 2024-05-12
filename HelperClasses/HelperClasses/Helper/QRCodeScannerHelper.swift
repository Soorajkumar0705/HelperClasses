//
//  QRCodeScannerHelper.swift
//  HelperClasses
//
//  Created by Apple on 10/02/24.
//

import UIKit
import AVKit

class QRCodeScannerHelper : NSObject {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    var found : ((String) -> Void)? = nil

    func initialSetUp(){
        self.captureSession = AVCaptureSession()
        setCaptureSession()
    }

    private func setCaptureSession(){

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
    }

    func isScanning() -> Bool?{
        return self.captureSession?.isRunning
    }

    func setPreviewLayerIn(_ view : UIView){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    func startScannning(){
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            self.captureSession.startRunning()
        }
    }

    func stopScannning(){
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            self.captureSession.stopRunning()
        }
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        captureSession = nil
    }
}

extension QRCodeScannerHelper : AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            self.found?(stringValue)
        }
    }
}
