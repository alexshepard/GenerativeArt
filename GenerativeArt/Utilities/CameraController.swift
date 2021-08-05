//
//  CameraController.swift
//  CameraController
//
//  Created by Alex Shepard on 8/5/21.
//

import Foundation
import UIKit
import AVFoundation


class CameraController: NSObject, ObservableObject {
    private var lastFrame: Date?
    
    @Published var cgImage: CGImage?
    
    private var captureSession: AVCaptureSession?
    
    let ciContext = CIContext(options: nil)
    
    var cameraPosition: AVCaptureDevice.Position
    var fps: Double
    
    init(cameraPosition: AVCaptureDevice.Position, fps: Double = 5) {
        self.cameraPosition = cameraPosition
        self.fps = fps
        
        super.init()
        
        do {
            try self.prepareCamera()
        } catch (let error) {
            print(error)
        }
    }
    
    func startCapture() {
        self.captureSession?.startRunning()
    }
    
    func stopCapture() {
        self.captureSession?.stopRunning()
    }
    
    func prepareCamera() throws {
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .iFrame960x540
        captureSession.commitConfiguration()
        
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) {
            do {
                let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
                if captureSession.canAddInput(backCameraInput) {
                    captureSession.addInput(backCameraInput)
                } else {
                    print("can't add input")
                    return
                }
                
                
            } catch (let error) {
                print(error)
                return
            }
        } else {
            print("no camera")
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "DispatchQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        if let conn = videoOutput.connections.first {
            conn.videoOrientation = .portrait
        }

    }
}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let lastFrame = lastFrame {
            let timeSinceLastFrame = Date().timeIntervalSince(lastFrame)
            if timeSinceLastFrame < 1/fps {
                return
            }
        }
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer)
        let cgImage = self.ciContext.createCGImage(ciimage, from: ciimage.extent)
        DispatchQueue.main.async {
            self.cgImage = cgImage
        }
        lastFrame = Date()
    }
}
