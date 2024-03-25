//
//  FileDownloadHelper.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

import Foundation

class FileDownloadHelper: NSObject {
    
    private var configuration: URLSessionConfiguration?
    private var session: URLSession? = nil
    var downloadTask: URLSessionDownloadTask?
    
    var totalDownloaded: Float = 0 {
        didSet {
            handleDownloadedProgressPercent?(totalDownloaded)
        }
    }
    var downloadedPathURL: URL? = nil
    
    var handleDownloadedProgressPercent: ((Float) -> Void)? = nil
    var handleDownloadedSuccess: VoidClosure? = nil
    var handleDownloadError: ((Error)->Void)? = nil
    
    override init() {
        super.init()
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration!, delegate: self, delegateQueue: .main)
    }
    
    deinit{
        print("Removed \(className) automatically from memory.")
    }

    func download(url: String, progress: ((Float) -> Void)?) {
        handleDownloadedProgressPercent = progress
        
        guard let url = URL(string: url) else {
            preconditionFailure("URL isn't true format!")
        }
        downloadTask = session?.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    func cancelTask(){
        downloadTask?.cancel()
    }
    
    func clearData(){
        configuration = nil
        session?.invalidateAndCancel()
        session = nil
        downloadTask?.cancel()
        downloadTask = nil
    }

}

extension FileDownloadHelper: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        totalDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        downloadedPathURL = location
        handleDownloadedSuccess?()
        print("File downloaded.")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download task completed with error: \(error.localizedDescription)")
            clearData()
            handleDownloadError?(error)
        }
    }   // urlSession
}   // FileDownloadHelper
