//
//  SCTakePhotoViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/23.
//

import UIKit

@objcMembers class SCTakePhotoViewController: UIViewController {
    
    // MARK: - Property
    
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
        
        self.configNavigationBar()
        
        self.view.backgroundColor = .yellow
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Action
extension SCTakePhotoViewController {
    
}

// MARK: - Public
extension SCTakePhotoViewController {
    
}

// MARK: - Private
extension SCTakePhotoViewController {
    
    private func configNavigationBar() {
        
    }
}

