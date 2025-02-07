//
//  PartyAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/10.
//

import Foundation
import Alamofire

/* 배달파티 신청하기 API의 Request body */
struct JoinPartyInput: Encodable {
    var partyId: Int?
}

/* 신청하기 API의 Response */
struct JoinPartyModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : JoinPartyModelResult?
}
struct JoinPartyModelResult: Decodable {
    var deliveryPartyId: Int?
    var deliveryPartyMemberId: Int?
}

/* 배달파티 방장 삭제 및 교체 */
struct ExitPartyChiefInput: Encodable {
    var partyId: Int?
}
struct ExitPartyChiefModel: Decodable {
    var code: Int?
    var isSuccess : Bool?
    var message : String?
    var result: ExitPartyChiefModelResult?
}
struct ExitPartyChiefModelResult: Decodable {
    var result: String?
}

/* 배달파티 멤버 삭제 및 교체 */
struct ExitPartyMemberInput: Encodable {
    var partyId: Int?
}
struct ExitPartyMemberModel: Decodable {
    var code: Int?
    var isSuccess : Bool?
    var message : String?
    var result: String?
}

/* 배달파티 강제 퇴장 */
struct ForcedExitPartyInput: Encodable {
    var membersId: [Int]?
    var partyId: Int?
}
struct ForcedExitPartyModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ForcedExitPartyModelResult?
}
struct ForcedExitPartyModelResult: Decodable {
    var message: String?
}

/* 배달파티 관련 API 연동 */
class PartyAPI {
    
    /* 파티장이 아닌 유저가 신청하기 눌렀을 때 유저를 partyMember로 추가할 때 사용 */
    public static func requestJoinParty(_ parameter : JoinPartyInput,
                                        completion: @escaping (Bool) -> Void)
    {
        let url = "https://geeksasaeng.shop/delivery-party-member"
        
        AF.request(url, method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: JoinPartyModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 배달파티 신청 성공", result)
                    completion(result.isSuccess!)
                } else {
                    print("DEBUG: 배달파티 신청 실패", result.message!)
                    completion(result.isSuccess!)
                }
            case .failure(let error):
                print("DEBUG: 배달파티 신청 실패", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    public static func exitPartyChief(_ parameter: ExitPartyChiefInput, completion: @escaping (Bool) -> Void) {
        let url = "https://geeksasaeng.shop/delivery-party/chief"
        
        AF.request(url, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
            .validate()
            .responseDecodable(of: ExitPartyChiefModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 방장 파티 나가기 성공", result)
                        completion(true)
                    } else {
                        print("DEBUG: 방장 파티 나가기 실패", result)
                        completion(false)
                    }
                case .failure(let error):
                    print("DEBUG: 방장 파티 나가기 실패", error.localizedDescription)
                    completion(false)
                }
            }
    }
    
    public static func exitPartyMember(_ parameter: ExitPartyMemberInput, completion: @escaping (Bool) -> Void) {
        let url = "https://geeksasaeng.shop/delivery-party/member"
        
        AF.request(url, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
            .validate()
            .responseDecodable(of: ExitPartyMemberModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 파티원 파티 나가기 성공", result)
                        completion(true)
                    } else {
                        print("DEBUG: 파티원 파티 나가기 실패", result)
                        completion(false)
                    }
                case .failure(let error):
                    print("DEBUG: 파티원 파티 나가기 실패", error.localizedDescription)
                    completion(false)
                }
            }
    }
    
    /* 방장이 파티원을 배달파티에서 강제퇴장 */
    public static func forcedExitParty(_ parameter: ForcedExitPartyInput, completion: @escaping (ForcedExitPartyModel?) -> Void) {
        let URL = "https://geeksasaeng.shop//delivery-party-members"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ForcedExitPartyModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 배달파티 강제 퇴장 완료")
                    completion(result)
                } else {
                    print("DEBUG: .success 배달파티 강제 퇴장 실패, ", result.message!)
                    completion(result)
                }
            case .failure(let error):
                print("DEBUG: .failure 배달파티 강제 퇴장 실패, ", error.localizedDescription)
                completion(nil)
            }
        }
    }
}
