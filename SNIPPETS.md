# Detailed Snippet Documentation

This document contains the full code and details for each snippet.

---

## Bundle Extension

**Language:** Swift  
**Completion Shortcut:** `snpt_extension_bundle`  
**Description:** Extension of Bundle to read any Type of Json  
**File:** `A3B3B53F-DEAD-4561-803F-E3812463D56C.codesnippet`  

```swift
extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        
        // This should be probably changed if another situation
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key \(key.stringValue) in \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_ , let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing some \(type) value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle : \(error.localizedDescription)")
        }
    }
}
```

---

## Decode API Response

**Language:** Swift  
**Completion Shortcut:** `snpt_decode_api_response`  
**File:** `5CD2A3FB-7704-4990-BF23-520F96320D35.codesnippet`  

```swift
func decodeAPIResponse<T : Codable>(for data: Data) throws -> T {
    var response: T
    do {
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        decoder.dateDecodingStrategy = .formatted(formatter)
        
        response = try decoder.decode(T.self, from: data)
    } catch {
        throw error
    }
    return response
}
```

---

## DispatchQueueMain

**Language:** Swift  
**Completion Shortcut:** `snpt_dispatch`  
**File:** `6705E353-8DDE-4CFF-862F-2217E007C3E2.codesnippet`  

```swift
DispatchQueue.main.asyncAfter(deadline: .now() + <#Double#>) {
    <#Operations#>
}
```

---

## Enum Secret

**Language:** Swift  
**Completion Shortcut:** `snpt_enum_Secrets`  
**File:** `D6CF1BC6-F8A8-4ABB-A2C1-12580FD6B8BB.codesnippet`  

```swift
import Foundation

enum Secrets {
    static var <#Property#>: String {
        guard let key = Bundle.main.infoDictionary?[<#API_KEY#>] as? String else {
            fatalError("Missing <#String#> in Config")
        }
        return key
    }
}

// You need to create a Secret Config file and add it into Project Configuration
// content of Sectect config is similar to this
// WEATHER_API_KEY=Your_Secret_API_key
```

---

## Extension Background

**Language:** Swift  
**Completion Shortcut:** `snpt_extension_ShapeStyle`  
**Description:** Extension of ShapeStyle to add Colors.XXX  
**File:** `F39F3299-917E-4648-B010-3EF0DA654917.codesnippet`  

```swift
extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: <#Double#>, green: <#Double#>, blue: <#Double#>)
    }
    
    static var lightBackground: Color {
        Color(red: <#Double#>, green: <#Double#>, blue: <#Double#>)
    }
}
```

---

## FaceID

**Language:** Swift  
**Completion Shortcut:** `snpt_faceId`  
**File:** `73075DBD-86B2-4B13-ADE1-79DE0588CB57.codesnippet`  

```swift
import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var showUnableToLogin = false

    var body: some View {
        VStack {
            if isUnlocked {
                Text(<#"Unlocked"#>)
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
        .alert(isPresented: $showUnableToLogin) {
            Alert(title: Text("Unable to Login"),
                  message: Text("We are unable to log you in."),
                  dismissButton: .default(Text("Got it!"))
            )
        }
    }
    
    func authenticateWithPassword() {
        let context = LAContext()
        var error: NSError?
        
        let reason = "We need to unlock your data"

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                if success  {
                    isUnlocked = true
                } else {
                    showUnableToLogin = true
                }
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrCompanion, error: &error) {
            let reason = "We need to unlock your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrCompanion, localizedReason: reason) { success, authenticationError in
                if success  {
                    isUnlocked = true
                } else {
                    authenticateWithPassword()
                }
            }
        } else {
            authenticateWithPassword()
        }
    }
}
```

---

## SoundService

**Language:** Swift  
**Completion Shortcut:** `snpt_SoundServiceClass`  
**Description:** Minimal Sound Service to play a sound  
**File:** `A0089549-F507-4B5F-8AD0-2202470F1AD3.codesnippet`  

```swift
import AVFoundation
import Foundation

// Require Background Mode in Info.plist : Audio, AirPlay and PIP

class SoundService {
    var soundPlayer: AVAudioPlayer?
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "fanfare.mp3", ofType: nil)  else { return }
        
        let url = URL(fileURLWithPath: path)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.play()
        } catch {
            print(error)
        }
    }
}
```

---

## UIApplication Extension Release/Build/AppVersion

**Language:** Swift  
**Completion Shortcut:** `snpt_extension_UIApplication`  
**File:** `215DBE1D-A542-4919-B1A4-1BCE3C4F6292.codesnippet`  

```swift
import Foundation
import UIKit

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}

// USAGE
// Text("release: \(UIApplication.release)")
// Text("build: \(UIApplication.build)")
// Text("version: \(UIApplication.version)")
```

---

