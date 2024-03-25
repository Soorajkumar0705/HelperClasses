//
//  ViewControllerViewModel.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

import Foundation

extension ViewController {
    
    class ViewControllerViewModel : NSObject{
        
//        private var apiService : APIService!
        
        var bindGetDataSuccessResponseToVC: VoidClosure? = nil
        var bindGetDataFailureResponseToVCWithMessage: PassStringClosure? = nil
        
        
        override init() {
            super.init()
//            self.apiService = APIService()
        }
        
        /*
         
         func getData(){
             apiService.getWebService(endPoint: .test(String, String, String), completion: { [weak self] response, message, success in
                 guard let self else { return }
                 
                 if let response{
                     let newRes = ProfileDataRes.parseData(disc: response)
                     
                     if newRes.statusCode == 200{
                         print("SUCCESS")
                         self.profileData = newRes.data?.toActiveProfile()
                     }else{
                         print("ERROR")
                         self.bindGetUserBikeFailureResponseToVCWithMessage?(newRes.message ?? "ERROR")
                     }
                     
                 }else{
                     self.bindOTAUpdateFailureResponseToVCWithMessage?(StringScheme.noInternetConnectionPleaseTryAgain)
                 }
             })  // getWebService
         }   // getUserBike
         
         
         */
        
    }
    
    struct Test {
        
        var testName : String?
        var test2 : Test2?
        
        static func parseData(disc : StringAnyDict) -> Self{
            var obj = Self()
            
            obj.testName = disc["testName"] as? String
            obj.test2 = Test2.parseData(disc: disc["test2"] as? StringAnyDict ?? [:])
            
            return obj
        }
    }
    
    struct Test2{
        var testName : String?
        var testArray : [TestArray] = []
        
        static func parseData(disc : StringAnyDict) -> Self{
            var obj = Self()
            
            obj.testName = disc["testName"] as? String
            obj.testArray = TestArray.parseData(discs: disc["testArray"] as? StringAnyDictArray ?? [])
            
            return obj
        }
    }
    
    struct TestArray{
        
        var testName : String?
        
        static func parseData(disc : StringAnyDict) -> Self{
            var obj = Self()
            
            obj.testName = disc["testName"] as? String
            
            return obj
        }
        
        static func parseData(discs : StringAnyDictArray) -> [Self] {
            discs.compactMap({ Self.parseData(disc: $0) })
        }
        
    }   // TestArray
    
    
}
