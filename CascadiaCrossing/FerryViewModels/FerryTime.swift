// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

// MARK: - Feed
struct Feed: Codable {
  let schedule: Schedule
  let scrapedAt: String
}

// MARK: - Schedule
struct Schedule: Codable {
  let duk: Duk
  let hsb: Hsb
  let lng, nan: Lng
  let swb: Swb
  let tsa: ScheduleTSA
  
  enum CodingKeys: String, CodingKey {
    case duk = "DUK"
    case hsb = "HSB"
    case lng = "LNG"
    case nan = "NAN"
    case swb = "SWB"
    case tsa = "TSA"
  }
}

// MARK: - Duk
struct Duk: Codable {
  let tsa: Tsa
  
  enum CodingKeys: String, CodingKey {
    case tsa = "TSA"
  }
}

// MARK: - Tsa
struct Tsa: Codable {
  let sailingDuration: String
  let sailings: [Sailing]
}

// MARK: - Sailing
struct Sailing: Codable, Hashable {
  let time: String
  let fill, carFill, oversizeFill: Int
  let vesselName, vesselStatus: String
  
  static func == (lhs: Sailing, rhs: Sailing) -> Bool {
    return lhs.time == rhs.time &&
    lhs.carFill == rhs.carFill &&
    lhs.fill == rhs.fill &&
    lhs.oversizeFill == rhs.oversizeFill &&
    lhs.vesselName == rhs.vesselName &&
    lhs.vesselStatus == rhs.vesselStatus
  }
}

// MARK: - Hsb
struct Hsb: Codable {
  let bow, lng, nan: Tsa
  
  enum CodingKeys: String, CodingKey {
    case bow = "BOW"
    case lng = "LNG"
    case nan = "NAN"
  }
}

// MARK: - Lng
struct Lng: Codable {
  let hsb: Tsa
  
  enum CodingKeys: String, CodingKey {
    case hsb = "HSB"
  }
}

// MARK: - Swb
struct Swb: Codable {
  let ful, sgi, tsa: Tsa
  
  enum CodingKeys: String, CodingKey {
    case ful = "FUL"
    case sgi = "SGI"
    case tsa = "TSA"
  }
}

// MARK: - ScheduleTSA
struct ScheduleTSA: Codable {
  let duk, sgi, swb: Tsa
  
  enum CodingKeys: String, CodingKey {
    case duk = "DUK"
    case sgi = "SGI"
    case swb = "SWB"
  }
}
