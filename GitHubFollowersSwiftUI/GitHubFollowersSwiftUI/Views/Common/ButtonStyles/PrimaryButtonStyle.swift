import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 58)
            .padding(.horizontal)
            .background(Color.accentColor)
            .foregroundStyle(Color("brandColor"))
            .font(.system(size: 24, weight: .semibold))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(configuration.isPressed ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primaryButton: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

#Preview {
    Button("Press button", action: {})
        .buttonStyle(.primaryButton)
        .padding(.horizontal)
}
