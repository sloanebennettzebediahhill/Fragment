
import SwiftUI

struct AuthorizationScreen: View {
    @State private var email = ""
    @State private var password = ""
    
//    @State private var email = ""
    @State private var name = ""
//    @State private var password = ""
    @State private var confirmPassword = ""
    
    @ObservedObject var viewModel: AuthMain
    @State private var isNotificationShown = false
    @State private var isAlertShown = false
    @State private var isAuth = true
    
    @Binding var path: NavigationPath
    
    init(viewModel: AuthMain, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
        if isAuth {
            authView
                .alert(isPresented: $isAlertShown) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.text),
                        dismissButton: .cancel()
                    )
                }
        } else {
            registrationView
                .alert(isPresented: $isNotificationShown) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please ensure your email address is valid and not empty, your password is at least 6 characters long, and your confirmation password matches your password."),
                        dismissButton: .cancel()
                    )
                }
        }
    }
    
    var authView: some View {
        VStack {
            Text("Log in")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.custom("Dosis-Bold", size: 64))
                .foregroundStyle(.white)
            
            TextField("", text: $email, prompt:
                Text("Email")
                .font(.custom("Dosis-Regular", size: 32))
                .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            )
            .font(.custom("Dosis-Regular", size: 32))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 24)
            .padding(.vertical, 11)
            .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            
            SecureField(
                "",
                text: $password,
                prompt:
                    Text("Password")
                    .font(.custom("Dosis-Regular", size: 32))
                    .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            )
            .font(.custom("Dosis-Regular", size: 32))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 24)
            .padding(.vertical, 11)
            .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            
            Button {
                Task {
                    do {
                        try await viewModel.signIn(email: email, password: password)
                        if !viewModel.text.isEmpty {
                            isAlertShown = true
                        }
                    } catch {
                        isAlertShown = true
                    }
                }
            } label: {
                Text("Log in")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.custom("Dosis-Bold", size: 32))
                    .textCase(.uppercase)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 21)
            .background(LinearGradient(colors: [
                Color.init(red: 245/255, green: 80/255, blue: 80/255),
                Color.init(red: 171/255, green: 0/255, blue: 0/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            .padding(.top, 20)
            
            
            Spacer()
                    
            VStack(spacing: 0) {
                Text("Or choose another way")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.custom("Dosis-Bold", size: 24))
                    .foregroundStyle(Color(red: 73/255, green: 102/255, blue: 124/255))
                    .padding(.top, 12)
                    .padding(.horizontal, 10)
            
                Button {
                    isAuth = false
                } label: {
                    Text("Create an account")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.custom("Dosis-Bold", size: 32))
                        .foregroundStyle(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                        .textCase(.uppercase)
                }
                .padding(.vertical, 21)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.init(red: 47/255, green: 72/255, blue: 91/255), lineWidth: 8)
                )
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .cornerRadius(50)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .padding(.top, 14)
                
                Button {
                    Task {
                        await viewModel.signInAnonymously()
                    }
                } label: {
                    Text("Anonimous")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.custom("Dosis-Bold", size: 32))
                        .foregroundStyle(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                        .textCase(.uppercase)
                }
                .padding(.vertical, 21)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.init(red: 47/255, green: 72/255, blue: 91/255), lineWidth: 8)
                )
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .cornerRadius(50)
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            }
            .background(
                RoundedCorner(radius: 60, corners: [.topLeft, .topRight])
                    .fill(LinearGradient(colors: [
                        Color.init(red: 200/255, green: 215/255, blue: 240/255),
                        Color.init(red: 138/255, green: 176/255, blue: 203/255)
                    ], startPoint: .leading, endPoint: .trailing))
                    .edgesIgnoringSafeArea(.bottom)
            )
            .padding(.horizontal, -10)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.onboardingBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
    
    var registrationView: some View {
        VStack {
            Text("Create an acc")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.custom("Dosis-Bold", size: 64))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            TextField("", text: $name, prompt:
                Text("Name")
                .font(.custom("Dosis-Regular", size: 32))
                .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            )
            .font(.custom("Dosis-Regular", size: 32))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 24)
            .padding(.vertical, 11)
            .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            
            TextField("", text: $email, prompt:
                Text("Email")
                .font(.custom("Dosis-Regular", size: 32))
                .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            )
            .font(.custom("Dosis-Regular", size: 32))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 24)
            .padding(.vertical, 11)
            .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            
            SecureField("", text: $password, prompt:
                Text("Password")
                .font(.custom("Dosis-Regular", size: 32))
                .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            )
            .font(.custom("Dosis-Regular", size: 32))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 24)
            .padding(.vertical, 11)
            .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            
            SecureField("", text: $confirmPassword, prompt:
                Text("Confirm password")
                .font(.custom("Dosis-Regular", size: 32))
                .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            )
            .font(.custom("Dosis-Regular", size: 32))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 24)
            .padding(.vertical, 11)
            .foregroundColor(Color(red: 116/255, green: 134/255, blue: 150/255))
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            
            Button {
                if isFormValid {
                    Task {
                        do {
                            try await viewModel.createUser(withEmail: email, password: password, name: name)
                            if !viewModel.text.isEmpty {
                                isAlertShown = true
                            }
                        } catch {
                            isAlertShown = true
                        }
                    }
                } else {
                    isNotificationShown.toggle()
                }
            } label: {
                Text("Create")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.custom("Dosis-Bold", size: 32))
                    .textCase(.uppercase)
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
            }
            .padding(.vertical, 21)
            .background(LinearGradient(colors: [
                Color.init(red: 245/255, green: 80/255, blue: 80/255),
                Color.init(red: 171/255, green: 0/255, blue: 0/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            .padding(.top, 20)
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("Or choose another way")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.custom("Dosis-Bold", size: 24))
                    .foregroundStyle(Color(red: 73/255, green: 102/255, blue: 124/255))
                    .padding(.top, 12)
                    .padding(.horizontal, 10)
            
                Button {
                    isAuth = true
                } label: {
                    Text("log in")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.custom("Dosis-Bold", size: 32))
                        .foregroundStyle(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .padding(.vertical, 21)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.init(red: 47/255, green: 72/255, blue: 91/255), lineWidth: 8)
                )
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .cornerRadius(50)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .padding(.top, 14)
                
                Button {
                    Task {
                        await viewModel.signInAnonymously()
                    }
                } label: {
                    Text("Anonimous")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.custom("Dosis-Bold", size: 32))
                        .foregroundStyle(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .padding(.vertical, 21)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.init(red: 47/255, green: 72/255, blue: 91/255), lineWidth: 8)
                )
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .cornerRadius(50)
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            }
            .background(
                RoundedCorner(radius: 60, corners: [.topLeft, .topRight])
                    .fill(LinearGradient(colors: [
                        Color.init(red: 200/255, green: 215/255, blue: 240/255),
                        Color.init(red: 138/255, green: 176/255, blue: 203/255)
                    ], startPoint: .leading, endPoint: .trailing))
                    .edgesIgnoringSafeArea(.bottom)
            )
            .padding(.horizontal, -10)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.onboardingBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    AuthorizationScreen(viewModel: .init(), path: .constant(.init()))
}

extension AuthorizationScreen: AuthProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
    }
}
