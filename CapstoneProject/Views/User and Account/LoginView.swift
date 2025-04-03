import SwiftUI

struct LoginView: View {
    // State Variables
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""

    // ViewModel
    @EnvironmentObject var userSessionViewModel: UserSessionViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Image("loginbg")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("LOGIN")
                        .bold()
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.bottom, 30)

                    CustomTextField(placeholder: "Email Address", text: $emailInput)

                    CustomTextField(placeholder: "Password", text: $passwordInput, isSecureField: true)
                        .padding(.top, 10)

                    CustomButton(label: "SIGN IN >", action: {
                        userSessionViewModel.login(email: emailInput, password: passwordInput)
                    })

                    // Forgot Password Button
                    Button("Forgot Password?") {
                        // Future: Add forgot password logic
                    }
                    .bold()
                    .foregroundStyle(.white)
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 10)

                    // Create Account Button
                    NavigationLink(destination: CreateAccountView()) {
                        Text("CREATE AN ACCOUNT >")
                            .bold()
                            .foregroundStyle(Color("AppColor1"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color("AppColor3"), .white, Color("AppColor3")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            )
                    }
                    .padding(.horizontal, 20)
                    .offset(y: 30)

                    // Hidden Navigation to Home Page
                    NavigationLink(destination: HomePageView(), isActive: $userSessionViewModel.isAuthenticated) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding()

                // Error Message
                if !userSessionViewModel.errorMessage.isEmpty {
                    Text(userSessionViewModel.errorMessage)
                        .bold()
                        .foregroundStyle(.red)
                        .offset(y: 145)
                }
            }
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(UserSessionViewModel())
}
