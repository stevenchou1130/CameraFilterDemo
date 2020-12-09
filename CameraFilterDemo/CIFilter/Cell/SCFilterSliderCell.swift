//
//  SCFilterSliderCell.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/9.
//

import UIKit

protocol SCFilterSliderCellDelegate: AnyObject {
    func didSlide(parameter: String, value: Float)
    func didClickAction()
}

@objcMembers class SCFilterSliderCell: UITableViewCell {
    
    // MARK: - Property
    weak var delegate: SCFilterSliderCellDelegate?
    
    // MARK: - UI Content
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Title"
        label.textColor = .black
        return label
    }()
    
    lazy var slider: UISlider = {
        let s = UISlider(frame: .zero)
        s.minimumValue = 0
        s.maximumValue = 1
        s.isContinuous = false
        s.addTarget(self, action: #selector(sliderValueDidChange(_ :)), for: .valueChanged)
        return s
    }()
    
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0.00"
        label.textColor = .black
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray
        b.setTitle("Apply filter", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.addTarget(self, action: #selector(didClickActionButton), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp_leftMargin)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.numLabel)
        self.numLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp_rightMargin)
            make.width.equalTo(44)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.slider)
        self.slider.snp.makeConstraints { (make) in
            make.right.equalTo(self.numLabel.snp_leftMargin).offset(-16)
            make.width.equalTo(150)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.actionBtn)
        self.actionBtn.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(Self.self) init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.sizeToFit()
        self.numLabel.sizeToFit()
    }
}

// MARK: - Action
extension SCFilterSliderCell {
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        let n = sender.value.floor(toDecimal: 2)
        self.numLabel.text = "\(n)"
        
        if let title = self.titleLabel.text {
            self.delegate?.didSlide(parameter: title, value: n)
        }
    }
    
    @objc func didClickActionButton() {
        self.delegate?.didClickAction()
    }
}

// MARK: - Public
extension SCFilterSliderCell {
    
    func update(title: String, defaultValue: Float) {
        self.configUI(isActionButtonStyle: false)
        self.titleLabel.text = title
        self.resetSlider(defaultValue: defaultValue)
    }
    
    func update() {
        self.configUI(isActionButtonStyle: true)
    }
}

// MARK: - Private
extension SCFilterSliderCell {
    
    private func configUI(isActionButtonStyle: Bool) {
        self.actionBtn.isHidden = !isActionButtonStyle
        
        self.titleLabel.isHidden = isActionButtonStyle
        self.slider.isHidden = isActionButtonStyle
        self.numLabel.isHidden = isActionButtonStyle
    }
    
    private func resetSlider(defaultValue: Float) {
        self.slider.value = defaultValue
        self.numLabel.text = "\(defaultValue)"
    }
}
