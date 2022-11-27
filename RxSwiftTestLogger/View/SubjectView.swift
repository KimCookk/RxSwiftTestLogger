//
//  SubjectView.swift
//  RxSwiftTestLogger
//
//  Created by 김태성 on 2022/11/27.
//

import Foundation
import UIKit
import SnapKit

class SubjectView: UIView{
    
    lazy var subjectLabel: UILabel = {
       let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var buttonContainer: UIStackView = {
       let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 5
        view.axis = .horizontal
        return view
    }()
    
    lazy var subscribeButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Subscribe", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return button
    }()
    
    lazy var onNextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("onNext", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        return button
    }()
    
    lazy var onErrorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("onError", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        return button
    }()
    
    lazy var onCompleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("onComplete", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        return button
    }()
    
    lazy var onDisposeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("onDispose", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(title: String){
        self.addSubview(subjectLabel)
        subjectLabel.text = "[ \(title) ]"
        subjectLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        self.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints{ (make) in
            make.top.equalTo(subjectLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        buttonContainer.addArrangedSubview(subscribeButton)
        buttonContainer.addArrangedSubview(onNextButton)
        buttonContainer.addArrangedSubview(onErrorButton)
        buttonContainer.addArrangedSubview(onDisposeButton)
        buttonContainer.addArrangedSubview(onCompleteButton)
        
    }
    
}
