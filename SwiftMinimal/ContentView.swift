import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 80)
                    chromeHeartLogo
                    Spacer().frame(height: 32)
                    brandText
                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Chrome Heart Logo

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
        }
    }

    // MARK: - Brand Text

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

            Text("ESTABLISHED 1988")
                .font(.system(size: 9, weight: .light, design: .monospaced))
                .tracking(4)
                .foregroundColor(.white.opacity(0.35))
        }
    }
}

// MARK: - Heart Shape

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

// MARK: - Cross Shape

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
