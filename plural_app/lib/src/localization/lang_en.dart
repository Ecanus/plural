class AdminInvitationViewText {
  static const createInvitationError = ""
    "An error occurred. Please ensure:\n"
    "1) The user exists\n"
    "2) The user is not already a member of this Garden\n"
    "3) An Invitation to this user is not already active";

  static const expiryDate = "Expiry date";

  static const returnToAdminOptionsLabel = "Return to Options";

  static const type = "Invitation type";

  static const invitee = "Invitee (username)";
}

class AdminCurrentGardenSettingsViewText {
  static const goToGardenPageLabel = "Return to Garden";

  static const name = "Garden Name";
}

class AdminListedUsersViewText {
  static const adminHeading = "Administrators";

  static const cancelConfirmExpelUser = "Cancel";
  static const confirmExpelUser = "Expel User?";
  static const confirmExpelUserSubtitle = ""
    "Expelling this user will remove them from the Garden, and they will need a new "
    "invitation to return.";

  static const expelUser = "Expel user";
  static const expelUserPrefix = "Expel";

  static const memberHeading = "Members";

  static const ownerHeading = "Owner";

  static const noAdministrators = "This Garden has no administrators.";
  static const noMembers = "This Garden has no other members.";

  static const userGardenRole = "Role";
}

class AdminOptionsViewText {
  static const createInvitationLabel = "Create Invitation";

  static const invitationsHeader = "Invitations";
}

class AdminPageBottomBarText {
  static const currentGardenSettingsTooltip = "Garden Settings";
  static const optionsTooltip = "Options";
  static const usersTooltip = "Users";
}

class AppText {
  static const pluralApp = "Plural App";
}

class AppDialogFooterText {
  static const adminCreateInvitation = "Create Invitation";
  static const adminEditUser = "Edit User";
  static const adminGardenSettings = "Garden Settings";
  static const adminListedUsers = "Users";
  static const adminOptionsView = "Options";

  static const createAsk = "Create Ask";

  static const editAsk = "Edit Ask";

  static const garden = "Garden";

  static const listedAsks = "My Asks";

  static const navToAdminCurrentGardenSettings = "Garden Settings";
  static const navToAdminListedUsers = "Users";
  static const navToAdminSettings = "Admin";
  static const navToAdminOptions = "Options";
  static const navToAsksView = "Asks";
  static const navToCurrentGardenSettingsView = "Garden";
  static const navToSettingsView = "Settings";

  static const settings = "Settings";
  static const sponsoredAsks = "Sponsored Asks";

  static const examineAsk = "View Ask";
}

class AppDialogFooterBufferText {
  static const adminListedUsersTooltip = "Return to Users";

  static const saveChanges = "Save changes";
}

class AskViewText {
  static const askTimeLeftBrace = "—";

  static const boon = "Boon";

  static const cancelConfirmDeleteAsk = "Cancel";
  static const confirmDeleteAsk = "Delete Ask?";
  static const createAsk = "Create new Ask";
  static const creator = "Creator";
  static const currency = "Currency";

  static const deadlineDate = "Deadline date";
  static const deadlineDueBy = "due";
  static const deadlinePassed = "Deadline passed";
  static const deleteAsk = "Delete Ask";
  static const description = "Description";

  static const emptyListedAskTilesMessage = "No Asks found";
  static const emptyListedAskTilesSubtitle = ""
    "Click the '$createAsk' button below to get started.";

  static const goToListedAsks = "Go to My Asks";
  static const goToSponsoredAsks = "Go to Sponsored Asks";

  static const instructions = "Instructions";
  static const instructionsTooltip = "How funds can be sent to you.\n"
                                      "$urlFormattingText";

  static const markAsSponsored = "Click to mark as sponsored";

  static const notVisibleOnTimeline = "Not visible on timeline";

  static const selectDateLabel = "Select date";

  static const targetMet = "Target met";
  static const targetNotMet = "Target not met";
  static const targetSum = "Target Sum";
  static const tooltipBoon = "The smallest ideal donation amount, "
                              "e.g. \$5 boon for \$20 target sum";
  static const type = "Type";

  static const unmarkAsSponsored = "Click to unmark as sponsored";
  static const username = "Username";

  static const visibleOnTimeline = "Visible on timeline";

  static const urlFormattingText = "Use markdown to format links "
                                  "e.g. [text](https://www.fakeurl.com)";

}

class AppFormText {
  static const invalidBoonValue = "Boon too high";
  static const invalidEmailOrPassword = "Invalid username/email or password";
  static const invalidValue = "Valid value required";
  static const invalidPassword = "Password does not meet all requirements";
}

class ForgotPasswordDialogText {
  static const enterEmail = "Enter email address";
  static const enterEmailToSendInstructions = (
    "Please enter the email address to send password reset instructions to");
}

class GardenSettingsViewText {
  static const cancelConfirmExitGarden = "Cancel";
  static const confirmExitGarden = "Are you sure?";
  static const confirmExitGardenSubtitle = ""
    "Leaving will permanently remove you from this Garden."
    "\n\nAll your Asks—fulfilled or unfulfilled—will be deleted, "
    "and you will need a new invitation to return.";

  static const exitGarden = "Exit Garden";

  static const goToLandingPageLabel = "Go to Landing page";
  static const goToAdminPageLabel = "Go to Administrator page";
}

class GardenPageBottomBarText {
  static const asksTooltip = "Asks";

  static const gardensTooltip = "Gardens";

  static const settingsTooltip = "Settings";

  static const usersTooltip = "Users";
}

class GardenTimelineText {
  static const emptyTimelineMessage = "No unsponsored Asks left";
  static const emptyTimelineSubtitle = "Please check again later!";
}

class LandingPageText {
  static const cancelConfirmDeleteAccount = "Cancel";
  static const confirmDeleteAccount = "Deleting account";
  static const confirmDeleteAccountPrompt = "To confirm this, type";
  static const confirmDeleteAccountValue = "DELETE";
  static const confirmDeleteAccountSubtitle = ""
    "Deleting your account will remove all of your information from our "
    "database. This cannot be undone.";
  static const createGarden = "Create Garden";

  static const deleteAccount = "Delete account";

  static const emptyLandingPageGardensListMessage = "No Gardens found";

  static const gardens = "Gardens";

  static const saveChanges = "Save changes";
  static const seeInvites = "See invitations";
  static const settings = "Settings";
}

class SignInPageText {
  static const email = "Email address";

  static const firstName = "First name";
  static const forgotPassword = "Forgot password";

  static const lastName = "Last name";
  static const logIn = "Log In";
  static const logOut = "Log Out";

  static const password = "Password";
  static const passwordConfirm = "Confirm password";
  static const passwordLength = "Between 9 and 64 characters";
  static const passwordLowercase = "A lowercase character";
  static const passwordMatch = "Passwords match";
  static const passwordMismatch = "Passwords do not match";
  static const passwordNumber = "A number";
  static const passwordSpecial = "A special character";
  static const passwordUppercase = "An uppercase character";

  static const sendEmail = "Send email";
  static const signUp = "Sign Up";
  static const submit = "Submit";

  static const username = "Username";
  static const usernameOrEmail = "Username or Email";
}

class SnackBarText {
  static const askSponsored = "Ask successfully sponsored!";

  static const createAskSuccess = "Ask successfully created";
  static const createInvitationSuccess = "Invitation successfully created";

  static const deleteAskSuccess = "Ask successfully deleted";
  static const deletedUserAccount = "Your account has been deleted";
  static const deletedUserAccountFailed = ""
    "An error occurred while trying to delete your account";

  static const expelUserSuccess = "Successfully expelled user:";

  static const sentPasswordResetEmail = "Password reset instructions have been sent to";
  static const sentUserVerificationEmail = "A verification email has been sent to";

  static const updateAskSuccess = "Ask successfully updated!";
  static const updateGardenNameSuccess = "Garden name successfully changed";
  static const updateUserGardenRoleSuccess = "User role successfully changed";
  static const updateUserSettingsSuccess = "Settings updated";

  static const urlError = "Invalid URL:";
}

class UnauthorizedPageText {
  static const buttonText = "Return";

  static const messageBody = ""
    "You do not have the necessary permissions to access this page.";
  static const messageHeader = "Unauthorized Access";

}

class UserSettingsViewText {
  static const defaultCurrency = "Default currency";
  static const defaultInstructions = "Default instructions";
  static const defaultValuesHeader = "Default Values";
  static const deleteAccountHeader = "Delete Account";

  static const firstName = "First name";

  static const gardenTimelineDisplayCountHeaderStart = "Display up to ";
  static const gardenTimelineDisplayCountHeaderEnd = "Asks in Timeline";

  static const lastName = "Last name";

  static const personalInformationHeader = "Personal Information";
}