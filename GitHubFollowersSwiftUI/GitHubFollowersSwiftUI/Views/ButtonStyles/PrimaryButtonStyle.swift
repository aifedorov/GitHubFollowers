import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.accentColor)
            .foregroundStyle(.brand)
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
}
