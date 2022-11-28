//
//  SubjectManager.swift
//  RxSwiftTestLogger
//
//  Created by 김태성 on 2022/11/28.
//

import Foundation
import RxSwift

class SubjectManager{
    let publishSubject = PublishSubject<Int>()
    let asyncSubject = AsyncSubject<Int>()
    let replaySubject = ReplaySubject<Int>.create(bufferSize: 3)
    let behaviroSubject = BehaviorSubject<Int>(value: 0)
    
    var observerUnits: [String: ObserverUnit] = [:]
    
    func subscribe(type: RootViewController.SubjectType) -> String {
        let id = Int.random(in: 1...1000)
        let observer = ObserverUnit(id: "\(id)")
        let observable: Observable<Int>
        switch type{
            case .Asyn :
            observable = asyncSubject.asObservable()
            case .Behavior :
            observable = behaviroSubject.asObservable()
            case .Publish :
            observable = publishSubject.asObservable()
            case .Relay :
            observable = replaySubject.asObservable()
        }
        
        observer.subscribe(observable: observable)
        return "log Message"
    }
    
    func onNext(type: RootViewController.SubjectType) -> String {
        let element = Int.random(in: 1...1000)
        let observer: AnyObserver<Int>
        switch type{
            case .Asyn :
            observer = asyncSubject.asObserver()
            case .Behavior :
            observer = behaviroSubject.asObserver()
            case .Publish :
            observer = publishSubject.asObserver()
            case .Relay :
            observer = replaySubject.asObserver()
        }
        
        observer.onNext(element)
        return "log Message"
    }
    
    func onError(type: RootViewController.SubjectType) -> String {
        
        return "log Message"
    }
    
    func onComplete(type: RootViewController.SubjectType) -> String {
        
        return "log Message"
    }
    
    func onDispose(type: RootViewController.SubjectType) -> String {
        
        return "log Message"
    }
    
}

class ObserverUnit{
    private let disposeBag = DisposeBag()
    var id: String
    
    init(id: String){
        self.id = id
    }
    
    func subscribe(observable: Observable<Int>){
        var message: String = ""
        observable
            .subscribe(
                onNext: { [weak self] element in
                guard let self = self else {
                    message = "[null] onNext (\(element))"
                    return
                }
                message = "[\(self.id)] onNext (\(element))"
            }, onError: { [weak self] error in
                guard let self = self else {
                    message = "[null] onError (\(error))"
                    return
                }
                message = "[\(self.id)] onError (\(error))"
            }, onCompleted: { [weak self] in
                guard let self = self else {
                    message = "[null] onComplete "
                    return
                }
                message = "[\(self.id)] onComplete"
            }, onDisposed: { [weak self] in
                guard let self = self else {
                    message = "[null] onDisposed "
                    return
                }
                message = "[\(self.id)] onDisposed"
            })
            .disposed(by: disposeBag)
        return message
    }
    
}
