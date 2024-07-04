import SwiftUI
import Lottie


struct SplashScreen: View {
    let name: String
    @EnvironmentObject var splashViewModel: SplashViewModel
    @State private var animationFinished = false
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            LottieView(name: name, loopMode: .playOnce) { finished in
                animationFinished = finished
                if finished {
                    splashViewModel.markAnimationFinished()
                }
            }
            .frame(width: 200, height: 200)
            
            if splashViewModel.showError {
                ErrorView(message: splashViewModel.errorMessage, webURL: splashViewModel.webURL)
            }
        }
        .onAppear {
            Task {
                await splashViewModel.authenticateIfNeeded()
            }
        }
    }
}

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let completion: (Bool) -> Void
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play { finished in
            completion(finished)
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}
