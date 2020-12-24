//
//  SCTakePhotoViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/23.
//

import UIKit

@objcMembers class SCTakePhotoViewController: UIViewController {
    
    // MARK: - Property
    let imagePicker = UIImagePickerController()
    var cropImageRect: CGRect?
    
    // MARK: - UI Content
    lazy var closeBtn: UIButton = {
        let b = UIButton(type: .custom)
        let image = UIImage(named: "close-btn")?.withRenderingMode(.alwaysTemplate)
        b.setImage(image, for: .normal)
        b.tintColor = .blue
        b.addTarget(self, action: #selector(didClickCloseButton), for: .touchUpInside)
        return b
    }()
    
    lazy var imageView: UIImageView = {
        let v: UIImageView = UIImageView(frame: .zero)
        v.backgroundColor = .lightGray
        return v
    }()
    
    lazy var actionBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray
        b.setTitle("Action Button", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.addTarget(self, action: #selector(didClickActionButton), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(Self.self) init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configUIComponent()
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        self.addCameraNotificaionObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Action
extension SCTakePhotoViewController {
    
    @objc func didClickCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didClickActionButton(_ sender: Any) {
            
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .camera
            self.addCameraOverlayView()
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Public
extension SCTakePhotoViewController {
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SCTakePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.imageView.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private
extension SCTakePhotoViewController {
    
    private func configUIComponent() {
        
        self.view.addSubview(self.closeBtn)
        self.closeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.top.equalTo(44)
            make.left.equalTo(22)
        }
        
        self.view.addSubview(self.imageView)
        let imageW: CGFloat = self.view.frame.width - (44 * 2)
        let imageH: CGFloat = imageW / 3 * 2
        self.imageView.snp.makeConstraints { (make) in
            make.width.equalTo(imageW)
            make.height.equalTo(imageH)
            make.centerY.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.actionBtn)
        self.actionBtn.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.height.equalTo(44)
            make.top.equalTo(self.imageView.snp_bottomMargin).offset(44)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addCameraOverlayView() {
        
        let cameraPreviewW: CGFloat = self.view.frame.width
        let cameraPreviewH: CGFloat = cameraPreviewW / 3 * 4
        let cameraPreviewTopPadding: CGFloat = 44
        let cameraPreviewRect = CGRect(x: 0, y: cameraPreviewTopPadding, width: cameraPreviewW, height: cameraPreviewH)
        
        let cropRangeHorizontalPadding: CGFloat = 20.0
        let cropRangeW: CGFloat = cameraPreviewW - (cropRangeHorizontalPadding * 2)
        let cropRangeH: CGFloat = cropRangeW / 3 * 2
        let cropRangeTopPadding: CGFloat = cameraPreviewRect.origin.y + ((cameraPreviewH - cropRangeH) / 2)
        let cropRangeRect = CGRect(x: cropRangeHorizontalPadding, y: cropRangeTopPadding, width: cropRangeW, height: cropRangeH)
        self.cropImageRect = cropRangeRect
        
        let pathBigRect = UIBezierPath(rect: cameraPreviewRect)
        let pathSmallRect = UIBezierPath(roundedRect: cropRangeRect, cornerRadius: 8)
        
        pathBigRect.append(pathSmallRect)
        pathBigRect.usesEvenOddFillRule = true

        let centerLayer = CAShapeLayer()
        centerLayer.path = pathSmallRect.cgPath
        centerLayer.lineWidth = 1
        centerLayer.strokeColor = UIColor.white.cgColor
        centerLayer.fillColor = UIColor.clear.cgColor

        let fillLayer = CAShapeLayer()
        fillLayer.path = pathBigRect.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.7
        
        let v = UIView(frame: self.view.frame)
        v.layer.addSublayer(centerLayer)
        v.layer.addSublayer(fillLayer)
        self.imagePicker.cameraOverlayView = v
    }
    
    private func addCameraNotificaionObserver() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidCaptureItem"), object:nil, queue:nil, using: { note in
            
            self.imagePicker.cameraOverlayView?.isHidden = true
        })

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidRejectItem"), object:nil, queue:nil, using: { note in
            
            self.imagePicker.cameraOverlayView?.isHidden = false
        })
    }
}
