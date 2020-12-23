//
//  SCTakePhotoViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/23.
//

import UIKit

@objcMembers class SCTakePhotoViewController: UIViewController {
    
    // MARK: - Property
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
    
    // MARK: - UI Content
    let imagePicker = UIImagePickerController()
    
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
        self.imagePicker.allowsEditing = true
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
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
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
        self.imageView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
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
}
