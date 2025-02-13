//
//  UIButton+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIButton {
    
    // UIButton의 아래 라인 만들어주는 함수
    func makeBottomLine(color: UInt, width: CGFloat, height: CGFloat, offsetToTop: CGFloat) {
        let bottomLine = UIView().then {
            $0.backgroundColor = UIColor.init(hex: color)
        }
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(offsetToTop)
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.left.equalTo(self.snp.left)
        }
    }
    
    func setActivatedNextButton() {
        self.isEnabled = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .mainColor
    }
    
    func setDeactivatedNextButton() {
        self.isEnabled = false
        self.tintColor = UIColor(hex: 0xA8A8A8)
        self.backgroundColor = UIColor(hex: 0xEFEFEF)
    }
    
    func setActivatedButton() {
        self.isEnabled = true
        self.setTitleColor(.mainColor, for: .normal)
        self.backgroundColor = .white
        self.layer.shadowRadius = 4
        self.layer.shadowColor = UIColor.mainColor.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
    }
    
    func setDeactivatedButton() {
        self.isEnabled = false
        self.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        self.backgroundColor = UIColor(hex: 0xEFEFEF)
        self.layer.shadowRadius = 0
    }
    
    func setActivatedCheckButton() {
        self.isEnabled = true
        self.setTitleColor(.mainColor, for: .normal)
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.mainColor.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
    }
    
    func setDeactivatedCheckButton() {
        self.isEnabled = false
        self.setTitleColor(.init(hex: 0xD8D8D8), for: .normal)
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(hex: 0xD4EEF9).cgColor
        self.layer.borderWidth = 1
    }
}
