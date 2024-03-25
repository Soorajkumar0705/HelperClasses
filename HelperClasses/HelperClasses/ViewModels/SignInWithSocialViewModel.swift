//
//  SignInWithSocialViewModel.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

/*
 
 import Foundation
 import FirebaseCore
 import FirebaseAuth
 import GoogleSignIn
 import AuthenticationServices


 //private var viewController:UIViewController!

 fileprivate var appleSignInRequestClosure : ((LoginVC.SignUpRequest) -> Void)? = nil
 fileprivate var appleSignInErrorHandler : PassStringClosure? = nil


 extension LoginVC{
     
     class SignInWithSocialViewModel : NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
         
         private var apiService : APIService!
         
         override init() {
             super.init()
             self.apiService = APIService()
             configureAuth()
             
         }
         
         private func configureAuth(){
             guard let clientID = FirebaseApp.app()?.options.clientID else { return }
             
             // Create Google Sign In configuration object.
             let config = GIDConfiguration(clientID: clientID)
             GIDSignIn.sharedInstance.configuration = config
         }
         
         func callFuncToGoogleSignIn(in vc : UIViewController, completion: ((LoginVC.SignUpRequest) -> Void)? = nil, error errorHandler: PassStringClosure? = nil) {
             GIDSignIn.sharedInstance.signIn(withPresenting: vc) { [weak self] result, error in
               guard let _ = self, error == nil else {
                   
                   errorHandler?(error?.localizedDescription ?? "Error")
                   print("Error Found \(String(describing: error))" )
                   return
               }

               guard let user = result?.user,
                     let idToken = user.idToken?.tokenString,
                     let userID = user.userID
               else {
                   print("Error : User Not Found ")
                   return
               }
                 
                 print("User : - \(user) \n","userID - - \(userID)\n", "idToken : - \(idToken) \n")
             
               let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                              accessToken: user.accessToken.tokenString)
                 print("Credetinal ", credential)
                 
                 Auth.auth().signIn(with: credential) { result, error in
                     
                     guard let result , error == nil else{
                         print("ERROR Found ")
                         return
                     }
                     // At this point, our user is signed in
                     var signUpReq = LoginVC.SignUpRequest()
                     
                     signUpReq.firstName = result.user.displayName
                     signUpReq.lastName = ""
                     signUpReq.email = result.user.email
                     signUpReq.mobileNo = Int(result.user.phoneNumber ?? "1234556789")
                     signUpReq.password = idToken
 //                    signUpReq.signUpType = .GoogleSignUp
                     
                     do {
                       try Auth.auth().signOut()
                     } catch let signOutError as NSError {
                       print("Error signing out: %@", signOutError)
                     }
                     
                     completion?(signUpReq)
                     
                     print("Sign in successfull...")
                   } // Auth.auth().signIn
             }   // GIDSignIn.sharedInstance.signIn
         }   // callFuncToGoogleSignIn
         
         // APPLE SIGNIN :
         
         func callFuncToAppleSignIn(completion: ((LoginVC.SignUpRequest) -> Void)? = nil, error errorHandler: PassStringClosure? = nil) {
             
             appleSignInRequestClosure = completion
             appleSignInErrorHandler = errorHandler
             
             let appleIDProvider = ASAuthorizationAppleIDProvider()
             let request = appleIDProvider.createRequest()
             request.requestedScopes = [.fullName, .email]
             let authorizationController = ASAuthorizationController(authorizationRequests: [request])
             authorizationController.delegate = self
             authorizationController.presentationContextProvider = self
             authorizationController.performRequests()
         }
         
         func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
             return (AppDelegate.getAppDelegateRef()?.getActiveVC()!.view.window!)!
         }
         
         func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
             if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
                 let userIdentifier = appleIDCredential.user
                 let fullName = appleIDCredential.fullName?.givenName
                 let email = appleIDCredential.email
                 let idToken = NSString(data: appleIDCredential.identityToken!, encoding: String.Encoding.utf8.rawValue)
                 let appleIDProvider = ASAuthorizationAppleIDProvider()
                 appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                     switch credentialState {
                     case .authorized:
                         // The Apple ID credential is valid.
                         print("Name: \(fullName ?? "Nil")  Email: \(email ?? "Nil")")
                         guard let idToken = idToken as? String else {
                         appleSignInErrorHandler?("296") // some random error code to detect if user has hidden thier email
                             return
                         }
                         
                         // At this point, our user is signed in
                         var signUpReq = LoginVC.SignUpRequest()
                         
                         signUpReq.firstName = fullName
                         signUpReq.lastName = ""
                         signUpReq.email = email
                         signUpReq.mobileNo = Int("0") ?? 0
                         signUpReq.password = idToken
                         
                         appleSignInRequestClosure?(signUpReq)
                         appleSignInRequestClosure = nil

                         break
                     case .revoked:
                         // The Apple ID credential is revoked.
                         break
                     case .notFound:
                         break
                         // No credential was found, so show the sign-in UI.
                     default:
                         break
                     }
                 }
             }
         }
         
         func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
             // Handle error.
             appleSignInErrorHandler?(error.localizedDescription)
             appleSignInErrorHandler = nil
             print("Error found while Apple sign in.",error)
         }
         
     }   // SignInWithSocialViewModel
 }   // LoginVC


 */
