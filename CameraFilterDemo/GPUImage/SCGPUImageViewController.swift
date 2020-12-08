//
//  SCGPUImageViewController.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/8.
//

import UIKit
import SnapKit
import GPUImage

/*
 * [Reference]
 * https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/667691/
 * https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/uid/TP30000136-SW29
 * https://www.jianshu.com/p/2b54d18d111e
 * https://www.itread01.com/content/1578811749.html
 */
class SCGPUImageViewController: UIViewController {
    
    enum FilterType {
        case ciFilter
        case gpuImage
        case gpuImageWithCamera
    }
    
    // MARK: - Property
    let type: FilterType = .gpuImage
    
    // For CIFilter
    private let context = CIContext()
    let image = UIImage(named: "filter-test-photo")
    var isFilterOpened: Bool = false

    // For GPUImage
    var videoCamera: GPUImageVideoCamera?
    var filter: GPUImageFilter?
    var previewView: GPUImageView = GPUImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    
    // MARK: - UI Content
    lazy var closeBtn: UIButton = {
        let b = UIButton(type: .custom)
        let image = UIImage(named: "close-btn")?.withRenderingMode(.alwaysTemplate)
        b.setImage(image, for: .normal)
        b.tintColor = .blue
        b.addTarget(self, action: #selector(didClickCloseButton), for: .touchUpInside)
        return b
    }()
    
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
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
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
        
        switch self.type {
        case .ciFilter:
            self.configFilterUI()
            
        case .gpuImage:
            self.runGPUImage()
            
        case .gpuImageWithCamera:
            self.runGPUImageWithCamera()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Action / API
extension SCGPUImageViewController {
    
    @objc func didClickCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
        
    @objc func didClickActionButton() {
        
        switch self.type {
        case .ciFilter:
            if (self.isFilterOpened) {
                self.removeFilter()
            } else {
                self.addFilter(to: self.photoImgView)
//                self.testFilter(to: self.photoImgView)
            }
        case .gpuImage:
            self.runGPUImage()
        case .gpuImageWithCamera:
            break
        }
    }
}

// MARK: - GPUImage
extension SCGPUImageViewController {
    
    func runGPUImageWithCamera() {
        
        self.view.addSubview(self.previewView)
        self.previewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        print("=== Start to run runGPUImageWithCamera")
        
        self.videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.vga640x480.rawValue, cameraPosition: .front)
        self.videoCamera?.outputImageOrientation = .portrait;
        self.filter = GPUImagePixellateFilter()
        self.videoCamera?.addTarget(filter)
        self.filter?.addTarget(self.previewView as GPUImageView)
        self.videoCamera?.startCapture()
    }
    
    
    func runGPUImage() {
        
        self.configFilterUI()
        
        print("=== Start to run GPUImage")
        
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = 2.0
        let image = blurFilter.image(byFilteringImage: self.image)
        self.photoImgView.image = image
    }
}

// MARK: - CIFilter
extension SCGPUImageViewController {
 
    func configFilterUI() {
        
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
    
    func addFilter(to imgView: UIImageView) {
        
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
    
    func removeFilter() {
        
        print("=== Remove filter")
        
        self.photoImgView.image = self.image
        
        self.isFilterOpened = false
    }
}

// MARK: - CIFilter (Testing)
extension SCGPUImageViewController {
    
    func testFilter(to imgView: UIImageView) {
        
        print("=== Start to add testing filter")

        
//        guard let cgImage = self.image?.cgImage else { return }
//        let ciImage = CIImage(cgImage: cgImage)
//        let sobel:[CGFloat] = [-1,0,1,-2,0,2,-1,0,1]
//        let weight = CIVector(values: sobel, count: 9)
//        let outputImage = ciImage.applyingFilter("CIConvolution3X3", parameters: [kCIInputWeightsKey:weight,kCIInputBiasKey:0.5])
//
//        let context = CIContext()
//        if let cgImage = context.createCGImage(outputImage, from: ciImage.extent) {
//            let image = UIImage(cgImage: cgImage)
//            self.photoImgView.image = image
//            print("=== Updated imageView with image: \(image)")
//        }
        
        
//        guard let image = self.image else { return }
//        let ciImage = CIImage(image: image)
                
        
        guard let cgImage = self.image?.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(5.0, forKey: "inputRadius")
        
        if let outputImage = filter?.outputImage,
           let cgImg = self.context.createCGImage(outputImage, from: outputImage.extent){
            
            print("=== Updated imageView")
            
            DispatchQueue.main.async {
                imgView.image = UIImage(cgImage: cgImg)
            }
            
            self.isFilterOpened = true
            
        } else {
            
            print("=== The output image is nil")
        }
    }
}
