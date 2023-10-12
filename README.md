# Localization
Localization
Project contain localisation manager and example how to use
Feature
1 do not need to add localise file  
2 you can controll where you implement RTL or not on bas of language set 

How to use 
Intlize from didFinishLaunchingWithOptions with options or scene delegate like this

LocalizationManager.shared.delegate = self
LocalizationManager.shared.setAppInnitLanguage(enableRTL: false)
