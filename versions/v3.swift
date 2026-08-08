import SwiftUI

struct ContentView: View {
    @State private var pulseFleur = false
    @State private var showContent = false
    @State private var sweepX: CGFloat = -0.55
    @State private var ringRotate = 0.0

    var body: some View {
        ZStack {
            animatedBackdrop
            modeStrip

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 120)
                    chromeHeartLogo
                    Spacer().frame(height: 28)
                    brandText
                    Spacer().frame(height: 46)
                    crossRow
                    Spacer().frame(height: 40)
                    scrollBanner
                    Spacer().frame(height: 48)
                    daggerGrid
                    Spacer().frame(height: 72)
                }
                .padding(.horizontal, 24)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) { showContent = true }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) { pulseFleur = true }
            withAnimation(.linear(duration: 6.0).repeatForever(autoreverses: false)) { sweepX = 1.55 }
            withAnimation(.linear(duration: 28.0).repeatForever(autoreverses: false)) { ringRotate = 360 }
        }
    }

    private var modeStrip: some View {
        VStack {
            HStack {
                Text("SWIFT MINIMAL")
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                    .tracking(2.5)
                    .foregroundColor(.white.opacity(0.72))

                Spacer()

                Text("VERSION 3")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .tracking(3)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.78))
                    )
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .opacity(showContent ? 1 : 0)
            .animation(.easeOut(duration: 0.6), value: showContent)

            Spacer()
        }
    }

    private var animatedBackdrop: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black

                RadialGradient(
                    colors: [
                        Color.white.opacity(0.14),
                        Color.clear,
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.8, y: 0.1),
                    startRadius: 40,
                    endRadius: proxy.size.height * 1.1
                )
                .ignoresSafeArea()
                .blendMode(.screen)

                orbitingRings(width: proxy.size.width)
                sweepingLight(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
        }
    }

    private func sweepingLight(width: CGFloat, height: CGFloat) -> some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: Color.white.opacity(0.2), location: 0.43),
                .init(color: .clear, location: 1),
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: width * 0.62, height: height * 1.8)
        .rotationEffect(.degrees(18))
        .position(x: width * sweepX, y: height * 0.58)
        .blur(radius: 34)
        .blendMode(.screen)
        .opacity(0.65)
    }

    private func orbitingRings(width: CGFloat) -> some View {
        ZStack {
            ForEach(0..<4, id: \.self) { idx in
                let size = width * (0.55 + CGFloat(idx) * 0.33)
                Circle()
                    .stroke(Color.white.opacity(0.09), lineWidth: 0.9)
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(ringRotate + Double(idx) * 24))
                    .position(x: width * 0.5, y: 280)
            }
        }
    }

    // MARK: - Chrome Heart Logo

    private var chromeHeartLogo: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { idx in
                Circle()
                    .trim(from: 0, to: 0.86)
                    .stroke(
                        Color.white.opacity(0.38 - Double(idx) * 0.09),
                        style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .round, dash: [4, 6])
                    )
                    .frame(width: 250 + CGFloat(idx) * 44, height: 250 + CGFloat(idx) * 44)
                    .rotationEffect(.degrees(ringRotate * 0.7 + Double(idx) * 50))
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(0.95 + CGFloat(idx) * 0.06)
            }

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
            .scaleEffect(pulseFleur ? 1.05 : 0.97)

            fleurCorner.offset(x: -100, y: -100)
            fleurCorner.rotationEffect(.degrees(90)).offset(x: 100, y: -100)
            fleurCorner.rotationEffect(.degrees(180)).offset(x: 100, y: 100)
            fleurCorner.rotationEffect(.degrees(270)).offset(x: -100, y: 100)
        }
        .rotationEffect(.degrees(showContent ? 0 : -4))
        .opacity(showContent ? 1 : 0)
        .animation(.easeOut(duration: 0.8), value: showContent)
    }

    private var fleurCorner: some View {
        Text("+")
            .font(.system(size: 18, weight: .bold, design: .serif))
            .foregroundColor(.white)
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
        .opacity(showContent ? 1 : 0)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: showContent)
    }

    // MARK: - Cross Row

    private var crossRow: some View {
        HStack(spacing: 24) {
            ForEach(0..<5) { _ in
                CrossShape()
                    .fill(Color.white)
                    .frame(width: 16, height: 24)
            }
        }
        .opacity(showContent ? 1 : 0)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
    }

    // MARK: - Scroll Banner

    private var scrollBanner: some View {
        VStack(spacing: 0) {
            Rectangle().fill(Color.white).frame(height: 1)
            HStack {
                Text("F U C K")
                    .font(.system(size: 10, weight: .bold, design: .serif))
                    .tracking(4)
                Spacer()
                Text("Y O U")
                    .font(.system(size: 10, weight: .bold, design: .serif))
                    .tracking(4)
            }
            .foregroundColor(.white.opacity(0.5))
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            Rectangle().fill(Color.white).frame(height: 1)
        }
        .opacity(showContent ? 1 : 0)
        .animation(.easeOut(duration: 0.6).delay(0.5), value: showContent)
    }

    // MARK: - Dagger Grid

    private var daggerGrid: some View {
        let items: [(String, String)] = [
            ("DAGGER", "\u{2020}"),
            ("FLORAL", "\u{2740}"),
            ("HORSESHOE", "\u{03A9}"),
            ("CEMETERY", "\u{271D}"),
        ]

        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(spacing: 8) {
                    Text(item.1)
                        .font(.system(size: 36, design: .serif))
                        .foregroundColor(.white)
                    Text(item.0)
                        .font(.system(size: 9, weight: .bold, design: .serif))
                        .tracking(3)
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .overlay(
                    Rectangle()
                        .stroke(Color.white.opacity(0.33), lineWidth: 1)
                )
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.6 + Double(index) * 0.1), value: showContent)
            }
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

        // Left curve
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

        // Right curve
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

        // Vertical bar
        path.addRect(CGRect(x: midX - armW / 2, y: 0, width: armW, height: h))
        // Horizontal bar
        path.addRect(CGRect(x: 0, y: midY - armW / 2, width: w, height: armW))

        return path
    }
}
