import SwiftUI

struct LoginView: View {
    // State Variables
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @State private var showingForgotPassword = false
    
    var isLoginDisabled: Bool {
        emailInput.isEmpty || passwordInput.isEmpty
    }

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
                    }, disabled: isLoginDisabled)

                    // Forgot Password Button
                    Button("Forgot Password?") {
                        // Future: Add forgot password logic
                        showingForgotPassword = true
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
                if !userSessionViewModel.loginErrorMessage.isEmpty {
                    Text(userSessionViewModel.loginErrorMessage)
                        .bold()
                        .foregroundStyle(.red)
                        .offset(y: 145)
                }
            }
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
                    .presentationDetents([.medium, .height(400)])
            }
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(UserSessionViewModel())
}
