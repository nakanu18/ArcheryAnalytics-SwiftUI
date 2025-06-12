//
//  StoreModel.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import Foundation

class StoreModel: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case version, saveDate, fileName, rounds, tuningRounds
    }

    // TODO: change to private(set)
    @Published var version = 1
    @Published var saveDate = Date()
    @Published var fileName = mainFileName
    @Published var rounds: [Round] = []
    @Published var tuningRounds: [Round] = []
    
    static var mainFileName: String {
        return "Main"
    }

    static var mockEmpty: StoreModel {
        let mockRound = Round.mockEmptyRound
        return StoreModel(rounds: [mockRound])
    }

    static var mockFull: StoreModel {
        let mockRound = Round.mockFullRound
        return StoreModel(rounds: [mockRound])
    }
    
    static var mock: StoreModel {
        return StoreModel(rounds: [Round.mockEmptyRound, Round.mockFullRound])
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    init(rounds: [Round]) {
        self.rounds = rounds
    }

    //
    // Decoding / Encoding
    //
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dateString = try container.decodeIfPresent(String.self, forKey: .saveDate) ?? StoreModel.dateFormatter.string(from: Date())
        if let date = StoreModel.dateFormatter.date(from: dateString) {
            saveDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .saveDate, in: container, debugDescription: "Date string does not match expected format")
        }
        version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 1
        fileName = try container.decodeIfPresent(String.self, forKey: .fileName) ?? "Unknown"
        rounds = try container.decodeIfPresent([Round].self, forKey: .rounds) ?? []
        tuningRounds = try container.decodeIfPresent([Round].self, forKey: .tuningRounds) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(version, forKey: .version)
        let dateString = StoreModel.dateFormatter.string(from: saveDate)
        try container.encode(dateString, forKey: .saveDate)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(rounds, forKey: .rounds)
    }

    //
    // Loading / Saving
    //

    func loadData(jsonFileName: String, fromBundle: Bool) {
        let decoder = JSONDecoder()
        let loadingSource = fromBundle ? "Xcode" : "Documents"

        do {
            print("- StoreModel: Loading JSON from \(loadingSource) - \(jsonFileName)")

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
            let decodedStoreModel = try decoder.decode(StoreModel.self, from: data).migrateToLatestVersion()

            version = decodedStoreModel.version
            saveDate = decodedStoreModel.saveDate
            fileName = decodedStoreModel.fileName
            rounds = decodedStoreModel.rounds
        } catch {
            print("StoreModel: ERROR loading JSON from \(loadingSource) - \(jsonFileName), \(error)")
            resetData(jsonFileName: jsonFileName)
        }
    }
    
    func doesFileExist(fileName: String) -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent("\(fileName).json")
        return FileManager.default.fileExists(atPath: url.path)
    }

    func saveData(newFileName: String = mainFileName, onSuccess: (String) -> Void = { _ in }, onFail: (String) -> Void = { _ in }) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        fileName = newFileName
        saveDate = Date()

        do {
            print("- StoreModel: Saving JSON - \(fileName)")
            onSuccess("Saving to \(fileName).json")

            let data = try encoder.encode(self)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirectory.appendingPathComponent("\(fileName).json")
            try data.write(to: url)
        } catch {
            print("- StoreModel: ERROR saving JSON file - \(error)")
            onFail("Saving Failed ...")
        }
    }
    
    func printData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(self)

            if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
            }
        } catch {
            
        }
    }

    //
    // Actions
    //

    func resetData(jsonFileName: String) {
        print("- StoreModel: resetData")
        fileName = jsonFileName
        rounds = []
    }

    func createNewRound(roundType: RoundType) -> Round {
        var newRound = Round()
        newRound.name = roundType.name
        newRound.stages = roundType.stages

        print("- StoreModel: createNewRound: \(newRound.name)")
        rounds.insert(newRound, at: 0)
        return newRound
    }

    func updateRound(round: Round) {
        guard let index = rounds.firstIndex(where: { $0.id == round.id }) else {
            return
        }

        print("- StoreModel: updateRound: [\(round.id)] - \(round.name)")
        rounds[index] = round
    }
}
