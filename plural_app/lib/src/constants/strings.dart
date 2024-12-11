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
  static const confirmPassword = "confirmPassword";
  static const password = "password";
  static const usernameOrEmail = "usernameOrEmail";
}

class UserField {
  static const email = "email";
  static const firstName = "firstName";
  static const lastName = "lastName";
  static const latestGardenRecordID = "latestGardenRecord";
  static const username = "username";
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

// Keys
class PBKey {
  static const expand = "expand";
  static const items = "items";
}

class ModelMapKeys {
  static const errorTextKey = "errorText";
  static const rebuildKey = "rebuild";
  static const successTextKey = "successText";
}

// Headers
class Headers {
  static const enterEmail = "Enter Email Address";
}

// Labels
class Labels {
  static const confirmPassword = "Confirm Password";
  static const email = "Email";
  static const firstName = "First Name";
  static const forgotPassword = "Forgot Password";
  static const lastName = "Last Name";
  static const login = "Log In";
  static const logout = "Log Out";
  static const password = "Password";
  static const sendEmail = "Send Email";
  static const signup = "Sign Up";
  static const submit = "Submit";
  static const username = "Username";
  static const usernameOrEmail = "Username or Email";
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

class SignInStrings {
  static const passwordLength = "Between 9 and 64 characters";
  static const passwordLowercase = "A lowercase character";
  static const passwordNumber = "A number";
  static const passwordSpecial = "A special character";
  static const passwordUppercase = "An uppercase character";
}

// Notifications
class ErrorStrings {
  static const invalidValue = "A valid value is required";
  static const invalidEmailOrPassword = "Invalid username/email or password";
  static const passwordMismatch = "Password values do not match";
}

class SnackBarStrings {
  static const sentPasswordResetEmail = "Password reset instructions were sent to";
}

// Other
class ListedAskTileText {
  static const title = "Ask";
}