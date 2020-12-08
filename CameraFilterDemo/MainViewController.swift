//
//  MainViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/11/27.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Content
    lazy var ciImageBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray
        b.setTitle("Try CIImage", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.addTarget(self, action: #selector(didClickCIImageButton), for: .touchUpInside)
        return b
    }()
    
    lazy var gpuImageBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray
        b.setTitle("Try GPUImage", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.addTarget(self, action: #selector(didClickGPUImageButton), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.ciImageBtn)
        self.ciImageBtn.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(self.gpuImageBtn)
        self.gpuImageBtn.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.ciImageBtn.snp_bottomMargin).offset(44)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Action / API
extension MainViewController {
    
    @objc func didClickCIImageButton() {
        let vc = SCCIImageViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didClickGPUImageButton() {
        let vc = SCGPUImageViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - GPUImage
extension MainViewController {
    
}

// MARK: - CIFilter
extension MainViewController {
 
}
