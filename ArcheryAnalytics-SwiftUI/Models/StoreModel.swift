//
//  StoreModel.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import Foundation

/*
TODO Items
 
 Save data
 Load data
 Should StoreModel save the selectedRoundID?
 */
class StoreModel: ObservableObject, Codable {
        
    enum CodingKeys: String, CodingKey {
        case saveDate, fileName, rounds, selectedRoundID
    }

    @Published var saveDate = Date()
    @Published var fileName = "Default"
    @Published var rounds: [Round] = []
    @Published var selectedRoundID: UUID
    
    static var mockEmpty: StoreModel {
        let mockRound = Round.mockEmptyRound
        return StoreModel(rounds: [mockRound], selectedRoundID: mockRound.id)
    }

    var isSelectedRoundValid: Bool {
        return rounds.first(where: { $0.id == selectedRoundID }) != nil
    }
    
    var selectedRound: Round {
        get {
            return rounds.first(where: { $0.id == selectedRoundID })!
        }
        set {
            // Implement the logic to update selectedRoundID when the selectedRound changes
            if let index = rounds.firstIndex(where: { $0.id == selectedRoundID }) {
                rounds[index] = newValue
                selectedRoundID = newValue.id
            }
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    init(rounds: [Round], selectedRoundID: UUID) {
        self.rounds = rounds
        self.selectedRoundID = selectedRoundID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try container.decode(String.self, forKey: .saveDate)

        if let date = StoreModel.dateFormatter.date(from: dateString) {
            saveDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .saveDate, in: container, debugDescription: "Date string does not match expected format")
        }

        fileName = try container.decode(String.self, forKey: .fileName)
        rounds = try container.decode([Round].self, forKey: .rounds)
        selectedRoundID = try container.decode(UUID.self, forKey: .selectedRoundID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let dateString = StoreModel.dateFormatter.string(from: saveDate)
        try container.encode(dateString, forKey: .saveDate)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(rounds, forKey: .rounds)
        try container.encode(selectedRoundID, forKey: .selectedRoundID)
    }
    
    func loadData(jsonFileName: String, fromBundle: Bool) {
        let decoder = JSONDecoder()

        let loadingSource = fromBundle ? "Xcode" : "Documents"
        
        do {
            print("StoreModel: Loading JSON from \(loadingSource) - \(jsonFileName)")

            let url: URL

            fileName = jsonFileName

            if fromBundle {
                guard let bundleURL = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
                    throw NSError(domain: "com.yourapp.error", code: 404, userInfo: [NSLocalizedDescriptionKey: "JSON file not found in Xcode project"])
                }
                url = bundleURL
            } else {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                url = documentsDirectory.appendingPathComponent("\(jsonFileName).json")
            }

            let data = try Data(contentsOf: url)
            let decodedStoreModel = try decoder.decode(StoreModel.self, from: data)

            saveDate = decodedStoreModel.saveDate
            rounds = decodedStoreModel.rounds
            selectedRoundID = decodedStoreModel.selectedRoundID
        } catch {
            print("StoreModel: ERROR loading JSON from \(loadingSource) - \(jsonFileName), \(error)")
            resetData()
        }
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        saveDate = Date()
        
        do {
            print("StoreModel: Saving JSON - \(fileName)")

            let data = try encoder.encode(self)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirectory.appendingPathComponent("\(fileName).json")
            try data.write(to: url)
        }
        catch {
            print("StoreModel: ERROR saving JSON file - \(error)")
        }
    }

    func resetData() {
        rounds = []
        selectedRoundID = UUID()
    }
    
    func createNewRound() {
        let newRound = Round(date: Date(), name: "Vegas 300", numberOfEnds: 10, numberOfArrowsPerEnd: 3, tags: [])
    
        self.rounds.insert(newRound, at: 0)
        self.selectedRoundID = newRound.id
    }
    
}
