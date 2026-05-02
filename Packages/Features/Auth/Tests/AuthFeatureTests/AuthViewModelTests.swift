import XCTest
import Core
@testable import AuthFeature

@MainActor
final class AuthViewModelTests: XCTestCase {

    // MARK: - Validation

    func testSignInDisabledWithEmptyFields() {
        let vm = AuthViewModel(repository: MockAuthRepository())
        XCTAssertFalse(vm.signInEnabled)
    }

    func testSignInEnabledWithValidEmailAndPassword() {
        let vm = AuthViewModel(repository: MockAuthRepository())
        vm.signInEmail = "user@example.com"
        vm.signInPassword = "secret"
        XCTAssertTrue(vm.signInEnabled)
    }

    func testSignInRejectsInvalidEmail() {
        let vm = AuthViewModel(repository: MockAuthRepository())
        vm.signInEmail = "not-an-email"
        vm.signInPassword = "secret"
        XCTAssertFalse(vm.signInEnabled)
    }

    func testSignUpRequiresMatchingPasswords() {
        let vm = AuthViewModel(repository: MockAuthRepository())
        vm.signUpEmail = "user@example.com"
        vm.signUpPassword = "longenough"
        vm.signUpConfirmPassword = "different!"
        XCTAssertFalse(vm.signUpEnabled)

        vm.signUpConfirmPassword = "longenough"
        XCTAssertTrue(vm.signUpEnabled)
    }

    func testSignUpRequiresMinimumPasswordLength() {
        let vm = AuthViewModel(repository: MockAuthRepository())
        vm.signUpEmail = "user@example.com"
        vm.signUpPassword = "short"
        vm.signUpConfirmPassword = "short"
        XCTAssertFalse(vm.signUpEnabled)
    }

    // MARK: - Flows

    func testSignInSurfacesInvalidCredentialsError() async {
        let repo = MockAuthRepository()
        repo.signInResult = .failure(AuthError.invalidCredentials)
        let vm = AuthViewModel(repository: repo)
        vm.signInEmail = "user@example.com"
        vm.signInPassword = "wrong"

        await vm.signIn()

        XCTAssertEqual(vm.errorMessage, AuthError.invalidCredentials.errorDescription)
        XCTAssertNil(vm.activeAction)
    }

    func testSignUpEmailConfirmationFlowSetsInfoMessage() async {
        let repo = MockAuthRepository()
        repo.signUpResult = .failure(AuthError.signUpRequiresEmailConfirmation)
        let vm = AuthViewModel(repository: repo)
        vm.signUpEmail = "user@example.com"
        vm.signUpPassword = "longenough"
        vm.signUpConfirmPassword = "longenough"

        await vm.signUp()

        XCTAssertEqual(vm.infoMessage, AuthError.signUpRequiresEmailConfirmation.errorDescription)
        XCTAssertNil(vm.errorMessage)
        XCTAssertEqual(vm.signUpPassword, "")
    }

    func testPasswordResetShowsConfirmation() async {
        let repo = MockAuthRepository()
        let vm = AuthViewModel(repository: repo)
        vm.forgotPasswordEmail = "user@example.com"

        await vm.requestPasswordReset()

        XCTAssertNotNil(vm.infoMessage)
        XCTAssertEqual(vm.forgotPasswordEmail, "")
        XCTAssertEqual(repo.passwordResetEmails, ["user@example.com"])
    }
}

// MARK: - Mock

final class MockAuthRepository: AuthRepository, @unchecked Sendable {
    var signInResult: Result<AuthSession, Error> = .success(
        AuthSession(userID: UUID(), email: "user@example.com", isAnonymous: false)
    )
    var signUpResult: Result<AuthSession, Error> = .success(
        AuthSession(userID: UUID(), email: "user@example.com", isAnonymous: false)
    )
    var passwordResetEmails: [String] = []

    func currentSession() async -> AuthSession? { nil }

    func sessionChanges() -> AsyncStream<AuthSession?> {
        AsyncStream { $0.finish() }
    }

    func signIn(email: String, password: String) async throws -> AuthSession {
        try signInResult.get()
    }

    func signUp(email: String, password: String) async throws -> AuthSession {
        try signUpResult.get()
    }

    func signOut() async throws {}

    func requestPasswordReset(email: String) async throws {
        passwordResetEmails.append(email)
    }
}
