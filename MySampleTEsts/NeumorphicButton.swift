struct NeumorphicButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Background"))
                .shadow(color: .white.opacity(0.7), radius: 6, x: -6, y: -6)
                .shadow(color: .black.opacity(0.2), radius: 6, x: 6, y: 6)

            Text("Neumorphic")
                .foregroundColor(.gray)
        }
        .frame(width: 200, height: 60)
    }
}
