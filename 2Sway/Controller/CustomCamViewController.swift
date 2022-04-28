//
//  CustomCamViewController.swift
//  progressBar2
//
//  Created by user201027 on 9/3/21.
//

import UIKit
import AVFoundation

class CustomCamViewController: UIViewController {    
    
    // Capture session
    var session: AVCaptureSession?
    
    // Photo Output
    let output = AVCapturePhotoOutput()
    
    // Profile Image
    var profileImage: UIImage?
    
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // Shutter Button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = button.frame.width/2
        button.layer.borderWidth = 8
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // Circlular Mask
    func createOverlay(frame: CGRect,
                       xOffset: CGFloat,
                       yOffset: CGFloat,
                       radius: CGFloat) -> UIView {
        // Step 1
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        // Step 2
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: xOffset, y: yOffset),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        // Step 3
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        // Step 4
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true

        return overlayView
    }
    
    var overlay: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        previewLayer.backgroundColor = UIColor.black.cgColor
        view.layer.addSublayer(previewLayer)
        overlay = createOverlay(frame: view.bounds,
                      xOffset: view.frame.midX,
                      yOffset: view.frame.midY,
                      radius: (view.frame.width)/2)
        view.addSubview(overlay!)
        view.addSubview(shutterButton)
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapShutterButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.width/2,
                                       y: view.frame.height - shutterButton.frame.height)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // Request Access
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            self.dismiss(animated:true, completion:nil)
            break
        case .denied:
            self.dismiss(animated:true, completion:nil)
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch {
                print(error)
            }
        }
    }
    
    @objc private func didTapShutterButton() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (authStatus){
        case .notDetermined, .restricted, .denied:
            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Unable to access the Camera ,To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app. ")
            break
        case .authorized:
           
            output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            break
        @unknown default:
            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Unable to access the Camera ,To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app. ")
            break
        }
       // output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TakePhotoViewController {
            vc.imageToDisplay = profileImage!
            vc.canContinue = true
        }
    }
}

extension CustomCamViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        guard let image = UIImage(data: data) else {
            fatalError("Couldn't convert data to image")
        }
        session?.stopRunning()
        let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
        let imageWidth = flippedImage.size.width
        let imageHeight = flippedImage.size.height
        // How far down the original image to apply the crop to get a centred, square image
        let xOffset = (imageHeight - imageWidth) / 2.0
        let cropRect = CGRect(x: xOffset,
                              y: 0,
                              width: imageWidth,
                              height: imageWidth).integral
        let croppedImage = flippedImage.cgImage!.cropping(to: cropRect)!
        profileImage = UIImage(cgImage: croppedImage, scale: flippedImage.imageRendererFormat.scale, orientation: flippedImage.imageOrientation)
        performSegue(withIdentifier: "fromCustomCam", sender: self)
    }
}
