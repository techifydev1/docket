# Docket

Flutter app for Docket — a private family vault. Documents are encrypted on-device with libsodium before anything leaves the phone; the backend only ever stores ciphertext, so neither the server operator nor other family members can read what you seal.

## Features

- Onboarding with generated account keys and BIP-39 recovery phrase
- Email + OTP authentication (sign in, verification, password reset)
- Family vaults — create, switch, invite members with per-role permissions
- Encrypted document uploads (10 MB cap), preview, share and delete
- Invitation inbox (accept / decline)
- Account recovery from the 24-word phrase, with an OTP-gated key backup
- Settings: profile, vault info, switch/create vault
- Material 3 design system (`VaultTheme`) with glass chrome (bottom nav, dialogs, toasts)

## Stack

- Flutter (Dart 3.12), Provider for state management
- Firebase Auth for identity
- libsodium (`sodium`) — document encryption, key wrapping, hashing
- `bip39` — recovery phrases
- Dio — REST client against the Docket backend
- Cloudinary — direct client upload of encrypted blobs
- `pdfx`, `share_plus`, `file_picker`, `pinput`

## Getting started

Requirements: Flutter 3.44.x, a Firebase project, and the [Docket backend](https://github.com/techifydev1/docket-backend) running.

```bash
flutter pub get
flutter run
```

Configuration points:

- `lib/firebase_options.dart` — Firebase project config (regenerate with `flutterfire configure` if needed)
- `lib/features/http/dio_client.dart` — backend base URL (point it at your running backend, e.g. an ngrok URL)

## How encryption works

1. On account creation the app generates an X25519 keypair and a random family key. The family key is wrapped with the owner's public key; the server stores only the wrapped copy.
2. Uploading a document: encrypt with the family key (XSalsa20-Poly1305), upload the ciphertext to Cloudinary via a backend-signed URL, then confirm the upload with client-encrypted metadata.
3. Invited members receive the family key wrapped to their own public key — only they can unwrap it.
4. The recovery phrase derives a key that encrypts a key backup (`recovery/backup`); it is the only way back into the vaults if the device is lost.

## Project structure

```
lib/
  core/theme/        VaultTheme design system
  shared/            Reusable widgets (AppShell, GlassNav, Toast, ConfirmDialog, ...)
  features/
    crypto/          libsodium wrapper (encrypt, key wrapping, local key storage)
    http/            Dio client, API error handling
    auth/            Sign in, password reset, OTP
    onboarding/      Account + first vault setup, recovery phrase
    family/          Vault create/select, family cards
    documents/       Upload, list, preview, share, delete
    home/            Vault dashboard, quick actions, invite member
    invitation/      Invitation inbox
    recovery/        Phrase-based account recovery
    settings/        Profile, vault info, security
  main.dart          Provider wiring, MaterialApp
```

## Releasing an APK

Pushing a tag starting with `v` triggers GitHub Actions (`.github/workflows/release.yml`), which builds a release APK and publishes a GitHub release named after the tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```
