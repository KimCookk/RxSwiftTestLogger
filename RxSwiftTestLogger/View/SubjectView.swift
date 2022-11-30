//
//  SubjectView.swift
//  RxSwiftTestLogger
//
//  Created by 김태성 on 2022/11/27.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxGesture

class SubjectView: UIView{
    
    /// MARK: View Compoent
    lazy var subjectLabel: UILabel = {
       let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        return button
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(type: RootViewController.SubjectType){
        self.addSubview(subjectLabel)
        
        subjectLabel.text = "[ \(type.description) ]"
        subjectLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        self.addSubview(infoButton)
        infoButton.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.1)
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
        buttonContainer.addArrangedSubview(onCompleteButton)
    }
}

extension SubjectView{
    enum Action{
        case subscribeClick, onNextClick, onErrorClick, onCompleteClick, infoClick
    }
    
    func configureEvent(type: RootViewController.SubjectType) -> Observable<(RootViewController.SubjectType, Action)> {
        Observable.merge(
            subscribeButton.rx.tapGesture().when(.recognized).map{ _ in
                return (type, Action.subscribeClick)
            },
            onNextButton.rx.tapGesture().when(.recognized).map{ _ in
                return (type, Action.onNextClick)
            },
            onErrorButton.rx.tapGesture().when(.recognized).map{ _ in
                return (type, Action.onErrorClick)
            },
            onCompleteButton.rx.tapGesture().when(.recognized).map{ _ in
                return (type, Action.onCompleteClick)
            },
            infoButton.rx.tapGesture().when(.recognized).map{ _ in
                return (type, Action.infoClick)
            }
        )
    }
}
