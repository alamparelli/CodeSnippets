# Detailed Snippet Documentation

This document contains the full code and details for each snippet.

---

## Class - Cache

**Language:** Swift  
**Completion Shortcut:** `snpt_Cache class`  
**Description:** Small class that implement simple cache  
**File:** `0AB6FE20-1BE4-44A6-8947-C8C28089EB04.codesnippet`  

```swift
// Small class that implement simple cache

class Cache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]
    
    /// Save a key, value pair into the cache
    /// - Parameters:
    ///   - value: Any Hashable
    ///   - key: Any Type
    func save(_ value: Value, for key: Key) {
        storage[key] = value
    }
    
    /// retrieve the value from key
    /// - Parameter key: Any Hashable
    /// - Returns: Any Type defined
    func get(for key: Key) -> Value? {
        return storage[key]
    }
    
    /// Remove a key, value from cache
    /// - Parameter key: Any Hashable
    func remove(for key: Key) {
        storage[key] = nil
    }
    
    /// Clean the Cache completely
    func clear() {
        storage.removeAll()
    }
}
```

---

## Class - Log

**Language:** Swift  
**Completion Shortcut:** `snpt_Log class`  
**File:** `F77DE186-A636-426A-8CF7-5235A9B82B9D.codesnippet`  

```swift
class Log<T> {
    struct Entry {
        let id: UUID = UUID()
        let value: T
        let date: Date = Date()
    }
    
    private var storage: [Entry] = []
    
    func log(_ value: T) {
        let entry = Entry(value: value)
        storage.append(entry)
    }
    
    func getAllLogs() -> [Entry] {
        return storage
    }
    
    func clearLogs() {
        storage.removeAll()
    }
}
```

---

## Class - SoundService

**Language:** Swift  
**Completion Shortcut:** `snpt_SoundService class`  
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

## Enum - Secret

**Language:** Swift  
**Completion Shortcut:** `snpt_enum_Secrets`  
**File:** `D6CF1BC6-F8A8-4ABB-A2C1-12580FD6B8BB.codesnippet`  

```swift
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

## Extension - Bundle

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

## Extension - ShapeStyle Background

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

## Extension - UIApplication Release/Build/AppVersion

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

## Function - Decode API Response

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

## Other - DispatchQueueMain

**Language:** Swift  
**Completion Shortcut:** `snpt_dispatch`  
**File:** `6705E353-8DDE-4CFF-862F-2217E007C3E2.codesnippet`  

```swift
DispatchQueue.main.asyncAfter(deadline: .now() + <#Double#>) {
    <#Operations#>
}
```

---

## Other - FaceID

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

