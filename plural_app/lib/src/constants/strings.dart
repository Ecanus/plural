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

class PBKey {
  static const expand = "expand";
  static const items = "items";
}

class Field {
  static const created = "created";
  static const id = "id";
  static const updated = "updated";
}

class GardenField {
  static const creator = "creator";
  static const name = "name";
}

class LogInField {
  static const password = "password";
  static const usernameOrEmail = "usernameOrEmail";
}

class UserField {
  static const email = "email";
  static const firstName = "firstName";
  static const lastName = "lastName";
  static const latestGardenRecordID = "latestGardenRecord";
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

class ListedAskTileText {
  static const title = "Ask";
}

class ErrorString {
  static const invalidValue = "A valid value is required";
}

class Labels {
  static const login = "Log In";
  static const logout = "Log Out";
  static const password = "Password";
  static const usernameOrEmail = "Username or Email";
}

class Strings {
  // Tooltips
  static const tooltipAsks = "Asks";
  static const tooltipGardens = "Gardens";
  static const tooltipSettings = "Settings";
  static const tooltipUsers = "Users";

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

  // Garden
  static const gardenHeaderText1 = "Hi, ";

  // Garden Dialog
  static const gardensViewTitle = "Gardens";
  static const newGardenLabel = "New Garden";

  static const gardenNameLabel = "Name";

  static const gardensListButtonTooltip = "Gardens List";

  // User Dialog
  static const usersViewTitle = "Users";
  static const usersListButtonTooltip = "Users List";

  static const userFirstNameLabel = "First Name";
  static const userLastNameLabel = "Last Name";

  // Settings Dialog
  static const settingsViewTitle = "Settings";

  static const gardensSettingsButtonTooltip = "Garden Settings";
  static const userSettingsButtonTooltip = "User Settings";

  static const userSettingsTextSizeLabel = "Text Size";

  // Date Formatting
  static const dateformatYMMdd = "y-MM-dd";
}