# Signing in to GitLab

## Joining Redox GitLab

You don't need to join our GitLab to build Redox, but you will if you want to contribute. Obtaining a Redox account requires approval from a GitLab administrator, because of the high number of spam accounts (bots) that are created on this type of project. To join, first, go to [Redox GitLab](https://gitlab.redox-os.org/) and click the Sign In/Register button. Create your User ID and Password. Then, send an message to the [GitLab Approvals](https://matrix.to/#/#redox-gitlab:matrix.org) room indicating your GitLab User ID and requesting that your account be approved. Please give a brief statement about what you intend to use the account for. This is mainly to ensure that you are a genuine user.

The approval of your GitLab account may take some minutes or hours, in the meantime, join us on [Chat](./chat.md) and let us know what you are working on.

## Setting up 2FA

Your new GitLab account will not require 2 Factor Authentication at the beginning, but it will eventually insist. Some details and options are described in detail [below](#2fa-apps).

## Using SSH for your Repo

When using `git` commands such as `git push`, `git` may ask you to provide a password. Because this happens frequently, you might wish to use `SSH` authentication, which will bypass the password step. Please follow the instructions for using `SSH` [here](https://docs.gitlab.com/ee/user/ssh.html). [ED25519](https://docs.gitlab.com/ee/user/ssh.html#ed25519-ssh-keys) is a good choice. Once SSH is set up, always use the SSH version of the URL for your `origin` and `remote`. e.g.

  - HTTPS:

  ```sh
  git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
  ```

  - SSH:

  ```sh
  git clone git@gitlab.redox-os.org:redox-os/redox.git --origin upstream --recursive
  ```
  
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
