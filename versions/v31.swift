import SwiftUI

struct ContentView: View {
    private enum Screen {
        case lookbook
        case piece(Piece)
    }

    private struct Piece: Identifiable, Hashable {
        let id: String
        let name: String
        let mark: String
        let line: String
    }

    private let pieces: [Piece] = [
        Piece(id: "cemetery", name: "CEMETERY CROSS", mark: "\u{271D}", line: "Sterling pendant"),
        Piece(id: "dagger", name: "DAGGER", mark: "\u{2020}", line: "Silver charm"),
        Piece(id: "floral", name: "FLORAL", mark: "\u{2740}", line: "Engraved ring"),
        Piece(id: "horseshoe", name: "HORSESHOE", mark: "\u{03A9}", line: "Belt buckle"),
    ]

    @State private var screen: Screen = .lookbook

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch screen {
            case .lookbook:
                lookbook
            case .piece(let piece):
                pieceDetail(piece)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var lookbook: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                modeStrip
                Spacer().frame(height: 36)
                chromeHeartLogo
                Spacer().frame(height: 28)
                brandText
                Spacer().frame(height: 36)
                collectionBanner
                Spacer().frame(height: 28)
                pieceGrid
                Spacer().frame(height: 48)
            }
            .padding(.horizontal, 24)
        }
    }

    private var modeStrip: some View {
        HStack {
            Text("SWIFT PROOF")
                .font(.system(size: 12, weight: .semibold, design: .serif))
                .tracking(2.5)
                .foregroundColor(.white.opacity(0.72))

            Spacer()

            Text("MARKER v31")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white.opacity(0.86)))
        }
        .padding(.top, 14)
    }

    private var chromeHeartLogo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 220, height: 220)

            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.white, lineWidth: 1)
                .frame(width: 210, height: 210)

            ZStack {
                HeartShape()
                    .fill(Color.white)
                    .frame(width: 120, height: 110)
                    .offset(y: 8)

                CrossShape()
                    .fill(Color.black)
                    .frame(width: 40, height: 60)
                    .offset(y: 2)
            }

            fleurCorner.offset(x: -100, y: -100)
            fleurCorner.rotationEffect(.degrees(90)).offset(x: 100, y: -100)
            fleurCorner.rotationEffect(.degrees(180)).offset(x: 100, y: 100)
            fleurCorner.rotationEffect(.degrees(270)).offset(x: -100, y: 100)
        }
        .accessibilityIdentifier("chrome-hearts-logo")
    }

    private var fleurCorner: some View {
        Text("+")
            .font(.system(size: 18, weight: .bold, design: .serif))
            .foregroundColor(.white)
    }

    private var brandText: some View {
        VStack(spacing: 6) {
            Text("CHROME HEARTS")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .tracking(8)
                .foregroundColor(.white)

            Rectangle()
                .fill(Color.white)
                .frame(width: 180, height: 1)

            Text("LOS ANGELES")
                .font(.system(size: 11, weight: .regular, design: .serif))
                .tracking(6)
                .foregroundColor(.white.opacity(0.6))

            Text("HOLLYWOOD COLLECTION")
                .font(.system(size: 11, weight: .semibold, design: .serif))
                .tracking(4)
                .foregroundColor(.white)
                .padding(.top, 8)
        }
    }

    private var collectionBanner: some View {
        VStack(spacing: 0) {
            Rectangle().fill(Color.white).frame(height: 1)
            HStack {
                Text("COLLECTION 31")
                    .font(.system(size: 10, weight: .bold, design: .serif))
                    .tracking(3)
                Spacer()
                Text("EST. 1988")
                    .font(.system(size: 10, weight: .bold, design: .serif))
                    .tracking(3)
            }
            .foregroundColor(.white.opacity(0.7))
            .padding(.vertical, 10)
            Rectangle().fill(Color.white).frame(height: 1)
        }
    }

    private var pieceGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(pieces) { piece in
                Button {
                    screen = .piece(piece)
                } label: {
                    VStack(spacing: 8) {
                        Text(piece.mark)
                            .font(.system(size: 36, design: .serif))
                            .foregroundColor(.white)
                        Text(piece.name)
                            .font(.system(size: 9, weight: .bold, design: .serif))
                            .tracking(2)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .overlay(Rectangle().stroke(Color.white.opacity(0.33), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("piece-\(piece.id)")
            }
        }
    }

    private func pieceDetail(_ piece: Piece) -> some View {
        VStack(spacing: 24) {
            modeStrip
            Spacer()
            Text(piece.mark)
                .font(.system(size: 72, design: .serif))
                .foregroundColor(.white)
            Text(piece.name)
                .font(.system(size: 22, weight: .bold, design: .serif))
                .tracking(4)
                .foregroundColor(.white)
            Text(piece.line)
                .font(.system(size: 14, weight: .regular, design: .serif))
                .foregroundColor(.white.opacity(0.6))
            Text("CHROME HEARTS · MARKER v31")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundColor(.white.opacity(0.85))
            Button("Back to lookbook") {
                screen = .lookbook
            }
            .buttonStyle(.bordered)
            .tint(.white)
            .padding(.top, 8)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: w * 0.5, y: h * 0.25))
        path.addCurve(
            to: CGPoint(x: 0, y: h * 0.25),
            control1: CGPoint(x: w * 0.4, y: 0),
            control2: CGPoint(x: 0, y: 0)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control1: CGPoint(x: 0, y: h * 0.55),
            control2: CGPoint(x: w * 0.5, y: h * 0.75)
        )
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.25),
            control1: CGPoint(x: w * 0.5, y: h * 0.75),
            control2: CGPoint(x: w, y: h * 0.55)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.25),
            control1: CGPoint(x: w, y: 0),
            control2: CGPoint(x: w * 0.6, y: 0)
        )
        return path
    }
}

struct CrossShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let armW = w * 0.35
        let midX = w / 2
        let midY = h * 0.35

        path.addRect(CGRect(x: midX - armW / 2, y: 0, width: armW, height: h))
        path.addRect(CGRect(x: 0, y: midY - armW / 2, width: w, height: armW))
        return path
    }
}

#Preview {
    ContentView()
}
