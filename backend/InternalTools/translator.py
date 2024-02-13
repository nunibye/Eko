import json

untranslatedList = [
    "signIn",
    "signInToComment",
    "like",
    "comments",
    "comment",
    "addText",
    "addTitle",
    "createNewPost",
    "clear",
    "settings",
    "welcome",
    "welcomeTo",
    "welcomeBack",
    "createAccount",
    "createAnAccount",
    "cont",
    "dateOfBirth",
    "createAPassword",
    "deleteAcountTitle",
    "deleteAcountBody",
    "delete",
    "report",
    "save",
    "searchUsername",
    "search",
    "noResultsFound",
    "confirmation",
    "cancel",
    "resetPassword",
    "sendResetLink",
    "ok",
    "recentActivity",
    "nothingToSeeHere",
    "someone",
    "commentText",
    "groups",
    "next",
    "description",
    "skip",
    "done",
    "public",
    "selectAudience",
    "myGroups",
    "reply",
    "userNotFound",
    "usernameReqs",
    "followText",
    "taggedText",
    "badAuthState",
    "resetPasswordPromt",
    "passwordResetTitle",
    "passwordResetBody",
    "setPassword",
    "coppiedToClipboard",
    "download",
    "getTheApp",
    "gifLoadingError",
    "viewLikes",
    "updateRequiredTitle",
    "updateRequiredBody",
    "updateAvailable",
    "update",
    "postNotFound",
    "groupNotFound",
    "leaveGroupWarningTitle",
    "leaveGroupWarningBody",
    "share",
    "copyLink",
    "copied",
    "shareProfile",
    "deleteAcountReAuthWarning",
    "logIntoApp",
    "logInRequired",
    "notInGroup",
    "send",
    "reportDetails",
    "commentRequired",
    "tooEarlyDeleteTitle",
    "tooEarlyDeleteBody",
    "deletePostWarningTitle",
    "deleteCommentWarningTitle",
    "deletePostWarningBody",
    "invalidSession",
    "birthday",
    "month",
    "day",
    "year",
    "invalidBirthdayTitle",
    "invalidBirthdayBody",
    "tooYoungTitle",
    "tooYoungBody",
    "bySigningUp",
    "termsAndConditions",
    "block",
    "unblock",
    "blockTitle",
    "blockBody",
    "blockedAccounts",
    "newActivityNotifications",
    "blockedByUserMessage",
    "birthdayExplanation"
  ]

arbpath = r'C:\Users\ereec\Documents\GitHub\untitled\untitled_app\lib\localization\l10n\app_en.arb'

with open(arbpath, 'r') as file:
        
    data = json.load(file)
with open("out.txt", 'w') as outfile:
    for i in untranslatedList:
        outfile.write(f'"{i}":"{data[i]}"\n')

