//
//  SCCIImageViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/8.
//

import UIKit

@objcMembers class SCCIImageViewController: UIViewController {
    
    enum FilterStyle {
        case highlightShadowAdjust, exposureAdjust, colorControls, photoEffectChrome, photoEffectFade
    }
    
    // MARK: - Property
    var style: FilterStyle = .highlightShadowAdjust

    // MARK: - UI Content
    
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
        
        self.configNavi()
    }
}

// MARK: - Action
extension SCCIImageViewController {
    
    @objc func didClickCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didClickSelectButton(_ sender: UIButton) {
        self.showMoreActionsSheet()
    }
}

// MARK: - Public
extension SCCIImageViewController {
    
}

// MARK: - Private
extension SCCIImageViewController {
    
    private func configNavi() {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didClickCloseButton(_:)))
        self.navigationItem.setLeftBarButton(closeBtn, animated: false);
        
        let selectBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didClickSelectButton(_:)))
        self.navigationItem.setRightBarButton(selectBtn, animated: false);
    }
    
    private func showMoreActionsSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "CIHighlightShadowAdjust", style: .default) { (_) in
            self.style = .highlightShadowAdjust
        })

        alert.addAction(UIAlertAction(title: "CIExposureAdjust", style: .default) { (_) in
            self.style = .exposureAdjust
        })

        alert.addAction(UIAlertAction(title: "CIColorControls", style: .default) { (_) in
            self.style = .colorControls
        })
        
        alert.addAction(UIAlertAction(title: "CIPhotoEffectChrome", style: .default) { (_) in
            self.style = .photoEffectChrome
        })
        
        alert.addAction(UIAlertAction(title: "CIPhotoEffectFade", style: .default) { (_) in
            self.style = .photoEffectFade
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
