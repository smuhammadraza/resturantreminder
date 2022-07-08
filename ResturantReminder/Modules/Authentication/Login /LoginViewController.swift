//
//  LoginViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 07/12/2021.
//

import UIKit
import Presentr
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit
import AVFoundation

class LoginViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var facebookBtn: FBLoginButton!
    
    // MARK: - VARIABLES
    var viewModel = LoginViewModel()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectFields()
        self.setupFacebookCustomBtn()
    }
    
    // MARK: - SETUP VIEW
    private func connectFields() {
        UITextField.connectFields(fields: [self.textFieldEmail, self.textFieldPassword])
    }
    
    private func setupFacebookCustomBtn() {
        facebookBtn.delegate = self
        facebookBtn.permissions = ["email", "public_profile"]
        setupFacebookButton()
        
        let customFBBtn = UIButton()
        customFBBtn.backgroundColor = .clear
        customFBBtn.setImage(#imageLiteral(resourceName: "LoginFBIcon"), for: .normal)
        customFBBtn.setImage(#imageLiteral(resourceName: "LoginFBIcon"), for: .selected)
        customFBBtn.setImage(#imageLiteral(resourceName: "LoginFBIcon"), for: .highlighted)
        customFBBtn.frame = facebookBtn.frame
        facebookBtn.addSubview(customFBBtn)
        
        customFBBtn.addTarget(self, action: #selector(handleCustomFBBtn), for: .touchUpInside)
    }

    private func setupFacebookButton() {
        for controlState: UIControl.State in [.normal, .selected, .highlighted] {
            facebookBtn.setImage(nil, for: controlState)
            facebookBtn.setBackgroundImage(nil, for: controlState)
        }
    }
    
    // MARK: - FACEBOOK HELPER METHODS

    @objc func handleCustomFBBtn() {
        UIApplication.startActivityIndicator(with: "")
        LoginManager().logIn(permissions: ["email", "public_profile", "user_photos"], viewController: self) { [weak self] (result) in

            guard let self = self else { return }
            
            switch result {
            case .success(granted: let granted, declined: let declined, token: let accessToken):
                print(accessToken?.tokenString)
                print(granted, declined)
                if let token = accessToken?.tokenString {
                    self.FBLoginToFirebase(token: token)
                } else {
                    Snackbar.showSnackbar(message: "Couldn't fetch token, Try again later.", duration: .short)
                    UIApplication.stopActivityIndicator()
                }
            case .failed(let error):
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .short)
                print(error.localizedDescription)
            case .cancelled:
                UIApplication.stopActivityIndicator()
                break
            }
        }
        
    }
    
    private func FBLoginToFirebase(token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                _ = error as NSError
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
                return
            }
            if let authResult = authResult {
                print(authResult.user)
                FirebaseManager.shared.addUser(userID: authResult.user.uid, fullName: authResult.user.displayName ?? "", postalCode: "", email: authResult.user.email ?? "")
                FirebaseManager.shared.fetchUser(userID: authResult.user.uid) { error  in
                    if let error = error {
                        UIApplication.stopActivityIndicator()
                        Snackbar.showSnackbar(message: error, duration: .middle)
                        return
                    } else {
                        UIApplication.stopActivityIndicator()
                        AppDefaults.currentUser = UserModel.shared
                        AppDefaults.loggedInFromFacebook = true
                        authResult.user.getIDToken(completion: { result, error in
                            if let error = error {
                                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
                                return
                            }
                            guard let result = result else { return }
                            AppDefaults.facebookToken = result
                            let request = GraphRequest.init(graphPath: "/me/feed", httpMethod: .post) //5305988979430789
                            request.parameters = [
                                "source": Data(),
                                "message": "This is a test post"
                            ]
                            request.start { connection, result, error in
                                print(connection, result, error)
                            }
                            print(result)
                        })
                        AppDefaults.isUserLoggedIn = true
                        Bootstrapper.showHome()
                    }
                }
            }
            print(authResult)
        }
    }
        
    private func showFBUserData() {
        GraphRequest(graphPath: "/me", parameters: ["field": "id, name, email"]).start { (connection, result, error) in
            if let error = error {
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .short)
                return
            }
            if let result = result {
                
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @IBAction func didTapShowHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.textFieldPassword.isSecureTextEntry = sender.isSelected
    }
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        UIApplication.startActivityIndicator(with: "Logging in..")
        viewModel.loginUser(email: self.textFieldEmail.text ?? "", password: self.textFieldPassword.text ?? "") { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let error = error {
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
                return
            } else {
                FirebaseManager.shared.fetchUser(userID: authResult?.user.uid ?? "") { error  in
                    if let error = error {
                        UIApplication.stopActivityIndicator()
                        Snackbar.showSnackbar(message: error, duration: .middle)
                        return
                    } else {
                        UIApplication.stopActivityIndicator()
                        AppDefaults.currentUser = UserModel.shared
                        AppDefaults.isUserLoggedIn = true
                        AppDefaults.fromLogin = true
                        Bootstrapper.showHome()
                    }
                }
                //                print("Auth Result: \(authResult)")
                //                Bootstrapper.showHome()
            }
        }
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        let vc = SignUpViewController.initFromStoryboard(name: Constants.Storyboards.authentication)
        let presenter = Presentr.init(presentationType: .custom(width: .fluid(percentage: 1.0),
                                                                height: .fluid(percentage: 0.9), center: .customOrigin(origin: CGPoint.init(x: 0, y: 60))))
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    @IBAction func didTapForgotPasswordButton(_ sender: UIButton) {
        let vc = ForgotPasswordViewController.initFromStoryboard(name: Constants.Storyboards.authentication)
        let presenter = Presentr.init(presentationType: .custom(width: .fluid(percentage: 1.0),
                                                                height: .fluid(percentage: 1.0), center: .customOrigin(origin: CGPoint.init(x: 0, y: 40))))
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    
    @IBAction func facebookLoginTapped(_ sender: UIButton) {
        //        Authentication.sharedInstance().facebookLogin(fromVC: self) { [weak self] (userId, accessToken, check) in
        //
        //        }
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
//            if let error = error {
//                print("Encountered Erorr: \(error)")
//            } else if let result = result, result.isCancelled {
//                print("Cancelled")
//            } else {
//                print("Logged In")
//            }
//        }
    }
    
    @IBAction func gmailLoginTapped(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: Constants.googleClientID)
        UIApplication.startActivityIndicator(with: "")
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self
        ) { user, error in
            if let error = error {
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else {
                UIApplication.stopActivityIndicator()
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    print(error.localizedDescription)
                    UIApplication.stopActivityIndicator()
                    Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
                    return
                }
                if let authResult = authResult {
                    print(authResult.user)
                    FirebaseManager.shared.addUser(userID: authResult.user.uid, fullName: authResult.user.displayName ?? "", postalCode: "", email: authResult.user.email ?? "")
                    FirebaseManager.shared.fetchUser(userID: authResult.user.uid) { error  in
                        if let error = error {
                            UIApplication.stopActivityIndicator()
                            Snackbar.showSnackbar(message: error, duration: .middle)
                            return
                        } else {
                            UIApplication.stopActivityIndicator()
                            AppDefaults.currentUser = UserModel.shared
                            AppDefaults.isUserLoggedIn = true
                            Bootstrapper.showHome()
                        }
                    }
                }
            }
        }
    }
    
}


extension LoginViewController: StoryboardInitializable {}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
//            UIApplication.stopActivityIndicator()
//            Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
            return
        }
//        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//        Auth.auth().signIn(with: credential) { authResult, error in
//            if let error = error {
//                _ = error as NSError
//                UIApplication.stopActivityIndicator()
//                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
//                return
//            }
//            if let authResult = authResult {
//                print(authResult.user)
//                FirebaseManager.shared.addUser(userID: authResult.user.uid, fullName: authResult.user.displayName ?? "", postalCode: "", email: authResult.user.email ?? "")
//                FirebaseManager.shared.fetchUser(userID: authResult.user.uid) { error  in
//                    if let error = error {
//                        UIApplication.stopActivityIndicator()
//                        Snackbar.showSnackbar(message: error, duration: .middle)
//                        return
//                    } else {
//                        UIApplication.stopActivityIndicator()
//                        AppDefaults.currentUser = UserModel.shared
//                        AppDefaults.isUserLoggedIn = true
//                        Bootstrapper.showHome()
//                    }
//                }
//            }
//            print(authResult)
//        }
        
    }
}
