// Fields
class AskField {
  static const boon = "boon";
  static const creator = "creator";
  static const creatorID = "creatorID";
  static const currency = "currency";
  static const description = "description";
  static const deadlineDate = "deadlineDate";
  static const garden = "garden";
  static const instructions = "instructions";
  static const sponsors = "sponsors";
  static const targetMetDate = "targetMetDate";
  static const targetSum = "targetSum";
  static const type = "type";
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
  static const instructions = "instructions";
  static const lastName = "lastName";
  static const password = "password";
  static const passwordConfirm = "passwordConfirm";
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
  static const defaultCurrency = "defaultCurrency";
  static const defaultInstructions = "defaultInstructions";
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
  static const confirmDeleteAsk = "Delete ask?";
  static const enterEmail = "Enter email address";
}

// Labels
class GardenPageLabels {
  static const tileTimeLeftBrace = "—";
}

class LandingPageLabels {
  static const createGarden = "Create Garden";
  static const saveChanges = "Save Changes";
  static const seeInvites = "See Invitations";
  static const settings = "Settings";
  static const welcome = "Welcome";
}

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

class AppDialogTooltips {
  static const navToAsks = "Asks";
  static const navToGardens = "Gardens";
  static const navToSettings = "Settings";
  static const navToUsers = "Users";

  static const saveChanges = "Save changes";
}

class AskDialogLabels {
  static const boon = "Boon";

  static const cancelConfirmDeleteAsk = "Cancel";
  static const closeWindow = "Close window";
  static const confirmDeleteAsk = "Delete";
  static const createAsk = "Create new Ask";
  static const creator = "Creator";
  static const currency = "Currency";

  static const deadlineDueBy = "due";
  static const deleteAsk = "Delete ask";

  static const instructions = "Instructions";

  static const isAskSponsored = "Is ponsored";
  static const isNotVisibleOnTimeline = "Not visible on timeilne";
  static const isTargetMet = "Target met";
  static const isVisibleOnTimeline = "Visible on timeline";

  static const selectDateLabel = "Select date";

  static const type = "Type";

  static const createLabel = "Create";
  static const updateLabel = "Update";

  static const description = "Description";
  static const deadlineDate = "Deadline date";

  static const targetIsMet = "Target met";
  static const targetIsNotMet = "Target not met";

  static const targetSum = "Target Sum";
  static const username = "Username";
}

class AppDialogTitles {
  static const asks = "Asks";
  static const createAsk = "Create Ask";
  static const editAsk = "Edit Ask";
  static const viewAsk = "View Ask";

  static const gardens = "Gardens";
  static const settings = "Settings";
  static const users = "Users";
}

class AskDialogTooltips {
  static const listedAsks = "Go to Asks";
}

class UserSettingsDialogLabels {
  static const defaultCurrency = "Default currency";
  static const defaultInstructions = "Default instructions";
}

// Strings
class Strings {

  // Ask Dialog
  static const asksListButtonTooltip = "Asks List";

  static const nonEditableAskDialogTitle = "View Ask";
  static const creatableAskDialogTitle = "Create Ask";

  // Date Formatting
  static const dateformatYMMdd = "y-MM-dd";

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
  static const invalidValue = "Valid value required";
  static const invalidEmailOrPassword = "Invalid username/email or password";
  static const invalidPassword = "Password does not meet all requirements";
  static const passwordMismatch = "Passwords do not match";
}

class SnackBarMessages {
  static const sentPasswordResetEmail = "Password reset instructions have been sent to";
  static const sentUserVerificationEmail = "A verification email has been sent to";

  static const askSponsored = "Ask successfully sponsored!";
  static const createAskSuccess = "Ask successfully created";
  static const deleteAskSuccess = "Ask successfully deleted";
  static const updateAskSuccess = "Ask successfully updated!";

  static const updateUserSettingsSuccess = "Settings updated";
}

// Instructions
class SignInInstructions {
  static const forgotPassword = (
    "Please enter the email address to send password reset instructions to");
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

class Tooltips {
  static const boon = "The ideal donation amount";
  static const instructions = "How to sponsor the ask";
  static const markAsSponsored = "Click to mark as sponsored";
  static const unmarkAsSponsored = "Click to unmark as sponsored";
}