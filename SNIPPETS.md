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

## Class - NavigationService

**Language:** Swift  
**Completion Shortcut:** `snpt_class_navigation`  
**Description:** Navigation Class  
**File:** `547DEF76-9566-4645-B210-8632381165A8.codesnippet`  

```swift
import SwiftUI

enum Destination: Hashable {
    case main
    case settings
    // fill other depending your needs
}

@Observable
class NavigationService {
    var path = NavigationPath()
    
    @ViewBuilder
    func returnView(_ destination : Destination) -> some View {
        switch destination {
        case .main:
            MainView()
        case .settings:
            SettingsView()
        //fill depending Enum definition above
        }
    }
    
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}

/// Usage
/// In App.swift
/// Not needed to add NavigationStack in sub views
/* SETUP
 import SwiftUI

 @main
 struct App: App {
     @State private var navigation = NavigationService()
     
     var body: some Scene {
         WindowGroup {
             NavigationStack(path: $navigation.path) {
                 ContentView()
                     .navigationDestination(for: Destination.self) { destination in
                         navigation.returnView(destination)
                     }
                 }
                 .environment(navigation)
         }
     }
 }
*/

/* USAGE on sub Views
 Button("Main") {
    navigation.navigate(to: Destination.main)
 }

 NavigationLink(value: Destination.main) {
     Text("Main")
 }
*/
```

---

## Class - SimpleDatabaseFile

**Language:** Swift  
**Completion Shortcut:** `snpt_class_SimpleDatabaseFile`  
**File:** `FF1FC9D9-719F-4131-9EE7-58535628ACB6.codesnippet`  

```swift
import SwiftUI

@Observable
class SimpleDatabaseFile<T: Codable & Hashable>  {
    private var database: Set<T>
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    private let savePath: URL
    
    init(key: String, database: Set<T> = []) {
        self.savePath = URL.documentsDirectory.appending(path: "\(key)-DatabaseFile")
        self.database = database
        
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? decoder.decode(Set<T>.self, from: data) {
                self.database = decoded
            }
        }
    }
    
    func contains(_ item: T) -> Bool {
        database.contains(item)
    }
    
    func add(_ item: T){
        database.insert(item)
        save()
    }
    
    func remove(_ item: T){
        database.remove(item)
        save()
    }
    
    func save() {
        do {
            let data = try encoder.encode(database)
            try data.write(to: savePath)
        } catch {
            print("Failed to save to pathfile \(savePath)")
        }
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
// content of Secrect config is similar to this
// API_KEY=Your_Secret_API_key
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

## Extension - View - Template

**Language:** Swift  
**Completion Shortcut:** `snpt_extension_view_template`  
**Description:** base template for an Extension  
**File:** `8B2E6D80-41F2-44E7-91BA-FC6E3067E7F9.codesnippet`  

```swift
extension <#View#> {
    func <#functionName#>(<#args#>) -> some View {
        <#something#>
        return self<#something#>
    }
}
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

## Other - Comparable

**Language:** Swift  
**Completion Shortcut:** `snpt_comparable_static_func`  
**Description:** Static Function  
**File:** `B8CDA363-C615-4855-ADBD-6E9CC6D9346C.codesnippet`  

```swift
public static func < (lhs: <#Type#>, rhs: <#Type#>) -> Bool {
    return lhs.<#property#> < rhs.<#property#>
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

## Other - Timer

**Language:** Swift  
**Completion Shortcut:** `snpt_other_timer`  
**Description:** Small Snippet to create a TImer on a view  
**File:** `B546DEBB-314A-42FB-95E2-4B586690CEDD.codesnippet`  

```swift
    // create Timer
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    // on View
    .onReceive(timer) { time in
        guard isActive else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
        }
    }
```

---

## SwiftData - Store Color

**Language:** Swift  
**Completion Shortcut:** `snpt_swiftdata_store color`  
**Description:** Exemple of storing a color in SwiftData  
**File:** `D7134E08-B0DF-4E84-95FE-A39DBFC6943E.codesnippet`  

```swift
import SwiftData

@Model
class Item {
    var red: Double?
    var green: Double?
    var blue: Double?
    var opacity: Double?
    
    init(color: Color) {
        self.red = 0
        self.green = 0
        self.blue = 0
        self.opacity = 1
        self.color = color // This will set the RGB values
    }
    
    // Computed property for easy Color access
    var color: Color {
        get {
            Color(red: red ?? 0, green: green ?? 0, blue: blue ?? 0, opacity: opacity ?? 1)
        }
        set {
            // Convert Color to RGBA components
            if let components = UIColor(newValue).cgColor.components {
                red = Double(components[0])
                green = Double(components[1])
                blue = Double(components[2])
                opacity = Double(components.count > 3 ? components[3] : 1.0)
            }
        }
    }
}
```

---

## View - ImageBlurredView

**Language:** Swift  
**Completion Shortcut:** `snpt_view_blurredImage`  
**Description:** ScrollView with Blurred Image at Top  
**File:** `4FC71F07-6ECD-4049-A3FF-E9AB4202D9A8.codesnippet`  

```swift
// source : https://stackoverflow.com/questions/68138347/swiftui-add-blur-linear-gradient
struct <#ImageBlurredView#>: View {    
    var body: some View {
        ScrollView {
            Image("<#image#>") //to be adapted
                .resizable()
//                .scaledToFit()
                .clipped()
                .frame(maxHeight: <#600#>)
                .mask {
                    VStack{
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(1),
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                }

//            VStack {
//                Text("Text")
//                    .foregroundStyle(.white)
//            }
        }
        .background(.black)
        .ignoresSafeArea(edges: .top)
    }
}
```

---

