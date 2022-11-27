//
//  RootViewController.swift
//  Example_Programatic
//
//  Created by 김태성 on 2022/09/21.
//

import UIKit
import SnapKit

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
            subjectView.configureView(title: subjectType.description)
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
}
