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
        
        var filterName: String {
            switch self {
            case .highlightShadowAdjust:
                return "CIHighlightShadowAdjust"
            case .exposureAdjust:
                return "CIExposureAdjust"
            case .colorControls:
                return "CIColorControls"
            case .photoEffectChrome:
                return "CIPhotoEffectChrome"
            case .photoEffectFade:
                return "CIPhotoEffectFade"
            }
        }
        
        var parameters: [String] {
            switch self {
            case .highlightShadowAdjust:
                return ["inputHighlightAmount", "inputShadowAmount"]
            case .exposureAdjust:
                return ["inputEV"]
            case .colorControls:
                return ["inputSaturation", "inputBrightness", "inputContrast"]
            case .photoEffectChrome:
                return []
            case .photoEffectFade:
                return []
            }
        }
    }
    
    // MARK: - Property
    var style: FilterStyle = .highlightShadowAdjust {
        didSet {
            self.tableView.reloadData()
        }
    }

    // MARK: - UI Content
    lazy var photoImgView: UIImageView = {
        let image = UIImage(named: "filter-test-photo")
        let v = UIImageView(image: image)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(SCFilterSliderCell.self, forCellReuseIdentifier: SCFilterSliderCell.reuseCellID)
        return tv
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
        
        self.configNavi()
        self.configUIContent()
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

// MARK: - UITableViewDataSource
extension SCCIImageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.style.parameters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SCFilterSliderCell = tableView.dequeueReusableCell(for: indexPath)
        cell.update(index: indexPath.row, title: self.style.parameters[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SCCIImageViewController: UITableViewDelegate {
    
}

// MARK: - Private
extension SCCIImageViewController {
    
    private func configUIContent() {
        
        let screenW = UIScreen.main.bounds.size.width
        let photoSide = screenW / 5 * 4
        
        self.view.addSubview(self.photoImgView)
        self.photoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp_topMargin).offset(22)
            make.width.equalTo(photoSide)
            make.height.equalTo(photoSide)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.photoImgView.snp_bottomMargin).offset(22)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configNavi() {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didClickCloseButton(_:)))
        self.navigationItem.setLeftBarButton(closeBtn, animated: false);
        
        let selectBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didClickSelectButton(_:)))
        self.navigationItem.setRightBarButton(selectBtn, animated: false);
    }
    
    private func showMoreActionsSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: FilterStyle.highlightShadowAdjust.filterName, style: .default) { (_) in
            self.style = .highlightShadowAdjust
        })

        alert.addAction(UIAlertAction(title: FilterStyle.exposureAdjust.filterName, style: .default) { (_) in
            self.style = .exposureAdjust
        })

        alert.addAction(UIAlertAction(title: FilterStyle.colorControls.filterName, style: .default) { (_) in
            self.style = .colorControls
        })
        
        alert.addAction(UIAlertAction(title: FilterStyle.photoEffectChrome.filterName, style: .default) { (_) in
            self.style = .photoEffectChrome
        })
        
        alert.addAction(UIAlertAction(title: FilterStyle.photoEffectFade.filterName, style: .default) { (_) in
            self.style = .photoEffectFade
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
