//
//  EnvironmentLoader.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 14/04/2026.
//

import Foundation

struct EnvironmentLoader {
    static func loadEnvironment() {
        // Load .env file from Bundle
        if let envPath = Bundle.main.path(forResource: ".env", ofType: "") {
            do {
                let contents = try String(contentsOfFile: envPath, encoding: .utf8)
                let lines = contents.components(separatedBy: .newlines)
                
                for line in lines {
                    let parts = line.components(separatedBy: "=")
                    if parts.count == 2 {
                        let key = parts[0].trimmingCharacters(in: .whitespaces)
                        let value = parts[1].trimmingCharacters(in: .whitespaces)
                        setenv(key, value, 1)
                    }
                }
                print("Environment variables loaded")
            } catch {
                print("Failed to load .env file: \(error)")
            }
        }
    }
}
