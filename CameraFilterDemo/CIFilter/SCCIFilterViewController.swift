//
//  SCCIFilterViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/8.
//

import UIKit

@objcMembers class SCCIFilterViewController: UIViewController {
    
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
        
        var parameters: [(String, Float)] {
            switch self {
            case .highlightShadowAdjust:
                return [("inputHighlightAmount", 1.0), ("inputShadowAmount", 0.0)]
            case .exposureAdjust:
                return [("inputEV", 0.5)]
            case .colorControls:
                return [("inputSaturation", 1.0), ("inputBrightness", 0.0), ("inputContrast", 1.0)]
            case .photoEffectChrome:
                return []
            case .photoEffectFade:
                return []
            }
        }
        
        var isActionButtonNeeded: Bool {
            return (self == .photoEffectChrome || self == .photoEffectFade)
        }
    }
    
    // MARK: - Property
    let context: CIContext
    var image = UIImage(named: "filter-test-photo")!
    var isFilterOpened: Bool = false
    
    var style: FilterStyle = .highlightShadowAdjust {
        didSet {
            self.navigationItem.title = self.style.filterName
            self.removeFilter()
            self.tableView.reloadData()
        }
    }

    // MARK: - UI Content
    lazy var photoImgView: UIImageView = {
        let v = UIImageView(image: self.image)
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
        self.context = CIContext()
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
extension SCCIFilterViewController {
    
    @objc func didClickCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didClickSelectButton(_ sender: UIButton) {
        self.showMoreActionsSheet()
    }
}

// MARK: - UITableViewDataSource
extension SCCIFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.style.isActionButtonNeeded) ? 1 : self.style.parameters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SCFilterSliderCell = tableView.dequeueReusableCell(for: indexPath)
        
        if (self.style.isActionButtonNeeded) {
            cell.update()
        } else {
            cell.update(title: self.style.parameters[indexPath.row].0,
                        defaultValue: self.style.parameters[indexPath.row].1)
        }
        
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SCCIFilterViewController: UITableViewDelegate {
    
}

// MARK: - SCFilterSliderCellDelegate
extension SCCIFilterViewController: SCFilterSliderCellDelegate {

    func didSlide(parameter: String, value: Float) {
        self.applyFilter(parameter: parameter, value: value)
    }
    
    func didClickAction() {
        self.applyFilter()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SCCIFilterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let image = info[.originalImage] as? UIImage {
            self.image = image
            self.photoImgView.image = image
            picker.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }
    }
}

// MARK: - Private
extension SCCIFilterViewController {
    
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
            make.top.equalTo(self.photoImgView.snp_bottomMargin).offset(44)
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
        
        self.navigationItem.title = self.style.filterName
    }
    
    private func showMoreActionsSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "從相簿上傳照片", style: .default) { (_) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        })
        
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
    
    private func applyFilter(parameter: String? = nil, value: Float? = nil) {
        
        guard let filter = CIFilter(name: self.style.filterName) else {
            print("=== Filter is nil")
            return
        }
        
        let ciImage = CIImage(image: self.image)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let p = parameter, let v = value {
            filter.setValue(v, forKey: p)
        }
        
        if let outputImg = filter.outputImage,
           let cgimg = self.context.createCGImage(outputImg, from: outputImg.extent) {
            
            let processedImage = UIImage(cgImage: cgimg)
            self.photoImgView.image = processedImage
            
            self.isFilterOpened = true
        }
    }
    
    private func removeFilter() {
        
        self.photoImgView.image = self.image
        self.isFilterOpened = false
    }
}
