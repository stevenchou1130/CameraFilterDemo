//
//  SCCIFilterViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/8.
//

import UIKit

@objcMembers class SCCIFilterViewController: UIViewController {
    
    enum FilterStyle: Int, CaseIterable {
        
        case highlightShadowAdjust, exposureAdjust, photoEffectChrome
//        case medianFilter, colorMatrix, vibrance, convolution3X3      // TODO
        case colorControls, photoEffectFade
        
        var filterName: String {
            switch self {
            case .highlightShadowAdjust:
                return "CIHighlightShadowAdjust"
            case .exposureAdjust:
                return "CIExposureAdjust"
            case .photoEffectChrome:
                return "CIPhotoEffectChrome"
                
//            case .medianFilter:
//                return "CIMedianFilter"
//            case .colorMatrix:
//                return "CIColorMatrix"
//            case .vibrance:
//                return "CIVibrance"
//            case .convolution3X3:
//                return "CIConvolution3X3"
                
            case .colorControls:
                return "CIColorControls"
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
            case .photoEffectChrome:
                return []
            
//            case .medianFilter:
//                return []
//            case .colorMatrix:
//                return []
//            case .vibrance:
//                return []
//            case .convolution3X3:
//                return []
                
            case .colorControls:
                return [("inputSaturation", 1.0), ("inputBrightness", 0.0), ("inputContrast", 1.0)]
            case .photoEffectFade:
                return []
            }
        }
        
        var isActionButtonNeeded: Bool {
            return (self.parameters.count == 0)
        }
    }
    
    // MARK: - Property
    let screenW = UIScreen.main.bounds.size.width
    let context: CIContext
    var image = UIImage(named: "filter-test-photo")!
    var isFilterOpened: Bool = false

    var style: FilterStyle {
        didSet {
            self.navigationItem.title = self.style.filterName
            self.removeFilter()
            self.tableView.reloadData()
        }
    }
    
    var pickerSelectedStyle: FilterStyle

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
        let defaultStyle: FilterStyle = .highlightShadowAdjust
        self.style = defaultStyle
        self.pickerSelectedStyle = defaultStyle
        
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
        self.showFilterPickerInActionSheet()
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

// MARK: - UIPickerView
extension SCCIFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FilterStyle.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(FilterStyle.allCases[row].filterName)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("=== didSelect: \(FilterStyle.allCases[row].filterName)")
        self.pickerSelectedStyle = FilterStyle.allCases[row]
    }
}

// MARK: - Private
extension SCCIFilterViewController {
    
    private func configUIContent() {
        
        let photoSide = self.screenW
        
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
        
        self.navigationItem.title = self.style.filterName
    }
    
    private func showFilterPickerInActionSheet() {
        
        self.pickerSelectedStyle = .highlightShadowAdjust
        
        let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true

        let pickerFrame: CGRect = CGRect(x: 0, y: 0, width: self.screenW - 88, height: 120)
        let picker = UIPickerView(frame: pickerFrame)
        picker.delegate = self
        picker.dataSource = self
        alert.view.addSubview(picker)
        picker.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
        }
        
        alert.addAction(UIAlertAction(title: "從相簿上傳照片", style: .default) { (_) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "確定", style: .default) { (_) in
            self.style = self.pickerSelectedStyle
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // DEPRECATED
    private func showFilterActionSheet() {
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

//        alert.addAction(UIAlertAction(title: FilterStyle.colorControls.filterName, style: .default) { (_) in
//            self.style = .colorControls
//        })
        
        alert.addAction(UIAlertAction(title: FilterStyle.photoEffectChrome.filterName, style: .default) { (_) in
            self.style = .photoEffectChrome
        })
        
//        alert.addAction(UIAlertAction(title: FilterStyle.photoEffectFade.filterName, style: .default) { (_) in
//            self.style = .photoEffectFade
//        })
        
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
