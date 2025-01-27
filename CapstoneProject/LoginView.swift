import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    
    // MARK: - State Variables
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @State private var errorMessage: String = ""
    @State private var loginSuccessful: Bool = false
    
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
                        .padding(.top, 10) // Add spacing between the text fields
                    
                    CustomButton(label: "SIGN IN >", action: {
                        loginUser(email: emailInput, password: passwordInput)
                    })
                    
                    // Forgot Password Button
                    Button("Forgot Password?") {
                        // Logic for forgot password
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
                    NavigationLink(destination: HomePageView(), isActive: $loginSuccessful) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding()
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .bold()
                        .foregroundStyle(.red)
                        .offset(y: 145)
                }
            }
        }
    }
    
    // MARK: - Firebase Logic
    func checkIfEmailIsVerified(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.reload { error in
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(user.isEmailVerified)
        }
    }
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = "Invalid Email Address or Password"
                print("Login failed: \(error.localizedDescription)")
                loginSuccessful = false
                return
            }
            
            checkIfEmailIsVerified { isVerified in
                if isVerified {
                    print("Email verified. Proceeding to HomePageView.")
                    loginSuccessful = true
                } else {
                    do {
                        try Auth.auth().signOut()
                        errorMessage = "Please verify your email before logging in."
                        loginSuccessful = false
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

// MARK: - Reusable Subviews
struct AppLogo: View {
    var body: some View {
        Image("logo1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
            .padding(.bottom, 20)
    }
}



struct CustomButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .bold()
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("AppColor4"))
                )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    LoginView()
}
