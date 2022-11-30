//
//  LogView.swift
//  RxSwiftTestLogger
//
//  Created by 김태성 on 2022/11/27.
//

import Foundation
import UIKit

class LogView: UIView {
    
    var isUpdatedScroll = true
    
   
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.indicatorStyle = .black
        scroll.showsVerticalScrollIndicator = true
        
        return scroll
    }()
    
    lazy var logViewer: UILabel = {
        let label = UILabel()
        label.text = "[ LogViewer ]\n"
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        self.backgroundColor = .systemGray
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.95)
        }
        
        scrollView.addSubview(logViewer)
        logViewer.snp.makeConstraints{ (make) in
            make.top.bottom.left.right.equalTo(scrollView.contentLayoutGuide)
            
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                return
            }
            self.scrollUpdate()
        })
    }
    
    func log(_ logContent: String){
        logViewer.text! += "\(logContent)\n"
        isUpdatedScroll = false
    }
    
    func scrollUpdate(){
        if(!isUpdatedScroll){
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
            if(bottomOffset.y > 0){
                scrollView.setContentOffset(bottomOffset, animated: true)
            }
            isUpdatedScroll = true
        }
    }
    
}
