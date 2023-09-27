//
//  GoogleDriveAPI.swift
//  GoogleDrivePlatform
//
//  Created by Jaewon Yun on 2023/09/25.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Drive
import GoogleSignIn

enum GoogleDriveAPIError: Error {

    case unknownError

}

struct GoogleDriveAPI {

    let service: GTLRDriveService = .init()

    init(user: GIDGoogleUser) {
        self.service.authorizer = user.authentication.fetcherAuthorizer()
    }

    /// Method: files.create
    @discardableResult
    func create(for file: GTLRDrive_File, with data: Data) async throws -> GTLRDrive_File {
        let parameters = GTLRUploadParameters(data: data, mimeType: "application/octet-stream")
        parameters.shouldUploadWithSingleRequest = true

        let query: GTLRDriveQuery_FilesCreate = .query(withObject: file, uploadParameters: parameters)

        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { _, file, error in
                if error == nil, let file = file as? GTLRDrive_File {
                    continuation.resume(returning: file)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: GoogleDriveAPIError.unknownError)
                }
            }
        }
    }

    /// Method: files.list
    func filesList(query: GTLRDriveQuery_FilesList) async throws -> GTLRDrive_FileList {
        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { _, fileList, error in
                if error == nil, let fileList = fileList as? GTLRDrive_FileList {
                    continuation.resume(returning: fileList)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: GoogleDriveAPIError.unknownError)
                }
            }
        }
    }

    /// Method: files.get
    func files(forFileID fileID: String) async throws -> GTLRDataObject {
        let query: GTLRDriveQuery_FilesGet = .queryForMedia(withFileId: fileID)

        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { _, file, error in
                if error == nil, let dataObject = file as? GTLRDataObject {
                    continuation.resume(returning: dataObject)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: GoogleDriveAPIError.unknownError)
                }
            }
        }
    }

}
