import Foundation

struct Follower: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
}

#if DEBUG
extension Follower {
    static let mock = Follower(
        id: 0,
        login: "LoremIpsumPrintingandtypesettingindustry",
        avatarUrl: "",
        url: ""
    )
}

extension Array where Element == Follower {
    
    static let mock = [
        Follower(
            id: 0,
            login: "LoremIpsumPrintingandtypesettingindustry 0",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 1,
            login: "LoremIpsumPrintingandtypesettingindustry 1",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 3,
            login: "LoremIpsumPrintingandtypesettingindustry 1",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 4,
            login: "LoremIpsumPrintingandtypesettingindustry 1",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 5,
            login: "LoremIpsumPrintingandtypesettingindustry 1",
            avatarUrl: "",
            url: ""
        )

    ]
}

#endif
