//
//  MainViewController.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 3/8/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Cocoa
import Domain
import RxSwift
import RxCocoa

internal final class MainViewController: NSViewController {

    let disposeBag: DisposeBag = .init()
    let ownView: MainView
    let wordUseCase: WordUseCaseProtocol

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
        bindRx()
    }

    func bindRx() {
        Signal<Void>.merge([
            ownView.wordTextField.rx.controlEvent.asSignal(),
            ownView.addButton.rx.tap.asSignal(),
        ])
        .flatMapFirst {
            return self.wordUseCase.isWordDuplicated(self.ownView.wordTextField.stringValue)
                .asSignalOnErrorJustComplete()
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
