# Signing in to GitLab

## Joining Redox GitLab

You don't need to join our GitLab to build Redox, but you will if you want to contribute. Obtaining a Redox account requires approval from a human, because of the high number of spam accounts that are created on this type of project. To join, first, go to [Redox GitLab] and click the Sign In/Register button. Create your User ID and Password. Then, send an email to info@redox-os.org indicating your GitLab User ID and requesting that your account be approved. Please give a brief statement about what you intend to use the account for. This is mainly to ensure that you are a genuine user.

Approval of your GitLab account may take several days, as there are typically hundreds of spam registrations and emails to wade through. In the meantime, join us on [Chat](./ch13-01-chat.md) and let us know what you are working on.

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
 - your web browser open at https://gitlab.redox-os.org/redox-os/
 - your phone
 - your 2FA App installed on your phone.
 - to add https://gitlab.redox-os.org/redox-os/ as a site in your 2FA App.  Once added and the site listed, underneath you'll see 2 sets of 3 digits, 6 digits in all. i.e. **258 687**. That's the 2FA Verification Code.  It changes every so often around every minute.

### Available 2FA Apps for Android
 
 On Google Android, you may use:
 - Google Authenticator https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_CA&gl=US 
 - **Aegis** Authenticator(open-source) available not only on playstore https://play.google.com/store/apps/details?id=com.beemdevelopment.aegis&hl=en_CA&gl=US but also F-Droid Free and Open Source Software repo as well https://f-droid.org/en/packages/com.beemdevelopment.aegis/

### Available 2FA Apps for iPhone

 On Apple iphone, you may use:
  - 2stable Authenticator https://9to5mac.com/2021/05/11/2fa-authenticator-app-2stable-iphone-mac-apple-watch-ipad/
  - **Tofu** Authenticator(open-source) https://apps.apple.com/us/app/tofu-authenticator/id1082229305
  - iOS built-in authenticator https://support.apple.com/guide/iphone/automatically-fill-in-verification-codes-ipha6173c19f/ios
 
### Logging-In With An Google Android Phone

Here are the steps:
 - From your computer web browser, open https://gitlab.redox-os.org/redox-os/
 - Click the SignIn button
 - Enter your username/email
 - Enter your password
 - Click the Submit button
 - Finally you will be prompted for a 2FA verification code from your phone. Go to your Android phone, go to Google/**Aegis** Authenticator, find the site gitlab redox and underneith those 6 digits in looking something like **258 687** that's your 2FA code.  Enter those 6 digits into the prompt on your computer.  Click Verify.  Done.  You're logged into Gitlab.
 
### Logging-In With An Apple iPhone

Here are the steps:
 - From your computer web browser, open https://gitlab.redox-os.org/redox-os/
 - Click the SignIn button
 - Enter your username/email
 - Enter your password
 - Click the Submit button
 - Finally you will be prompted for a 2FA verification code from your phone. Go to your iPhone, go to 2stable/**Tofu** Authenticator or to your Settings->Passwords for iOS Authenticator, find the site gitlab redox and underneath those 6 digits in looking something like **258 687** that's your 2FA code.  Enter those 6 digits into the prompt on your computer.  Click Verify.  Done.  You're logged into Gitlab.

[Redox GitLab]: https://gitlab.redox-os.org/