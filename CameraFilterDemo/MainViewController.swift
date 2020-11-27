//
//  MainViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/11/27.
//

import UIKit
import SnapKit

/*
 * [Reference]
 * https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/667691/
 * https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/uid/TP30000136-SW29
 * https://www.jianshu.com/p/2b54d18d111e
 */
class MainViewController: UIViewController {
    
    // MARK: - Property
    let image = UIImage(named: "filter-test-photo")
    
    var isFilterOpened: Bool = false

    // MARK: - UI Content
    lazy var actionBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray
        b.setTitle("Action Button", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.addTarget(self, action: #selector(didClickActionButton), for: .touchUpInside)
        return b
    }()
    
    lazy var photoImgView: UIImageView = {
        let v = UIImageView(image: self.image)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    // MARK: - Initialization
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.photoImgView)
        self.photoImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.actionBtn)
        self.actionBtn.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-22)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Action / API
extension MainViewController {
    
    @objc func didClickActionButton() {
        
        if (self.isFilterOpened) {
            self.removeFilter()
        } else {
            self.addFilter(to: self.photoImgView)
        }
    }
}

// MARK: - Public
extension MainViewController {
    
}

// MARK: - Private
extension MainViewController {
 
    private func addFilter(to imgView: UIImageView) {
        
        print("=== Start to add filter")
        
        guard let image = self.image else {
            print("=== Default image is nil")
            return
        }
        
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let result = filter?.outputImage {
            
            print("=== Updated imageView")
            
            DispatchQueue.main.async {
                imgView.image = UIImage(ciImage: result)
            }
            
            self.isFilterOpened = true
            
        } else {
            
            print("=== The output image is nil")
        }
    }
    
    private func removeFilter() {
        
        print("=== Remove filter")
        
        self.photoImgView.image = self.image
        
        self.isFilterOpened = false
    }
}
