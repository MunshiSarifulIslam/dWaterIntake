//
//  LoadHydrationData.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 04/06/25.
//

import Foundation

class HydrationDataManager {
    private var hydrationData: HydrationData?

    init() {
        self.hydrationData = loadHydrationData()
    }

    private func loadHydrationData() -> HydrationData? {
        guard let url = Bundle.main.url(forResource: "hydration", withExtension: "json") else {
            print("Unable to load data from provided JSON path")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(HydrationData.self, from: data)
        } catch {
            print("Unable to decode JSON data: \(error)")
            return nil
        }
    }
    
    func getNormalWaterIntake(height: Double, weight: Double, gender: String, specialCondition: String? = nil) -> Double? {
        guard let hydrationData = hydrationData else {
            print("Hydration data is not loaded.")
            return nil
        }
        
        guard let matchedHeightKey = hydrationData.heightRanges.keys.first(where: { rangeStr in
            let parts = rangeStr.replacingOccurrences(of: "cm", with: "").split(separator: "-").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
            return parts.count == 2 && height >= parts[0] && height <= parts[1]
        }) else {
            print("No matching height range")
            return nil
        }

        guard let weightRangeData = hydrationData.heightRanges[matchedHeightKey],
              let matchedWeightKey = weightRangeData.weightRanges.keys.first(where: { rangeStr in
                  let parts = rangeStr.replacingOccurrences(of: "kg", with: "").split(separator: "-").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
                  return parts.count == 2 && weight >= parts[0] && weight <= parts[1]
              }) else {
            print("No matching weight range")
            return nil
        }

        let genderData = weightRangeData.weightRanges[matchedWeightKey]

        switch gender.lowercased() {
        case "male":
            return genderData?.male?.waterIntake.normalWeatherL

        case "female":
            guard let female = genderData?.female else { return nil }
            switch specialCondition?.lowercased() {
            case "pregnancy":
                return female.pregnancy?.waterIntake.normalWeatherL
            case "breastfeeding":
                return female.breastfeeding?.waterIntake.normalWeatherL
            default:
                return female.general?.waterIntake.normalWeatherL
            }

        default:
            print("Gender must be 'male' or 'female'")
            return nil
        }
    }
}

