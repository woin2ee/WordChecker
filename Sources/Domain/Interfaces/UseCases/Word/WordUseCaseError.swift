//
//  WordUseCaseError.swift
//  Domain
//
//  Created by Jaewon Yun on 2/12/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

public enum WordUseCaseError: Error {

    /// `saveFailed` 에러가 발생한 이유입니다.
    public enum SaveFailureReason {

        /// 저장하려는 단어가 이미 암기 완료 상태입니다.
        case wordStateInvalid

        /// 저장하려는 단어가 중복 단어입니다.
        case duplecatedWord(word: String)

    }

    /// `retrieveFailed` 에러가 발생한 이유입니다.
    public enum RetrieveFailureReason {

        /// 해당 UUID 와 일치하는 단어가 없습니다.
        case uuidInvaild(uuid: UUID)

    }

    /// 단어 저장 실패
    case saveFailed(reason: SaveFailureReason)

    /// 단어 검색 실패
    case retrieveFailed(reason: RetrieveFailureReason)

    /// 현재 암기중인 단어가 없음
    case noMemorizingWords

}
