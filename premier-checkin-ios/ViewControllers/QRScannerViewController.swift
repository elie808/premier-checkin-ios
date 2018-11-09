//
//  QRScannerViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var qrCodeFrameView:UIImageView?
    
    // MARK: - Properties
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        //        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Initialize QR Code Frame to highlight the QR code
        if let qrCodeFrameView = qrCodeFrameView {
            view.bringSubviewToFront(qrCodeFrameView)
            view.bringSubviewToFront(messageLabel)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        // Start video capture.
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            if metadataObj.stringValue != nil {
                
                print(metadataObj.stringValue!)
                captureSession.stopRunning()
            
                // TODO: extract code, check if single or group in DB, perform segue
                // print("\n \n QR code detected \n", metadataObj.stringValue!)
                // "https://www.premieronline.com/qr.php?qr=763618&h=c30ac811d5f26ad074907843c192a8b0"
                if let qrURL = metadataObj.stringValue {
    
                    let regID = qrURL.slice(from: "?qr=", to: "&h=")
                    
                    checkDBForParticipant(with: regID!)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case Segue.QRScanner.toGroupCheckinVC:
            let vc : GroupCheckInViewController = segue.destination as! GroupCheckInViewController
            if let ticket = sender {
                if ticket is ETicket {
                    vc.title = "Premiere Checkin"
                    vc.passedETicket = ticket as! ETicket
                }
            }
                
        case Segue.QRScanner.toParticipantCheckinVC:
            let vc : SingleCheckinViewController = segue.destination as! SingleCheckinViewController
            if let ticket = sender {
                if (ticket is ITicket) {
                    vc.title = "Premiere Checkin"
                    vc.passedITicket = ticket as? ITicket
                } else if (ticket is TTicket) {
                    vc.passedTTicket = ticket as? TTicket
                }
            }
            
        default: return
        }
    }
    
    // MARK: - Helpers
    
    func showSuccess(message : String) {
        messageLabel.textColor = UIColor.green
        messageLabel.text = message
    }
    
    func showError(message : String) {
        messageLabel.textColor = UIColor.red
        messageLabel.text = message
    }
    
    func checkDBForParticipant(with regID : String) {
        if regID.count > 0 {
            if let result = searchDB(forID: regID) {
                if result is ETicket {
                    performSegue(withIdentifier: Segue.QRScanner.toGroupCheckinVC, sender: result)
                } else {
                    performSegue(withIdentifier: Segue.QRScanner.toParticipantCheckinVC, sender: nil)
                }
            } else {
                showError(message: FeedbackMessage.UserNotFound.rawValue)
                captureSession.startRunning()
            }
        } else {
            showError(message: FeedbackMessage.EmptyText.rawValue)
            captureSession.startRunning()
        }
    }
    
}
