//
//  ViewController.swift
//  OnTheMap
//
//  Created by Oladipupo Oluwatobi on 28/03/2020.
//  Copyright © 2020 Oladipupo Oluwatobi. All rights reserved.
//

import UIKit
import Foundation

final class LoginViewController: UIViewController {
    let warningLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    var studentsLocations = [StudentLocation]()
    
    static var sessionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpLoginView()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func setUpLoginView() {
        let imageView = UIImageView(image: UIImage(named:  "logo-u")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        
        warningLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        warningLabel.numberOfLines = 0
        warningLabel.text = "The email or passord you entered is invalid"
        warningLabel.textColor = .red
        warningLabel.textAlignment = .center
        
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = false
        activityIndicator.alpha = 0
        
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email"
        emailTextField.isUserInteractionEnabled = true
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.text = ""
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.isUserInteractionEnabled = true
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.text = ""
        
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.titleLabel?.font = .systemFont(ofSize: 16)
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        let singUpLabel = UILabel()
        singUpLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        singUpLabel.numberOfLines = 1
        singUpLabel.text = "Don't have an account?"
        singUpLabel.textColor = .black
        singUpLabel.textAlignment = .center
        
        let singUpButton = UIButton()
        singUpButton.backgroundColor = .clear
        singUpButton.setTitle("Sing Up", for: .normal)
        singUpButton.setTitleColor(.systemBlue, for: .normal)
        singUpButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        singUpButton.addTarget(self, action: #selector(handleSingUp), for: .touchUpInside)
        
        let singUpStackView = UIStackView(
            arrangedSubviews: [
                UIView(),
                singUpLabel,
                singUpButton,
                UIView()
            ]
        )
        singUpStackView.translatesAutoresizingMaskIntoConstraints = false
        singUpStackView.axis = .horizontal
        singUpStackView.distribution = .equalCentering
        singUpStackView.alignment = .center
        singUpStackView.spacing = 8
        
        let textFieldsStackView = UIStackView(
            arrangedSubviews: [
                activityIndicator,
                warningLabel,
                emailTextField,
                passwordTextField,
                loginButton,
                singUpStackView
            ]
        )
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fillEqually
        textFieldsStackView.spacing = 6
        
        let stackView = UIStackView(
            arrangedSubviews: [
                imageView,
                textFieldsStackView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 15
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 90),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
        warningLabel.alpha = 0
        setFindLocationButtonEnabled(false)
    }
    
    private func setFindLocationButtonEnabled(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.backgroundColor = isEnabled ? .systemBlue : .systemGray
    }
    
    
    
    private func validateInput(email: String, password: String) -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    private func open(url: URL) {
        let app = UIApplication.shared
        app.open(url, options: [:], completionHandler: nil)
    }
    
    private func setActivityIndicatorOn(_ isOn: Bool) {
        activityIndicator.alpha = isOn ? 1 : 0
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    private func getStudentsLocations() {
        UdacityClient.getStudentsLocations { result in
            switch result {
            case .success(let responseObject):
                let studentsLocations = responseObject.locations
                let mapview = MapViewController(locations: studentsLocations)
                self.navigationController?.pushViewController(mapview, animated: true)
            case.failure(let error):
                self.studentsLocations = []
                print(error)
            }
        }
    }
    @objc func handleLogin() {
        //setActivityIndicatorOn(true)
        
        print("pressed")
        UdacityClient.performSessionIDRequest(username: emailTextField.text ?? "", password:  passwordTextField.text ?? "") { (result) in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    self.getStudentsLocations()
                    //self.getStudentsLocations()
                    print(res.account)
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    UIView.animate(
                        withDuration: 0.2,
                        animations: {
                            self.setActivityIndicatorOn(false)
                            self.warningLabel.alpha = 1
                            self.warningLabel.text = err.localizedDescription
                            
                            print(err.localizedDescription)
                    })
                }
            }
        }
        
    }
    
    @objc func handleSingUp() {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else { return }
        open(url: url)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        warningLabel.alpha = 0
        let currentText = textField.text ?? ""
        guard let replacementRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: replacementRange, with: string)
        
        let isValid: Bool
        if textField == emailTextField {
            isValid = validateInput(email: updatedText, password: passwordTextField.text ?? "")
        } else {
            isValid = validateInput(email: emailTextField.text ?? "", password: updatedText)
        }
        setFindLocationButtonEnabled(isValid)
        return true
    }
}

