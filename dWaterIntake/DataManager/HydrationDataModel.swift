//
//  HydrationDataModel.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 04/06/25.
//

import Foundation

struct HydrationData: Decodable {
    var heightRanges: [String: WeightRangeData]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        heightRanges = [:]
        for key in container.allKeys {
            let heightRange = key.stringValue
            heightRanges[heightRange] = try container.decode(WeightRangeData.self, forKey: key)
        }
    }
}

struct WeightRangeData: Decodable {
    var weightRanges: [String: GenderData]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        weightRanges = [:]
        for key in container.allKeys {
            let weightRange = key.stringValue
            weightRanges[weightRange] = try container.decode(GenderData.self, forKey: key)
        }
    }
}

struct GenderData: Decodable {
    let male: GenderSpecificData?
    let female: FemaleData? // Female data has nested structures

    enum CodingKeys: String, CodingKey {
        case male = "Male"
        case female = "Female"
    }
}

struct GenderSpecificData: Decodable {
    let waterIntake: WaterIntake
    let hydrationTips: [String]

    enum CodingKeys: String, CodingKey {
        case waterIntake = "WaterIntake"
        case hydrationTips = "HydrationTips"
    }
}

struct FemaleData: Decodable {
    let general: GenderSpecificData?
    let pregnancy: GenderSpecificData?
    let breastfeeding: GenderSpecificData?

    enum CodingKeys: String, CodingKey {
        case general = "General"
        case pregnancy = "Pregnancy"
        case breastfeeding = "Breastfeeding"
    }
}

struct WaterIntake: Decodable {
    let normalWeatherL: Double
    let hotWeatherL: Double

    enum CodingKeys: String, CodingKey {
        case normalWeatherL = "NormalWeatherL"
        case hotWeatherL = "HotWeatherL"
    }
}

// Helper struct to decode dynamic keys (like height and weight ranges)
struct DynamicKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}
