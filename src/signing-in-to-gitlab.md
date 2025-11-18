# Signing in to GitLab

## Joining Redox GitLab

You don't need to join our GitLab to build Redox, but you will if you want to contribute. Obtaining a Redox account requires approval from a GitLab administrator, because of the high number of spam accounts (bots) that are created on this type of project. To join, first, go to [Redox GitLab](https://gitlab.redox-os.org/) and click the Sign In/Register button. Create your User ID and Password. Then, send an message to the [GitLab Approvals](https://matrix.to/#/#redox-gitlab:matrix.org) room indicating your GitLab User ID and requesting that your account be approved. Please give a brief statement about what you intend to use the account for. This is mainly to ensure that you are a genuine user.

The approval of your GitLab account may take some minutes or hours, in the meantime, join us on the [chat](./chat.md) and let us know what you are working on.

## Setting up 2FA

Your new GitLab account will not require 2 Factor Authentication at the beginning, but it will eventually insist. Some details and options are described in detail [below](#2fa-apps).
  
## 2FA Apps

### Requirements Before Logging Into GitLab

Before logging-in, you'll need:
 - your web browser open at [Redox GitLab](https://gitlab.redox-os.org/redox-os/)
 - your phone
 - your 2FA App installed on your phone.
 - to add https://gitlab.redox-os.org/redox-os/ as a site in your 2FA App.  Once added and the site listed, underneath you'll see 2 sets of 3 digits, 6 digits in all. i.e. **258 687**. That's the 2FA Verification Code.  It changes every so often around every minute.

### Available 2FA Apps for Android
 
 On Android, you may use:
 - Aegis Authenticator - [F-Droid](https://f-droid.org/en/packages/com.beemdevelopment.aegis)/[Play Store](https://play.google.com/store/apps/details?id=com.beemdevelopment.aegis)
 - [Google Authenticator](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_CA&gl=US)

### Available 2FA Apps for iPhone

 On iPhone iOS, you may use:
  - [Google Authenticator](https://apps.apple.com/us/app/google-authenticator/id388497605)
  - [Tofu Authenticator (open-source)](https://apps.apple.com/us/app/tofu-authenticator/id1082229305)
  - [iOS built-in authenticator](https://support.apple.com/guide/iphone/automatically-fill-in-verification-codes-ipha6173c19f/ios)
 
### Logging-In With An Android Phone

Here are the steps:
 - From your computer web browser, open the [Redox GitLab](https://gitlab.redox-os.org/redox-os/)
 - Click the Sign In button
 - Enter your username/email
 - Enter your password
 - Click the Submit button
 - Finally you will be prompted for a 2FA verification code from your phone. Go to your Android phone, go to Google/Aegis Authenticator, find the site gitlab redox and underneith those 6 digits in looking something like **258 687** that's your 2FA code.  Enter those 6 digits into the prompt on your computer.  Click Verify.  Done.  You're logged into Gitlab.
 
### Logging-In With An iPhone

Here are the steps:
 - From your computer web browser, open the [Redox GitLab](https://gitlab.redox-os.org/redox-os/)
 - Click the Sign In button
 - Enter your username/email
 - Enter your password
 - Click the Submit button
 - Finally you will be prompted for a 2FA verification code from your phone. Go to your iPhone, go to 2stable/Tofu Authenticator or to your Settings->Passwords for iOS Authenticator, find the site gitlab redox and underneath those 6 digits in looking something like **258 687** that's your 2FA code.  Enter those 6 digits into the prompt on your computer.  Click Verify.  Done.  You're logged into Gitlab.

## Setting up PAT

Personal Access Token (PAT) is a replacement for passwords when authenticating via Git clients. When pushing code to GitLab, you need to create one.

Here are the steps needed to create a PAT after logging in to GitLab:
- Open [Personal access tokens in User settings](https://gitlab.redox-os.org/-/user_settings/personal_access_tokens)
- Click "Add new Token" at the top right of the page
- Enter the token name (can be anything) and expiration date (max is 1 year from today)
- Check `read_repository` and `write_repository` scopes
- Click "Create Token"
- Copy the PAT (displayed as masked password) under the section "Your Token"
- Save the PAT somewhere safe, like your password manager

When doing `git push`, you'll be asked for username and password. Enter the password from the PAT token you've created. This will happen every time you run `git push`. To remember it forever, run the command below to store it later in `~/.git-credentials`:

```sh
git config --global credential.helper store
```

If you don't like to store it as plain text, it's also possible to save it only in RAM cache:

```sh
# <timeout> is how long it will be preserved in memory, defaults to 900 (seconds)
git config --global credential.helper 'cache --timeout=<timeout>'
```

If you have lost your PAT, it's OK to create another one.
