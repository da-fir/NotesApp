//
//  NetworkService.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 12/01/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchTasks() async throws -> [TaskObject]
    func addTask(task: TaskObject) async throws -> TaskObject?
    func updateTask(task: TaskObject) async throws -> TaskObject?
    func deleteTask(taskId: String) async throws -> TaskObject?
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://mock.com/api"
    
    @MainActor
    func fetchTasks() async throws -> [TaskObject] {
        guard let url = URL(string: "\(baseURL)/tasks") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let tasks = try JSONDecoder().decode([TaskObject].self, from: data)
        return tasks
    }
    
    @MainActor
    func addTask(task: TaskObject) async throws -> TaskObject?  {
        guard let url = URL(string: "\(baseURL)/tasks") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(task)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (201...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(TaskObject.self, from: data)
    }
    
    @MainActor
    func updateTask(task: TaskObject) async throws -> TaskObject? {
        guard let url = URL(string: "\(baseURL)/tasks/\(task.id)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(task)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(TaskObject.self, from: data)
    }
    
    @MainActor
    func deleteTask(taskId: String) async throws -> TaskObject? {
        guard let url = URL(string: "\(baseURL)/tasks/\(taskId)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(TaskObject.self, from: data)
    }
}

// Define a simple error enumeration for the API client
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
