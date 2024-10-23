class AskField {
  static const creator = "creator";
  static const creatorUID = "creatorUID";
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
  static const uid = "uid";
  static const updated = "updated";
}

class GardenField {
  static const name = "name";
}

class UserField {
  static const email = "email";
  static const firstName = "firstName";
  static const lastName = "lastName";
  static const latestGardenRecordUID = "latestGardenRecord";
}

class UserGardenRecordField {
  static const garden = "garden";
  static const gardenUID = "garden";
  static const name = "name";
  static const userUID = "user";
  static const user = "user";
}

class ListedAskTileText {
  static const title = "Ask";
}

class ErrorString {
  static const invalidValue = "A valid value is required";
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

  // User Dialog
  static const usersViewTitle = "Users";
  static const usersListButtonTooltip = "Users List";

  static const userFirstNameLabel = "First Name";
  static const userLastNameLabel = "Last Name";

  // Garden
  static const gardenHeaderText1 = "Hi, ";

  // Garden Dialog
  static const gardensViewTitle = "Gardens";

  // Date Formatting
  static const dateformatYMMdd = "y-MM-dd";
}