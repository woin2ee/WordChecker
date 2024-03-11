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

/// <#Description#>
public final class GoogleDriveAPI {

    let service: GTLRDriveService
    
    public let files: GoogleDriveFilesAPI
    
    public init(authentication: GIDAuthentication?) {
        self.service = .init()
        self.service.authorizer = authentication?.fetcherAuthorizer()
        self.files = .init(service: self.service)
    }
}

/// <#Description#>
public struct GoogleDriveFilesAPI {
    
    let service: GTLRDriveService
    
    init(service: GTLRDriveService) {
        self.service = service
    }
    
    /// Method: files.create
    @discardableResult
    public func create(_ file: GTLRDrive_File, with data: Data) async throws -> GTLRDrive_File {
        let uploadParameters = GTLRUploadParameters(data: data, mimeType: "application/octet-stream")
        uploadParameters.shouldUploadWithSingleRequest = true

        let query: GTLRDriveQuery_FilesCreate = .query(withObject: file, uploadParameters: uploadParameters)

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
    public func list(query: GTLRDriveQuery_FilesList) async throws -> GTLRDrive_FileList {
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
    public func get(forFileID fileID: String) async throws -> GTLRDataObject {
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

    /// Method: files.delete
    public func delete(byFileID fileID: String) async throws {
        let query: GTLRDriveQuery_FilesDelete = .query(withFileId: fileID)

        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
