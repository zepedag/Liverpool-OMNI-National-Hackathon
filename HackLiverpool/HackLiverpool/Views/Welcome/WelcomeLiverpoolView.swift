import SwiftUI

enum ExperienceAction {
    case findProduct
    case requestExpert
    case exploreOnMyOwn
    case close
}

// MARK: - Welcome View
struct WelcomeLiverpoolView: View {
    @State private var navigateToSelectExperience = false
    @State private var navigateToHomeViewRoot = false

    let swipeThreshold: CGFloat = -100
    @State private var arrowOffsetY: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                if navigateToHomeViewRoot {
                    NavigationBar()
                } else {
                    ZStack {
                        Color.liverpoolPink
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Spacer()
                            Text("¡Bienvenido a Liverpool!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Spacer()
                            VStack(spacing: -5) {
                                Image(systemName: "chevron.up")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                                    .offset(y: arrowOffsetY)
                                Image(systemName: "chevron.up")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                                    .offset(y: arrowOffsetY)
                            }
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                    arrowOffsetY = -12
                                }
                            }
                            .padding(.bottom, 50)
                        }

                        NavigationLink(destination: SelectExperienceView(navigateToHomeViewRoot: $navigateToHomeViewRoot), isActive: $navigateToSelectExperience) {
                            EmptyView()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height < swipeThreshold && abs(value.translation.width) < abs(value.translation.height) {
                                    self.navigateToSelectExperience = true
                                }
                            }
                    )
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
            }
            .animation(.default, value: navigateToHomeViewRoot)
        }
    }
}

struct WelcomeLiverpoolView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeLiverpoolView()
    }
}

