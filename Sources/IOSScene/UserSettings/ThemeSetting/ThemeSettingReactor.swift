import IOSSupport
import ReactorKit
import UIKit
import UseCase_UserSettings

final class ThemeSettingReactor: Reactor {

    enum Action {
        case viewDidLoad
        case selectStyle(UIUserInterfaceStyle)
    }

    enum Mutation {
        case setStyle(UIUserInterfaceStyle)
    }

    struct State {
        var selectedStyle: UIUserInterfaceStyle
    }

    var initialState: State = .init(selectedStyle: .unspecified)

    let userSettingsUseCase: UserSettingsUseCase
    let globalState: GlobalState

    init(userSettingsUseCase: UserSettingsUseCase, globalState: GlobalState) {
        self.userSettingsUseCase = userSettingsUseCase
        self.globalState = globalState
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return userSettingsUseCase.getCurrentUserSettings()
                .asObservable()
                .map(\.themeStyle)
                .map { $0.toUIKit() }
                .map(Mutation.setStyle)

        case .selectStyle(let selectedStyle):
            return userSettingsUseCase.updateThemeStyle(selectedStyle.toDomain())
                .asObservable()
                .doOnNext {
                    self.globalState.themeStyle.accept(selectedStyle)
                }
                .map { Mutation.setStyle(selectedStyle) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setStyle(let selectedStyle):
            state.selectedStyle = selectedStyle
        }

        return state
    }

}
