#!/usr/bin/env swift

// MARK: - Xcode Snippet Documentation Generator
// This script parses Xcode code snippet files (.codesnippet) and generates
// markdown documentation (README.md and SNIPPETS.md) for easy sharing on GitHub

import Foundation

// MARK: - Data Models

/// Represents a single Xcode code snippet with all its metadata
/// This struct holds all the information extracted from the XML plist file
struct CodeSnippet {
    let identifier: String          // UUID that uniquely identifies this snippet
    let title: String               // Display name of the snippet (e.g., "KeyChain Service")
    let summary: String             // Short description of what the snippet does
    let completionPrefix: String    // The shortcut you type to trigger the snippet (e.g., "snippets")
    let language: String            // Programming language (e.g., "Swift", "Objective-C")
    let contents: String            // The actual code content of the snippet
    let fileName: String            // The original .codesnippet filename

    /// Computed property that extracts just the language name without the full Xcode identifier
    /// Example: "Xcode.SourceCodeLanguage.Swift" becomes "Swift"
    var languageShort: String {
        // Split by "." and take the last component
        return language.components(separatedBy: ".").last ?? language
    }

    /// Computed property that determines if this snippet has meaningful content
    /// Empty snippets or "My Code Snippet" templates are considered invalid
    var isValid: Bool {
        return !title.isEmpty &&
               !contents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               title != "My Code Snippet" // Filter out default templates
    }
}

// MARK: - XML Parser Delegate

/// Custom XML parser that extracts data from Xcode's plist format
/// Xcode snippets are stored as XML property lists (plists) with a specific structure
class SnippetParser: NSObject, XMLParserDelegate {

    // Properties to track parsing state
    private var currentElement = ""           // The XML element we're currently parsing
    private var currentKey = ""               // The plist key we're currently reading
    private var currentValue = ""             // Accumulates character data for the current element

    // Storage for extracted snippet data - these will be populated as we parse
    var identifier = ""
    var title = ""
    var summary = ""
    var completionPrefix = ""
    var language = ""
    var contents = ""

    // MARK: XMLParserDelegate Methods

    /// Called when the parser encounters an opening XML tag
    /// We use this to know what type of data is coming next
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentValue = "" // Reset the value accumulator
    }

    /// Called when the parser encounters text content between XML tags
    /// This is where we actually collect the data (titles, code, etc.)
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }

    /// Called when the parser encounters a closing XML tag
    /// This is where we save the accumulated data to the appropriate property
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {

        // Trim whitespace from the accumulated value
        let trimmedValue = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)

        // In plist format, <key> tags tell us what the next <string> value represents
        if elementName == "key" {
            currentKey = trimmedValue
        }
        // When we hit a <string> tag, save its content based on the previous <key>
        else if elementName == "string" {
            switch currentKey {
            case "IDECodeSnippetIdentifier":
                identifier = trimmedValue
            case "IDECodeSnippetTitle":
                title = trimmedValue
            case "IDECodeSnippetSummary":
                summary = trimmedValue
            case "IDECodeSnippetCompletionPrefix":
                completionPrefix = trimmedValue
            case "IDECodeSnippetLanguage":
                language = trimmedValue
            case "IDECodeSnippetContents":
                // For code contents, keep the original formatting (don't trim)
                contents = currentValue
            default:
                break
            }
        }

        currentValue = "" // Reset for next element
    }
}

// MARK: - File Operations

/// Loads and parses a single .codesnippet file
/// - Parameter url: File URL of the .codesnippet file
/// - Returns: Optional CodeSnippet if parsing succeeds, nil otherwise
func parseSnippetFile(at url: URL) -> CodeSnippet? {
    do {
        // Read the XML file contents
        let data = try Data(contentsOf: url)

        // Create our custom parser
        let snippetParser = SnippetParser()

        // Create an XMLParser with the file data and set our custom parser as delegate
        let parser = XMLParser(data: data)
        parser.delegate = snippetParser

        // Parse the XML - this will trigger all the delegate methods
        guard parser.parse() else {
            print("⚠️  Failed to parse: \(url.lastPathComponent)")
            return nil
        }

        // Create a CodeSnippet struct from the parsed data
        return CodeSnippet(
            identifier: snippetParser.identifier,
            title: snippetParser.title,
            summary: snippetParser.summary,
            completionPrefix: snippetParser.completionPrefix,
            language: snippetParser.language,
            contents: snippetParser.contents,
            fileName: url.lastPathComponent
        )

    } catch {
        print("❌ Error reading file \(url.lastPathComponent): \(error)")
        return nil
    }
}

/// Scans the current directory for all .codesnippet files and parses them
/// - Returns: Array of successfully parsed CodeSnippet objects
func loadAllSnippets() -> [CodeSnippet] {
    let fileManager = FileManager.default

    // Get the current directory where this script is running
    let currentPath = fileManager.currentDirectoryPath
    let currentURL = URL(fileURLWithPath: currentPath)

    do {
        // Get all files in the current directory
        let files = try fileManager.contentsOfDirectory(
            at: currentURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles] // Ignore hidden files like .DS_Store
        )

        // Filter for .codesnippet files only
        let snippetFiles = files.filter { $0.pathExtension == "codesnippet" }

        print("📂 Found \(snippetFiles.count) snippet files")

        // Parse each file and filter out any that failed to parse or are invalid
        let snippets = snippetFiles.compactMap { parseSnippetFile(at: $0) }
                                   .filter { $0.isValid }

        print("✅ Successfully parsed \(snippets.count) valid snippets")

        return snippets

    } catch {
        print("❌ Error reading directory: \(error)")
        return []
    }
}

// MARK: - Markdown Generation

/// Generates the main README.md with an overview table
/// This creates a nice table with links to the actual .codesnippet files
func generateReadme(snippets: [CodeSnippet]) -> String {
    var markdown = """
    # Xcode Code Snippets Collection

    A collection of useful Xcode code snippets for Swift development.

    ## 📥 Installation

    To use these snippets in Xcode:

    1. Download the desired `.codesnippet` file
    2. Place it in: `~/Library/Developer/Xcode/UserData/CodeSnippets/`
    3. Restart Xcode
    4. Type the completion prefix to use the snippet

    ## 📚 Available Snippets

    | Title | Description | Shortcut | Language | File |
    |-------|-------------|----------|----------|------|

    """

    // Sort snippets alphabetically by title for better readability
    let sortedSnippets = snippets.sorted { $0.title < $1.title }

    // Generate a table row for each snippet
    for snippet in sortedSnippets {
        // Handle empty shortcut with a nice placeholder
        let shortcut = snippet.completionPrefix.isEmpty ? "-" : "`\(snippet.completionPrefix)`"

        // Handle empty summary
        let summary = snippet.summary.isEmpty ? "-" : snippet.summary

        // Create markdown table row with a link to download the file
        markdown += "| \(snippet.title) | \(summary) | \(shortcut) | \(snippet.languageShort) | [Link](./ \(snippet.fileName)) |\n"
    }

    markdown += """


    ## 📖 Detailed Documentation

    For detailed documentation including the full code of each snippet, see [SNIPPETS.md](./SNIPPETS.md).

    """

    return markdown
}

/// Generates SNIPPETS.md with detailed documentation including code
/// This file shows the actual content of each snippet for easy browsing
func generateDetailedDocs(snippets: [CodeSnippet]) -> String {
    var markdown = """
    # Detailed Snippet Documentation

    This document contains the full code and details for each snippet.

    ---


    """

    // Sort snippets alphabetically by title
    let sortedSnippets = snippets.sorted { $0.title < $1.title }

    // Generate detailed documentation for each snippet
    for snippet in sortedSnippets {
        markdown += "## \(snippet.title)\n\n"

        // Add metadata section
        markdown += "**Language:** \(snippet.languageShort)  \n"

        if !snippet.completionPrefix.isEmpty {
            markdown += "**Completion Shortcut:** `\(snippet.completionPrefix)`  \n"
        }

        if !snippet.summary.isEmpty {
            markdown += "**Description:** \(snippet.summary)  \n"
        }

        markdown += "**File:** `\(snippet.fileName)`  \n\n"

        // Add the actual code in a syntax-highlighted code block
        // Determine the language identifier for syntax highlighting
        let languageId = snippet.languageShort.lowercased()

        markdown += "```\(languageId)\n"
        markdown += snippet.contents
        markdown += "\n```\n\n"

        markdown += "---\n\n"
    }

    return markdown
}

/// Writes a string to a file, creating or overwriting as needed
func writeToFile(content: String, filename: String) {
    do {
        let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(filename)

        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        print("✅ Generated: \(filename)")

    } catch {
        print("❌ Error writing \(filename): \(error)")
    }
}

// MARK: - Main Execution

/// Main entry point of the script
func main() {
    print("🚀 Starting Xcode Snippet Documentation Generator\n")

    // Step 1: Load and parse all snippet files
    let snippets = loadAllSnippets()

    // Check if we found any snippets
    guard !snippets.isEmpty else {
        print("⚠️  No valid snippets found. Make sure you're running this script in the CodeSnippets directory.")
        return
    }

    print("\n📝 Generating documentation...\n")

    // Step 2: Generate README.md
    let readmeContent = generateReadme(snippets: snippets)
    writeToFile(content: readmeContent, filename: "README.md")

    // Step 3: Generate SNIPPETS.md
    let detailedDocsContent = generateDetailedDocs(snippets: snippets)
    writeToFile(content: detailedDocsContent, filename: "SNIPPETS.md")

    print("\n🎉 Documentation generation complete!")
    print("📄 Files generated: README.md, SNIPPETS.md")
}

// Run the main function
main()
