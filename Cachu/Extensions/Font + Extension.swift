import SwiftUI

extension Font {
    static func pretendard(size: CGFloat, weight: PretendardWeight) -> Font {
        return .custom(weight.rawValue, size: size)
    }
    
    enum PretendardWeight: String {
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
    }
}


enum DSTypography {
    case title1
    case body1
    case body2
    case body3
    case caption1
    case caption2
    case caption3

    var size: CGFloat {
        switch self {
        case .title1: return 20
        case .body1: return 16
        case .body2: return 14
        case .body3: return 13
        case .caption1: return 12
        case .caption2: return 10
        case .caption3: return 8
        }
    }

    var weight: Font.PretendardWeight {
        switch self {
        case .title1: return .bold
        default: return .regular
        }
    }
}

// 이런 식으로 사용
//Text("새싹아 일어나 어서 코딩 해야지")
//                .dsFont(.title1)
