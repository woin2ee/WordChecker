//
//  WordCheckingViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation
import UserDefaultsPlatform
import RxSwift

protocol WordCheckingViewModelDelegate: AnyObject {

    func wordCheckingViewModelDidMarkCurrentWordAsMemorized()

}

/// WordCheckingView 로부터 발생하고 Model 에 영향을 끼치는 모든 Event.
protocol WordCheckingViewModelInput {

    func addWord(_ word: String)

    func updateToNextWord()

    func updateToPreviousWord()

    func shuffleWordList()

    func deleteCurrentWord()

    func markCurrentWordAsMemorized()

}

/// WordCheckingView 를 표시하기 위해 필요한 최소한의 Model.
protocol WordCheckingViewModelOutput {

    var currentWord: AnyPublisher<String?, Never> { get }

    var translationTargetLocale: TranslationTargetLocale { get }

}

protocol WordCheckingViewModelProtocol: WordCheckingViewModelInput, WordCheckingViewModelOutput {}

final class WordCheckingViewModel: WordCheckingViewModelProtocol {

    let wordUseCase: WordUseCaseProtocol

    let userSettingsUseCase: UserSettingsUseCaseProtocol

    let state: UnmemorizedWordListStateProtocol

    weak var delegate: WordCheckingViewModelDelegate?

    private var cancelBag: Set<AnyCancellable> = .init()

    let disposeBag: DisposeBag = .init()

    let currentWordSubject: CurrentValueSubject<Domain.Word?, Never> = .init(nil)

    private(set) var translationTargetLocale: TranslationTargetLocale = .korea

    init(wordUseCase: WordUseCaseProtocol, userSettingsUseCase: UserSettingsUseCaseProtocol, state: UnmemorizedWordListStateProtocol, delegate: WordCheckingViewModelDelegate?) {
        self.wordUseCase = wordUseCase
        self.userSettingsUseCase = userSettingsUseCase
        self.state = state
        self.delegate = delegate

        state.currentWord
            .sink { [weak self] word in
                self?.currentWordSubject.send(word)
            }
            .store(in: &cancelBag)

        wordUseCase.randomizeUnmemorizedWordList()

        userSettingsUseCase.currentTranslationLocale
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, locale in
                owner.translationTargetLocale = locale
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - Output

extension WordCheckingViewModel {

    var currentWord: AnyPublisher<String?, Never> {
        currentWordSubject
            .map(\.?.word)
            .eraseToAnyPublisher()
    }

}

// MARK: - Input

extension WordCheckingViewModel {

    func addWord(_ word: String) {
        let newWord: Domain.Word = .init(word: word)
        wordUseCase.addNewWord(newWord)
    }

    func updateToNextWord() {
        wordUseCase.updateToNextWord()
    }

    func updateToPreviousWord() {
        wordUseCase.updateToPreviousWord()
    }

    func shuffleWordList() {
        wordUseCase.randomizeUnmemorizedWordList()
    }

    func deleteCurrentWord() {
        guard let currentWord = currentWordSubject.value else { return }
        wordUseCase.deleteWord(by: currentWord.uuid)
    }

    func markCurrentWordAsMemorized() {
        guard let currentWord = currentWordSubject.value else {
            return
        }

        wordUseCase.markCurrentWordAsMemorized(uuid: currentWord.uuid)

        delegate?.wordCheckingViewModelDidMarkCurrentWordAsMemorized()
    }

}
