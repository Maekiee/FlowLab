import SwiftUI

extension View {
    func dsFont(_ style: DSTypography) -> some View {
        self.font(.pretendard(size: style.size, weight: style.weight))
    }
}
