//
//  APIService.swift
//  nine09
//
//  Created by Admin on 01/01/24.
//

import Foundation
//import Alamofire

enum EndPoint {

	case homeData
	
}


/*
 
 
 
class APIService :  NSObject {
	static let shared = APIService()

	static var sourcesURL: String {
		if is_live {
			return ""
		}else {
			return ""
		}
	}

	func getUrl(endPoint: EndPoint) -> String {
		switch endPoint {

        case .homeData:
            return APIService.sourcesURL+""
		}
	}

	func getWebService(endPoint : EndPoint, completion : @escaping (_ response : [String: Any]?, _ message: String?, _ success : Bool)-> Void) {
		let url = self.getUrl(endPoint: endPoint)
		let headers:[String:String] = self.setHeaders()
		alamofireFunction(urlString: url, method: .get, paramters: [:], headers:headers) { (response, message, success) in
			if response != nil {
				let resp = Response.parseData(disc: response as! [String: Any])
				completion(response as? [String: Any], resp.message ?? resp.errors, true)
			}else{
				completion(nil, message, false)
			}
		}
	}

	func postWebService(endPoint: EndPoint, params: [String : Any], completion : @escaping (_ response : [String: Any]?, _ message: String?, _ success : Bool)-> Void) {
		let url = getUrl(endPoint: endPoint)
		let headers:[String:String] = self.setHeaders()
		alamofireFunction(urlString: url, method: .post, paramters: params, headers:headers) { (response, message, success) in
			if response != nil {
				let resp = Response.parseData(disc: response as! [String: Any])
				completion(response as? [String: Any], resp.message ?? resp.errors, true)
			}else{
				completion(nil, message, false)
			}
		}
	}
    
    func putWebService(endPoint: EndPoint, params: [String : Any], completion : @escaping (_ response : [String: Any]?, _ message: String?, _ success : Bool)-> Void) {
        let url = getUrl(endPoint: endPoint)
        let headers:[String:String] = self.setHeaders()
        alamofireFunction(urlString: url, method: .put, paramters: params, headers:headers) { (response, message, success) in
            if response != nil {
                let resp = Response.parseData(disc: response as! [String: Any])
                completion(response as? [String: Any], resp.message ?? resp.errors, true)
            }else{
                completion(nil, message, false)
            }
        }
    }

	func deleteWebService(endPoint: EndPoint, params: [String:Any], completion : @escaping (_ response : [String: Any]?, _ message: String?, _ success : Bool)-> Void){
		let url = getUrl(endPoint: endPoint)
		let headers:[String:String] = self.setHeaders()
		alamofireFunction(urlString: url, method: .delete, paramters: params, headers:headers) { (response, message, success) in
			if response != nil {
				let resp = Response.parseData(disc: response as! [String: Any])
				completion(response as? [String: Any], resp.message ?? resp.errors, true)
			}else{
				completion(nil, message, false)
			}
		}
	}

	func alamofireFunction(urlString : String, method : Alamofire.HTTPMethod, paramters : [String : Any], headers : [String : String], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> Void){

		if method == Alamofire.HTTPMethod.post {
			Alamofire.request(urlString, method: .post, parameters: paramters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in

				print(urlString)
				do {
					let request = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
					let jsonString = String(data: request, encoding: String.Encoding.utf8) as String?
					print("JSON REQUEST: \(jsonString ?? "")")

				} catch let error {
					print(error.localizedDescription)
				}

				if response.result.isSuccess{
					print("JSON RESPONSE: \(response.result.value ?? "")")
					completion(response.result.value as AnyObject?, "", true)
				}else{
					print(response.error as Any)
					completion(nil, nil, false)
				}
			}

		}
		else if method == Alamofire.HTTPMethod.get {
			Alamofire.request(urlString, method: .get, parameters: paramters, encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
				print(urlString)
				do {
					let request = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
					let jsonString = String(data: request, encoding: String.Encoding.utf8) as String?
                    print("JSON REQUEST: \(jsonString ?? "")")

				} catch let error {
					print(error.localizedDescription)
				}

				if response.result.isSuccess{
                    print("JSON RESPONSE: \(response.result.value ?? "")")
					completion(response.result.value as AnyObject?, "", true)
				}else{
					completion(nil, nil, false)
				}
			}
		}
		else if method == Alamofire.HTTPMethod.patch {
			Alamofire.request(urlString, method: .patch, parameters: paramters, encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
				print(urlString)
				do {
					let request = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
					let jsonString = String(data: request, encoding: String.Encoding.utf8) as String?
					print("JSON REQUEST: \(jsonString ?? "")")

				} catch let error {
					print(error.localizedDescription)
				}

				if response.result.isSuccess{
					completion(response.result.value as AnyObject?, "", true)
				}else{
					completion(nil, nil, false)
				}
			}
		}
		else if method == Alamofire.HTTPMethod.delete {
			Alamofire.request(urlString, method: .delete, parameters: paramters, encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
				print(urlString)
				do {
					let request = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
					let jsonString = String(data: request, encoding: String.Encoding.utf8) as String?
					print("JSON REQUEST: \(jsonString ?? "")")

				} catch let error {
					print(error.localizedDescription)
				}

				if response.result.isSuccess{
					completion(response.result.value as AnyObject?, "", true)
				}else{
					completion(nil, nil, false)
				}
			}
		}
        else if method == Alamofire.HTTPMethod.put {
            Alamofire.request(urlString, method: .put, parameters: paramters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in

                print(urlString)
                do {
                    let request = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
                    let jsonString = String(data: request, encoding: String.Encoding.utf8) as String?
                    print("JSON REQUEST: \(jsonString ?? "")")

                } catch let error {
                    print(error.localizedDescription)
                }

                if response.result.isSuccess{
                    print("JSON RESPONSE: \(response.result.value ?? "")")
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    print(response.error as Any)
                    completion(nil, nil, false)
                }
            }

        }
		else {
			Alamofire.request(urlString, headers:headers).responseJSON { (response) in

				if response.result.isSuccess{
					completion(response.result.value as AnyObject?, "", true)
				}else{
					completion(nil, nil, false)
				}
			}
		}
	}

	//Mark: For Setting custom headers
	func setHeaders() -> [String:String] {
		let userDefaults = UserDefaults.standard
		let token:String = userDefaults.value(forKey: "sessionToken") as? String ?? ""
		let deviceToken:String = userDefaults.value(forKey: "deviceToken") as? String ?? ""
		var headers:[String:String] = [:]
		if token != "" {
			headers["Authorization"] = "Bearer \(token)"
		}
		if deviceToken != ""{
			headers["x-device-token"] = "\(deviceToken)"
		}

		headers["accept"] = "*//*"
		headers["Content-Type"] = "application/json"
		debugPrint(headers)
		return headers
	}

}

class Response {
	var code: Int?
	var message: String?
	var status: Int?
	var errors: String?
	var success: String?
	var currentPage: Int?
	var numPages: Int?
	var items: [String: Any]?

	static func parseData(disc: [String: Any]) -> Response {
		let obj = Response()
		obj.code = disc["code"] as? Int
		obj.message = disc["message"] as? String
		obj.status = disc["status"] as? Int
		obj.errors = disc["errors"] as? String
		obj.success = disc["success"] as? String
		obj.currentPage = disc["currentPage"] as? Int
		obj.numPages = disc["numPages"] as? Int
		obj.items = disc["items"] as? [String: Any]
		return obj
	}
}



*/
