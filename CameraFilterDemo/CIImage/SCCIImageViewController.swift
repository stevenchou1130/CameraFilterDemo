//
//  SCCIImageViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/8.
//

import UIKit

@objcMembers class SCCIImageViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Content
    lazy var closeBtn: UIButton = {
        let b = UIButton(type: .custom)
        let image = UIImage(named: "close-btn")?.withRenderingMode(.alwaysTemplate)
        b.setImage(image, for: .normal)
        b.tintColor = .blue
        b.addTarget(self, action: #selector(didClickCloseButton), for: .touchUpInside)
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
        
        self.view.addSubview(self.closeBtn)
        self.closeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.top.equalTo(44)
            make.left.equalTo(22)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Action
extension SCCIImageViewController {
    
    @objc func didClickCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Public
extension SCCIImageViewController {
    
}

// MARK: - Private
extension SCCIImageViewController {
    
}
