//
//  GlassRoomAPI+DefaultImplementations.swift
//  
//
//  Created by Kai Quan Tay on 12/5/23.
//

import Foundation

public extension GlassRoomCreatable {
    static func create(
        params: CreatePathParameters,
        query: CreateQueryParameters,
        data: CreateRequestData,
        completion: @escaping (Result<CreateResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiCreatable,
                          httpMethod: "POST",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: CreateResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomDeletable {
    static func delete(
        params: DeletePathParameters,
        query: DeleteQueryParameters,
        data: DeleteRequestData,
        completion: @escaping (Result<DeleteResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiDeletable,
                          httpMethod: "DELETE",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: DeleteResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomGettable {
    static func get(
        params: GetPathParameters,
        query: GetQueryParameters,
        data: GetRequestData,
        completion: @escaping (Result<GetResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiGettable,
                          httpMethod: "GET",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: GetResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomListable {
    static func list(
        params: ListPathParameters,
        query: ListQueryParameters,
        data: ListRequestData,
        completion: @escaping (Result<ListResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiListable,
                          httpMethod: "GET",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: ListResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomPatchable {
    static func patch(
        params: PatchPathParameters,
        query: PatchQueryParameters,
        data: PatchRequestData,
        completion: @escaping (Result<PatchResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiPatchable,
                          httpMethod: "PATCH",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: PatchResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomUpdatable {
    static func update(
        params: UpdatePathParameters,
        query: UpdateQueryParameters,
        data: UpdateRequestData,
        completion: @escaping (Result<UpdateResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiUpdatable,
                          httpMethod: "PUT",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: UpdateResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomAssigneeModifiable {
    static func modifyAssignees(
        params: ModifyAssigneePathParameters,
        query: ModifyAssigneeQueryParameters,
        data: ModifyAssigneeRequestData,
        completion: @escaping (Result<ModifyAssigneeResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiAssigneeModifiable,
                          httpMethod: "POST",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: ModifyAssigneeResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomAttachmentModifiable {
    static func modifyAttachments(
        params: ModifyAttachmentPathParameters,
        query: ModifyAttachmentQueryParameters,
        data: ModifyAttachmentRequestData,
        completion: @escaping (Result<ModifyAttachmentResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiAttachmentModifiable,
                          httpMethod: "POST",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: ModifyAttachmentResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomReclaimable {
    @available(*, deprecated, message: "This method may not work")
    static func reclaimSubmission(
        params: ReclaimPathParameters,
        query: ReclaimQueryParameters,
        data: ReclaimRequestData,
        completion: @escaping (Result<ReclaimResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiReclaimable,
                          httpMethod: "POST",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: ReclaimResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomReturnable {
    @available(*, deprecated, message: "This method may not work")
    static func returnSubmission(
        params: ReturnPathParameters,
        query: ReturnQueryParameters,
        data: ReturnRequestData,
        completion: @escaping (Result<ReturnResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiReturnable,
                          httpMethod: "POST",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: ReturnResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomSubmittable {
    @available(*, deprecated, message: "This method may not work")
    static func turnInSubmission(
        params: TurnInPathParameters,
        query: TurnInQueryParameters,
        data: TurnInRequestData,
        completion: @escaping (Result<TurnInResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiSubmittable,
                          httpMethod: "POST",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: TurnInResponseData.self,
                          callback: completion)
    }
}

public extension GlassRoomAcceptable {
    static func accept(
        params: AcceptPathParameters,
        query: AcceptQueryParameters,
        data: AcceptRequestData,
        completion: @escaping (Result<AcceptResponseData, Error>) -> Void
    ) {
        APICaller.request(urlString: apiAcceptable,
                          httpMethod: "POST",
                          pathParameters: params.stringDictionaryEncoded(),
                          queryParameters: query.stringDictionaryEncoded(),
                          requestData: data,
                          responseType: AcceptResponseData.self,
                          callback: completion)
    }
}
