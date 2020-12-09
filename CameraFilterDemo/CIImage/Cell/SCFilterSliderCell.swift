//
//  SCFilterSliderCell.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/9.
//

import UIKit

@objcMembers class SCFilterSliderCell: UITableViewCell {
    
    // MARK: - Property
    var index: Int?
    
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
    
    func sliderValueDidChange(_ sender: UISlider) {
        let num = String(format: "%.2f", sender.value)
        self.numLabel.text = num
    }
}

// MARK: - Public
extension SCFilterSliderCell {
    
    func update(index: Int, title: String) {
        self.index = index
        self.titleLabel.text = title
        self.resetSlider()
    }
}

// MARK: - Private
extension SCFilterSliderCell {
    
    private func resetSlider() {
        self.slider.value = 0
        self.numLabel.text = "0.00"
    }
}
