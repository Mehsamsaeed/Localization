//
//  LacalizationManger.swift
//  Localization
//
//  Created by Mehsam Saeed on 11/10/2023.
//

import Foundation
import Foundation
import UIKit

protocol LocalizationDelegate: AnyObject {
    func resetApp()
}

class LocalizationManager: NSObject {
    enum LanguageDirection {
        case leftToRight
        case rightToLeft
    }
    
    enum Language: String {
        case English = "en"
        case Arabic = "ar"
    }
    
    static let shared = LocalizationManager()
    private var languageDictionary: [String:String] = [:]
    var enableRTL:Bool = true
    private var languageKey = "UKPrefLang"
    weak var delegate: LocalizationDelegate?
    
    // get currently selected language from el user defaults
    func getLanguage() -> Language? {
        if let languageCode = UserDefaults.standard.string(forKey: languageKey), let language = Language(rawValue: languageCode) {
            return language
        }
        return nil
    }
    
    // check if the language is available
    private func isLanguageAvailable(_ code: String) -> Language? {
        var finalCode = ""
        if code.contains("ar") {
            finalCode = "ar"
        } else if code.contains("en") {
            finalCode = "en"
        }
        return Language(rawValue: finalCode)
    }
    
    // check the language direction
    private func getLanguageDirection() -> LanguageDirection {
        if let lang = getLanguage() {
            switch lang {
            case .English:
                return .leftToRight
            case .Arabic:
                return .rightToLeft
            }
        }
        return .leftToRight
    }
    
    // get localized string for a given code from the dictionary
    func localizedString(for key: String, value comment: String) -> String {
        let localized = languageDictionary[key] ?? key
        return localized
    }
    
    // set language for localization
    func setLanguage(language: Language) {
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "plist"),let keyValue = NSDictionary(contentsOfFile: path) as? [String:String] {
            languageDictionary = keyValue
        }
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)
        UserDefaults.standard.synchronize()
       
            resetApp()
    
       
    }
    
    
    // reset app for the new language
    func resetApp() {
        if enableRTL{
            let dir = getLanguageDirection()
            var semantic: UISemanticContentAttribute!
            switch dir {
            case .leftToRight:
                semantic = .forceLeftToRight
            case .rightToLeft:
                semantic = .forceRightToLeft
            }
            UITabBar.appearance().semanticContentAttribute = semantic
            UIView.appearance().semanticContentAttribute = semantic
            UINavigationBar.appearance().semanticContentAttribute = semantic
        }
        delegate?.resetApp()
        
    }
    
    // configure startup language
    func setAppInnitLanguage(enableRTL: Bool ) {
        self.enableRTL = enableRTL
        if let selectedLanguage = getLanguage() {
            setLanguage(language: selectedLanguage)
        } else {
            // no language was selected
            let languageCode = Locale.preferredLanguages.first
            if let code = languageCode, let language = isLanguageAvailable(code) {
                setLanguage(language: language)
            } else {
                // default fall back
                setLanguage(language: .English)
            }
        }
        resetApp()
    }
}

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self, value: "")
    }
}

extension SceneDelegate: LocalizationDelegate {
    func resetApp() {
        guard let window = window else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ViewController")
        window.rootViewController = vc
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: nil, completion: nil)
    }
}
