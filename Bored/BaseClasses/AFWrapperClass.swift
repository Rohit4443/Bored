//
//  AFWrapperClass.swift
//  Mongotdi
//
//  Created by apple on 21/09/22.
//

import Foundation
import UIKit
import Alamofire
import Branch
import SVProgressHUD

class AFWrapperClass{
    
    static let sharedInstance = AFWrapperClass()
    
    //MARK: For upload image
    
    func requestImagePOSTSURL(_ strURL: String, params: Parameters?, imageKey: String, imageData: Data, success: @escaping (NSDictionary) -> Void, failure: @escaping (NSError) -> Void) {
        guard let url = URL(string: strURL) else {
            print("Invalid URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(AppDefaults.token ?? "", forHTTPHeaderField: "Authorization")
        
        AF.upload(multipartFormData: { multiPart in
            // Add other parameters to the multipart form data
            if let params = params {
                for (key, value) in params {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                }
            }
            
            // Append the image data to the multipart form data
            multiPart.append(imageData, withName: imageKey, fileName: "\(UUID()).jpg", mimeType: "image/jpeg")
            print(multiPart)
        }, with: urlRequest)
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? NSDictionary {
                    success(JSON)
                }
            case .failure(let error):
                failure(error as NSError)
            }
        }
    }

    func requestSignUpInterestPOSTSURL(_ strURL : String, params : Parameters?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print("Param  ====> ",params, "URL ===> ",strURL, "Token ===> ",AppDefaults.token ?? "")
        let url = URL(string: strURL)
        var urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/form-data", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("", forHTTPHeaderField: "Authorization")
        print("AppDefaults.token : \(AppDefaults.token ?? "")")
    //    if AppDefaults.token != nil{
    //    urlRequest.addValue(AppDefaults.token!, forHTTPHeaderField: "access_token")
    //    }
        AF.upload(multipartFormData: { multiPart in
            if params != nil{
                for (key, value) in params!{
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                }
            }
        }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                switch data.result {
                case .success(let value):
                    if let JSON = value as? NSDictionary {
                        success(JSON)
                    }
                case .failure(let error):
                    failure(error as NSError)
                }
            })
    }

    
    //MARK: For Upload multiple images
    func requestMultipleImagesPOST(_ strURL: String, params: Parameters?, imageKeys: [String], imageDatas: [Data], success: @escaping (NSDictionary) -> Void, failure: @escaping (NSError) -> Void) {
        guard let url = URL(string: strURL) else {
            print("Invalid URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(AppDefaults.token ?? "", forHTTPHeaderField: "Authorization")
        
        AF.upload(multipartFormData: { multiPart in
            // Add other parameters to the multipart form data
            if let params = params {
                for (key, value) in params {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                }
            }
            
            // Append the image data to the multipart form data
            for (index, imageData) in imageDatas.enumerated() {
                let imageKey = imageKeys[index]
                multiPart.append(imageData, withName: imageKey, fileName: "\(UUID()).jpg", mimeType: "image/jpeg")
            }
        }, with: urlRequest)
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? NSDictionary {
                    success(JSON)
                }
            case .failure(let error):
                failure(error as NSError)
            }
        }
    }

    
    
    
func requestPOSTSURL(_ strURL : String, params : Parameters?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
    let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
    print("Param  ====> ",params, "URL ===> ",strURL, "Token ===> ",AppDefaults.token ?? "")
    let url = URL(string: strURL)
    var urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue("application/form-data", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue(AppDefaults.token ?? "", forHTTPHeaderField: "Authorization")
    print("AppDefaults.token : \(AppDefaults.token ?? "")")
//    if AppDefaults.token != nil{
//    urlRequest.addValue(AppDefaults.token!, forHTTPHeaderField: "access_token")
//    }
    AF.upload(multipartFormData: { multiPart in
        if params != nil{
            for (key, value) in params!{
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
            }
        }
    }, with: urlRequest)
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { data in
            switch data.result {
            case .success(let value):
                if let JSON = value as? NSDictionary {
                    success(JSON)
                }
            case .failure(let error):
                failure(error as NSError)
            }
        })
}

    func requestPostWithMultiFormData(_ strURL : String, params : [String : Any]?, headers : HTTPHeaders?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        print(params,"Param ====>")
        print(strURL,"URL ====>")
        AF.request(strURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    success(JSON as NSDictionary)
                }
            case .failure(let error):
                let error : NSError = error as NSError
                failure(error)
            }
        }
    }
    
    
    func requestGETURL(_ strURL: String, params : [String : AnyObject]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void) {
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(strURL, "URL******")
        AF.request(urlwithPercentEscapes!, method: .get, parameters: params, encoding: URLEncoding.default , headers: ["Content-Type":"application/form-data","Authorization":AppDefaults.token ?? ""])
            .responseJSON { (response) in
                print("AppDefaults.token  : \(AppDefaults.token ?? "")")
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        success(JSON as NSDictionary)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
            }
    }
    
func svprogressHudShow(view:UIViewController) -> Void{
   SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
   SVProgressHUD.show()
   SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
   //        SVProgressHUD.setForegroundColor(colorsApp.appColor.bordercolor)
   SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
   SVProgressHUD.setRingThickness(4)
   //
   DispatchQueue.main.async {
       view.view.isUserInteractionEnabled = false;
   }
}
func svprogressHudDismiss(view:UIViewController) -> Void{
   SVProgressHUD.dismiss();
   view.view.isUserInteractionEnabled = true;
}
func upload(strURL: String, params: [String: Any],completion:@escaping([String:Any]?,String?) -> Void) {
    print("params = \(params)")
        let headers: HTTPHeaders = [
            "Content-type": "application/form-data",
            "Authorization":AppDefaults.token ?? ""
        ]
    print("AppDefaults.token \(AppDefaults.token)")
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    var index  = 1
                    for i in 0..<temp.count{
                        multiPart.append(temp[i] as! Data, withName: "image\(index)", fileName: "\(UUID()).jpg", mimeType: "image/jpg")
                        index += 1
                    }
                    
                }
                if let image = value as? Data{
                    multiPart.append(image, withName: "image", fileName: "\(UUID()).jpg", mimeType: "image/jpg")
                }
            }
            print(multiPart)
            print(" multiPart = \(multiPart)")
        } ,to: strURL, usingThreshold: UInt64.init(), method: .post, headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
                SVProgressHUD.showProgress(Float(progress.fractionCompleted))
            })
            .responseJSON(completionHandler: { data in
                print("dataIsHere >>>>>> ",data)
                SVProgressHUD.dismiss()
                switch data.result {
                case .success(let value):
                    if let JSON = value as? [String:Any] {
                        completion(JSON,nil)
                    }
                case .failure(let error):
                    completion(nil,"Please check your internet")
                }
            })
    }
    

    
    func uploadDoc(strURL: String, params: [String: Any],firstFile:Data?,secondFile:Data?,secondFileType:String?,firstFileType:String?,completion:@escaping([String:Any]?,String?) -> Void) {
        print("params = \(params)")
            let headers: HTTPHeaders = [
                "Content-type": "application/form-data",
                "Authorization":AppDefaults.token ?? ""
            ]
        print("AppDefaults.token \(AppDefaults.token)")
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in params {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                    
                }
                multiPart.append(firstFile ?? Data(), withName: "images[0]", fileName: "\(UUID().uuidString).\(firstFileType ?? "")", mimeType: firstFileType)
                multiPart.append(secondFile ?? Data(), withName: "images[1]", fileName: "\(UUID().uuidString).\(secondFileType ?? "")", mimeType: secondFileType)

                print(multiPart)
                print(" multiPart = \(multiPart)")
            } ,to: strURL, usingThreshold: UInt64.init(), method: .post, headers: headers)
                .uploadProgress(queue: .main, closure: { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    SVProgressHUD.showProgress(Float(progress.fractionCompleted))
                })
                .responseJSON(completionHandler: { data in
                    print("dataIsHere >>>>>> ",data)
                    SVProgressHUD.dismiss()
                    switch data.result {
                    case .success(let value):
                        if let JSON = value as? [String:Any] {
                            completion(JSON,nil)
                        }
                    case .failure(let error):
                        completion(nil,"Please check your internet")
                    }
                })
        }

 
    
}


class DataDecoder: NSObject {
    class func decodeData<T>(_ data: Data?, type: T.Type) -> T? where T : Decodable {
        guard let data = data else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(type.self, from: data)
            print("decodedData:-\(decodedData) **** \(data.count)")
            return decodedData
        } catch {
            print("error***** \(error)")
            return nil
        }
    }
}
