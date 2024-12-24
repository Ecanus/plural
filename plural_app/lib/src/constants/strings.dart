// Fields
class AskField {
  static const creator = "creator";
  static const creatorID = "creatorID";
  static const description = "description";
  static const deadlineDate = "deadlineDate";
  static const fullySponsoredDate = "fullySponsoredDate";
  static const garden = "garden";
  static const targetDonationSum = "targetDonationSum";
  static const sponsors = "sponsors";
}

class GenericField {
  static const created = "created";
  static const id = "id";
  static const updated = "updated";
}

class GardenField {
  static const creator = "creator";
  static const name = "name";
}

class SignInField {
  static const usernameOrEmail = "usernameOrEmail";
}

class UserField {
  static const email = "email";
  static const firstName = "firstName";
  static const lastName = "lastName";
  static const latestGardenRecordID = "latestGardenRecord";
  static const username = "username";
  static const password = "password";
  static const passwordConfirm = "passwordConfirm";
}

class UserGardenRecordField {
  static const garden = "garden";
  static const gardenID = "garden";
  static const name = "name";
  static const userID = "user";
  static const user = "user";
}

class UserSettingsField {
  static const user = "user";
  static const userID = "user";
  static const textSize = "textSize";
}

class AppFormFields {
  static const error = "error";
  static const rebuild = "rebuild";
  static const value = "value";
}

// Keys
class PBKey {
  static const expand = "expand";
  static const items = "items";
}

// Headers
class Headers {
  static const enterEmail = "Enter Email Address";
}

// Labels
class SignInLabels {
  static const passwordConfirm = "Confirm Password";
  static const email = "Email Address";
  static const firstName = "First Name";
  static const forgotPassword = "Forgot Password";
  static const lastName = "Last Name";
  static const logIn = "Log In";
  static const logOut = "Log Out";
  static const password = "Password";
  static const sendEmail = "Send Email";
  static const signUp = "Sign Up";
  static const submit = "Submit";
  static const username = "Username";
  static const usernameOrEmail = "Username or Email";
}

class LandingPageLabels {
  static const createGarden = "Create Garden";
  static const saveChanges = "Save Changes";
  static const seeInvites = "See Invitations";
  static const settings = "Settings";
  static const welcome = "Welcome";
}

// Strings
class Strings {

  // Ask Dialog
  static const asksViewTitle = "Asks";
  static const asksListButtonTooltip = "Asks List";

  static const viewableAskDialogTitle = "View Ask";
  static const editableAskDialogTitle = "Edit Ask";
  static const creatableAskDialogTitle = "Create Ask";

  static const isAskSponsoredLabel = "Is Sponsored";
  static const isAskFullySponsoredLabel = "Is Fully Sponsored";

  static const selectDateLabel = "Select Date";

  static const closeLabel = "Close Window";
  static const newAskLabel = "New Ask";
  static const createLabel = "Create";
  static const updateLabel = "Update";

  static const askTargetDonationSumLabel = "Target Donation Sum";
  static const askDescriptionLabel = "Description";
  static const askDeadlineDateLabel = "Deadline Date";
  static const askCreatorLabel = "Creator";

  // Date Formatting
  static const dateformatYMMdd = "y-MM-dd";

  // Garden
  static const gardenHeaderText1 = "Hi, ";

  // Garden Dialog
  static const gardensViewTitle = "Gardens";
  static const newGardenLabel = "New Garden";
  static const gardenNameLabel = "Name";
  static const gardensListButtonTooltip = "Gardens List";

  // Garden Footer
  static const asksTooltip = "Asks";
  static const gardensTooltip = "Gardens";
  static const settingsTooltip = "Settings";
  static const usersTooltip = "Users";

  // Settings Dialog
  static const settingsViewTitle = "Settings";
  static const gardensSettingsButtonTooltip = "Garden Settings";
  static const userSettingsButtonTooltip = "User Settings";
  static const userSettingsTextSizeLabel = "Text Size";

  // Sign In Tabs
  static const loginTooltip = "Log In";
  static const signupTooltip = "Sign Up";

  // User Dialog
  static const usersViewTitle = "Users";
  static const usersListButtonTooltip = "Users List";

  static const userFirstNameLabel = "First Name";
  static const userLastNameLabel = "Last Name";
}

// Messages
class SignInMessages {
  static const passwordLength = "Between 9 and 64 characters";
  static const passwordLowercase = "A lowercase character";
  static const passwordNumber = "A number";
  static const passwordSpecial = "A special character";
  static const passwordUppercase = "An uppercase character";
  static const passwordMatch = "Passwords match";
}

class ErrorMessages {
  static const invalidValue = "A valid value is required";
  static const invalidEmailOrPassword = "Invalid username/email or password";
  static const invalidPassword = "Password does not meet all requirements";
  static const passwordMismatch = "Passwords do not match";
}

class SnackBarMessages {
  static const sentPasswordResetEmail = "Password reset instructions have been sent to ";
  static const sentUserVerificationEmail = "A verification email has been sent to ";
}

// Instructions
class SignInInstructions {
  static const forgotPassword = (
    "Please enter the email address to send password reset instructions to.");
}

// Exceptions
class ExceptionStrings {
  static const data = "data";
  static const message = "message";
}

// Other
class ListedAskTileText {
  static const title = "Ask";
}

class Titles {
  static const pluralApp = "Plural App";
}