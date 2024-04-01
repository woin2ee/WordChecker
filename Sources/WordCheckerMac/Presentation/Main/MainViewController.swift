//
//  MainViewController.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 3/8/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Cocoa
import Domain_Word
import RxSwift
import RxSwiftSugar
import RxCocoa
import UseCase_Word

internal final class MainViewController: NSViewController {

    private let disposeBag: DisposeBag = .init()
    let ownView: MainView
    private let wordUseCase: WordUseCaseProtocol

    init(ownView: MainView, wordUseCase: WordUseCaseProtocol) {
        self.wordUseCase = wordUseCase
        self.ownView = ownView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = ownView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindAddAction()
    }

    private func bindAddAction() {
        Signal<Void>.merge([
            ownView.wordTextField.rx.controlEvent.asSignal(),
            ownView.addButton.rx.tap.asSignal(),
        ])
        .flatMapFirst {
            return self.wordUseCase.isWordDuplicated(self.ownView.wordTextField.stringValue)
                .asSignalOnErrorJustComplete()
        }
        .doOnNext { wordIsDuplicated in
            if wordIsDuplicated {
                self.ownView.wordTextField.stringValue = ""
            }
        }
        .filter { !$0 }
        .compactMap { _ in try? Word(word: self.ownView.wordTextField.stringValue) }
        .flatMapFirst {
            return self.wordUseCase.addNewWord($0)
                .asSignalOnErrorJustComplete()
        }
        .emit(with: self, onNext: { owner, _ in
            owner.ownView.wordTextField.stringValue = ""
        })
        .disposed(by: disposeBag)
    }
}