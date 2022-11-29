//
//  SubjectManager.swift
//  RxSwiftTestLogger
//
//  Created by 김태성 on 2022/11/28.
//

import Foundation
import RxSwift

class SubjectManager{
    enum TestError: Error {
        case onError
    }
    private let publishSubject = PublishSubject<Int>()
    private let asyncSubject = AsyncSubject<Int>()
    private let replaySubject = ReplaySubject<Int>.create(bufferSize: 3)
    private let behaviroSubject = BehaviorSubject<Int>(value: 0)
    
    private let messageSubject = PublishSubject<String>()
    
    private var observerUnits: [String: ObserverUnit] = [:]
    
    func subscribe(type: RootViewController.SubjectType){
        let id = "\(Int.random(in: 1...1000))"
        let observerUnit = ObserverUnit(id: id, type: type.description, messageObserver: messageSubject.asObserver())
        observerUnits[id] = observerUnit
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
        
        observerUnit.subscribe(observable: observable)
    }
    
    func onNext(type: RootViewController.SubjectType){
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
    }
    
    func onError(type: RootViewController.SubjectType){
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
        observer.onError(TestError.onError)
    }
    
    func onComplete(type: RootViewController.SubjectType){
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
        observer.onCompleted()
    }
    
    func subjectInfo(type: RootViewController.SubjectType){
        var observerList: [String] = []
        observerUnits.forEach{ (id, observerUnit) in
            let subjectType = observerUnit.subjectType
            if(subjectType == type.description){
                observerList.append(id)
            }
        }
        messageSubject.onNext("\(observerList)")
    }
    
    func getMessageObservable() -> PublishSubject<String>{
        return messageSubject
    }
    
}

class ObserverUnit{
    private let disposeBag = DisposeBag()
    
    let id: String
    let subjectType: String
    var messageObserver: AnyObserver<String>
    
    init(id: String, type: String, messageObserver: AnyObserver<String>){
        self.id = id
        self.subjectType = type
        self.messageObserver = messageObserver
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
                self.messageObserver.onNext(message)
            }, onError: { [weak self] error in
                guard let self = self else {
                    message = "[null] onError (\(error))"
                    return
                }
                message = "[\(self.id)] onError (\(error))"
                self.messageObserver.onNext(message)
            }, onCompleted: { [weak self] in
                guard let self = self else {
                    message = "[null] onComplete "
                    return
                }
                message = "[\(self.id)] onComplete"
                self.messageObserver.onNext(message)
            }, onDisposed: { [weak self] in
                guard let self = self else {
                    message = "[null] onDisposed "
                    return
                }
                message = "[\(self.id)] onDisposed"
                self.messageObserver.onNext(message)
            })
            .disposed(by: disposeBag)
        
    }
    
}
