//
//  RootViewController.swift
//  Example_Programatic
//
//  Created by 김태성 on 2022/09/21.
//

import UIKit
import SnapKit
import RxSwift

class RootViewController: UIViewController{

    //MARK : Properties
    enum SubjectType: Int, Comparable, CaseIterable {
        static func < (lhs: RootViewController.SubjectType, rhs: RootViewController.SubjectType) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        case Asyn, Behavior, Publish, Relay
        
        var description: String {
            get {
                return "\(self)Subject"
            }
        }
    }
    private let subjectManager = SubjectManager()
    private let disposeBag = DisposeBag()

    //MARK : UI Component
    lazy var container: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 5
        view.distribution = .fill
        return view
    }()
    
    lazy var subjectContainer: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var subjectViews: [SubjectType : SubjectView] = {
        var subjectDictioany = [SubjectType : SubjectView]()
        SubjectType.allCases.sorted().forEach{ subjectType in
            let subjectView = SubjectView()
            subjectView.configureView(type: subjectType)
            subjectDictioany.updateValue(subjectView, forKey: subjectType)
        }
        return subjectDictioany
    }()
    
    lazy var logViewer: LogView = {
        let view = LogView()
        view.configureView()
        return view
    }()
    
    
    //MARK : LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureBinding()
    }
    
    //MARK : Methods
    func configureUI() {
        view.addSubview(container)
        container.snp.makeConstraints{ (make) in
            make.centerX.centerY.width.height.equalTo(view.safeAreaLayoutGuide)
        }
        
        container.addArrangedSubview(subjectContainer)
        subjectContainer.snp.makeConstraints{ (make) in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.45)
        }
        
        container.addArrangedSubview(logViewer)
        logViewer.snp.makeConstraints{ (make) in
            make.width.equalToSuperview().multipliedBy(0.95)
            // Container Stack 마지막 뷰이므로
        }
        
        subjectViews.keys.sorted().forEach{subjectType in
            let view = subjectViews[subjectType]
            subjectContainer.addArrangedSubview(view!)
        }
    }
    
    func configureBinding(){
        subjectViews.keys.sorted().forEach{subjectType in
            let view = subjectViews[subjectType]
            view?.configureEvent(type: subjectType)
                .subscribe(onNext: { (type, action) in
                    switch action {
                    case .subscribeClick :
                        self.tappedSubscribeButton(type: type)
                    case .onNextClick :
                        self.tappedOnNextButton(type: type)
                    case .onErrorClick :
                        self.tappedOnErrorButton(type: type)
                    case .onCompleteClick :
                        self.tappedOnCompleteButton(type: type)
                    case .infoClick :
                        self.tappedInfoButton(type: type)
                    }
                    
                }).disposed(by: disposeBag)
        }
        
        subjectManager.getMessageObservable().subscribe(onNext: { [weak self] message in
            guard let self = self else {
                return
            }
            self.logViewer.log(message)
        }).disposed(by: disposeBag)
        
    }
}

extension RootViewController{
    func tappedSubscribeButton(type: SubjectType){
        subjectManager.subscribe(type: type)
    }
    func tappedOnNextButton(type: SubjectType){
        subjectManager.onNext(type: type)
    }
    func tappedOnErrorButton(type: SubjectType){
        subjectManager.onError(type: type)
    }
    func tappedOnCompleteButton(type: SubjectType){
        subjectManager.onComplete(type: type)
    }
    func tappedInfoButton(type: SubjectType){
        subjectManager.subjectInfo(type: type)
    }

}
