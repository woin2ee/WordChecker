//
//  UserSettingsReactor.swift
//  UserSettings
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Core
import Domain_GoogleDrive
import Domain_UserSettings
import IOSSupport
import ReactorKit
import UseCase_GoogleDrive
import UseCase_UserSettings

final class UserSettingsReactor: Reactor {

    enum Action {
        case viewDidLoad
        case uploadData(PresentingConfiguration)
        case downloadData(PresentingConfiguration)
        case signOut
    }

    enum Mutation {
        case setSourceLanguage(TranslationLanguage)
        case setTargetLanguage(TranslationLanguage)
        case signIn
        case signOut
        case showSignOutAlert
        case showUploadSuccessAlert
        case showUploadFailureAlert
        case showDownloadSuccessAlert
        case showDownloadFailureAlert
        case setUploadStatus(ProgressStatus)
        case setDownloadStatus(ProgressStatus)
    }

    struct State {
        @Pulse var showSignOutAlert: Void?
        @Pulse var showDownloadSuccessAlert: Void?
        @Pulse var showDownloadFailureAlert: Void?
        @Pulse var showUploadSuccessAlert: Void?
        @Pulse var showUploadFailureAlert: Void?
        var sourceLanguage: TranslationLanguage
        var targetLanguage: TranslationLanguage
        var hasSigned: Bool
        var uploadStatus: ProgressStatus
        var downloadStatus: ProgressStatus
    }

    var initialState: State = .init(
        sourceLanguage: .english,
        targetLanguage: .korean,
        hasSigned: false,
        uploadStatus: .noTask,
        downloadStatus: .noTask
    )

    let userSettingsUseCase: UserSettingsUseCase
    let googleDriveUseCase: GoogleDriveUseCase
    let globalAction: GlobalAction

    init(
        userSettingsUseCase: UserSettingsUseCase,
        googleDriveUseCase: GoogleDriveUseCase,
        globalAction: GlobalAction
    ) {
        self.userSettingsUseCase = userSettingsUseCase
        self.googleDriveUseCase = googleDriveUseCase
        self.globalAction = globalAction
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let setCurrentLanguageSequence = userSettingsUseCase.getCurrentTranslationLocale()
                .asObservable()
                .flatMapFirst { (source: TranslationLanguage, target: TranslationLanguage) in
                    return Observable<Mutation>.merge([
                        .just(.setSourceLanguage(source)),
                        .just(.setTargetLanguage(target)),
                    ])
                }
            return .merge([
                .just(googleDriveUseCase.hasSigned ? .signIn : .signOut),
                setCurrentLanguageSequence,
            ])

        case .uploadData(let presentingWindow):
            let signInIfNeedsSequence = self.currentState.hasSigned
            ? .empty()
            : googleDriveUseCase.signInWithAuthorization(presenting: presentingWindow)
                .asObservable()
                .map { Mutation.signIn  }
            
            let uploadSequence = googleDriveUseCase.upload(presenting: presentingWindow)
                .subscribe(on: ConcurrentMainScheduler.instance)
                .map(Mutation.setUploadStatus)
                .concat(Observable<Mutation>.just(.showUploadSuccessAlert))
                .catch { error in
                    return .concat([
                        .just(.setUploadStatus(.complete)),
                        .just(.showUploadFailureAlert),
                    ])
                }
            
            return .concat([
                signInIfNeedsSequence,
                uploadSequence,
            ])

        case .downloadData(let presentingWindow):
            let signInIfNeedsSequence = self.currentState.hasSigned
            ? .empty()
            : googleDriveUseCase.signInWithAuthorization(presenting: presentingWindow)
                .asObservable()
                .map { Mutation.signIn  }
            
            let downloadSequence = googleDriveUseCase.download(presenting: presentingWindow)
                .doOnNext { progressStatus in
                    if progressStatus == .complete {
                        self.globalAction.didResetWordList.accept(())
                    }
                }
                .map(Mutation.setDownloadStatus)
                .concat(Observable<Mutation>.just(.showDownloadSuccessAlert))
                .catch { error in
                    return .concat([
                        .just(.setDownloadStatus(.complete)),
                        .just(.showDownloadFailureAlert),
                    ])
                }
            
            return .concat([
                signInIfNeedsSequence,
                downloadSequence,
            ])

        case .signOut:
            googleDriveUseCase.signOut()
            return .merge([
                .just(.signOut),
                .just(.showSignOutAlert),
            ])
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge([
            mutation,
            globalAction.didSetSourceLanguage
                .map(Mutation.setSourceLanguage),
            globalAction.didSetTargetLanguage
                .map(Mutation.setTargetLanguage),
        ])
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setSourceLanguage(let translationLanguage):
            state.sourceLanguage = translationLanguage
        case .setTargetLanguage(let translationLanguage):
            state.targetLanguage = translationLanguage
        case .signIn:
            state.hasSigned = true
        case .signOut:
            state.hasSigned = false
        case .showSignOutAlert:
            state.showSignOutAlert = ()
        case .setUploadStatus(let progressStatus):
            state.uploadStatus = progressStatus
        case .setDownloadStatus(let progressStatus):
            state.downloadStatus = progressStatus
        case .showDownloadSuccessAlert:
            state.showDownloadSuccessAlert = ()
        case .showDownloadFailureAlert:
            state.showDownloadFailureAlert = ()
        case .showUploadSuccessAlert:
            state.showUploadSuccessAlert = ()
        case .showUploadFailureAlert:
            state.showUploadFailureAlert = ()
        }

        return state
    }

}
