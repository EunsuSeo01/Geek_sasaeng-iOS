//
//  AdViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/17.
//

import Foundation
import Alamofire

/* 광고 데이터 전체 불러오기 API 호출 */
class AdViewModel {
    public static func requestAd(completion: @escaping ([AdModelResult]?) -> ()) {
        let url = "https://geeksasaeng.shop/commercials"
        AF.request(url, method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: AdModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        completion(result.result ?? [])
                    } else {
                        print("DEBUG: 실패", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                }
            }
    }
}

