# Docket API Contract

Data models / DTOs the backend must return for every route the Flutter client
needs. Derived from the screens in `lib/features/` — each section names the
screen that consumes it.

## Conventions

| Concern | Rule |
| --- | --- |
| Base path | `/v1` |
| Content type | `application/json; charset=utf-8` (except binary upload/download) |
| Auth | `Authorization: Bearer <accessToken>` on everything except the public auth routes |
| Time | ISO-8601 UTC with offset, e.g. `2026-09-24T14:03:11Z` |
| Money/units | Bytes as integers (`fileSizeBytes`), never `"1.2 MB"` |
| IDs | Opaque strings. **Never send names where an ID belongs** (see Ownership) |
| Casing | `camelCase` |

### Success envelope

Single resources are returned bare. Collections are always paginated:

```json
{
  "items": [],
  "page": 1,
  "pageSize": 20,
  "total": 0
}
```

### Error envelope

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Request body is invalid.",
    "fields": { "email": "must be a valid email address" }
  }
}
```

`code` is stable and machine-readable; `message` is for humans and may change.
The client branches on `code` only.

| `code` | HTTP | Meaning |
| --- | --- | --- |
| `validation_failed` | 422 | Body/query failed validation; see `fields` |
| `unauthorized` | 401 | Missing/expired access token |
| `forbidden` | 403 | Authenticated but not permitted |
| `not_found` | 404 | Unknown or inaccessible resource |
| `email_taken` | 409 | Email already registered |
| `owner_immutable` | 409 | Attempted to change `ownerId` after creation |
| `member_owns_documents` | 409 | Cannot delete/remove a member who owns documents |
| `invite_limit_reached` | 409 | Vault member cap reached |
| `code_invalid_or_expired` | 400 | Email verification code wrong or stale |
| `upload_incomplete` | 409 | File bytes missing for the document |
| `weak_password` | 422 | Password failed strength rules |

### Client-derived values (do NOT send these)

The Flutter models currently hold pre-formatted strings because they are static
prototype data. When wiring a real backend, send raw values and let the client
format them. Anything listed here must be absent from the wire format:

| Current model field | Should be |
| --- | --- |
| `subtitle` (`"Added 2 days ago"`) | derived client-side from `addedAt` |
| `initials` (`"EV"`) | derived client-side via `initialsOf(name)` |
| `icon` | derived client-side from `category` |
| `fileSize` (`"1.2 MB"`) | `fileSizeBytes: 1258291` |
| `addedOn` / `modifiedOn` (`"24 September 2026"`) | `addedAt` / `modifiedAt` ISO-8601 |
| `visibility` (`"Eleanor Vance + Executor"`) | structured `visibility` object |
| `category.label` | sent as `category` id; label lives in `GET /document-categories` |

## Enums

`DocumentCategory` — wire values only. The Flutter enum also has an `all` member
used purely as a "no filter" sentinel in the filter chips; it is **not** a valid
category and must be rejected on write.

| Value | Display label |
| --- | --- |
| `certificates` | Certificates |
| `property` | Property |
| `health` | Health |
| `identity` | IDs |

`Relation` — from the invite screen's relation chips.

`spouse` · `child` · `parent` · `sibling` · `executor` · `other`

`UploadState` — drives the "Pending upload" / "Preview not available yet" states
already present in the add-file and details screens.

| Value | Meaning |
| --- | --- |
| `pending` | Metadata saved, no bytes uploaded yet |
| `uploading` | Bytes in flight |
| `ready` | Encrypted and stored; preview/download available |
| `failed` | Upload errored, retryable |

`MemberStatus` — `invited` · `active` · `revoked`

## Entities

### UserProfile

`GET/PATCH /profile` · also embedded in auth responses

| Field | Type | Notes |
| --- | --- | --- |
| `id` | string | |
| `fullName` | string | 1–120 chars. Editable |
| `email` | string | Lowercased. Editable, must stay unique |
| `phone` | string \| null | "Emergency Contact Phone" in onboarding |
| `avatarUrl` | string \| null | Null until uploaded; the app renders initials |
| `biometricsEnabled` | boolean | Mirrors the onboarding toggle |
| `createdAt` | datetime | |
| `vaultId` | string | The one vault this user belongs to |

### Vault

`GET /vault` · rendered by `VaultCard` (home) and `VaultInfoCard` (settings)

| Field | Type | Notes |
| --- | --- | --- |
| `id` | string | Shown as "Vault ID" |
| `name` | string | "The Vance Family". Max 36 chars (onboarding limit) |
| `tagline` | string | "Household Archival System" |
| `memberCount` | integer | Shown in vault info + home stats |
| `documentCount` | integer | Home stat |
| `encryptedDocumentCount` | integer | Home shows `encrypted / total` as a percentage |
| `totalSizeBytes` | integer | Optional, for future storage display |
| `encryption` | string | Always `"zero_knowledge"` for now |
| `createdAt` | datetime | "Created" row in vault info |
| `memberLimit` | integer | Enables `invite_limit_reached` before the user taps |

### Member

`GET /members` · `POST /members` (invite screen) · `PATCH /members/{id}`

| Field | Type | Notes |
| --- | --- | --- |
| `id` | string | **Documents reference this, never the name** |
| `name` | string | Full name as typed on the invite screen |
| `relation` | `Relation` | |
| `canAddDocuments` | boolean | Default `true`; drives the "Can add documents" toggle |
| `canOwnDocuments` | boolean | Default `false`; drives "Can own documents" |
| `status` | `MemberStatus` | `invited` until they accept |
| `invitedById` | string | Usually the acting user |
| `invitedAt` | datetime | |
| `acceptedAt` | datetime \| null | Null while `invited` |

### Document

`GET /documents` (summary) · `GET /documents/{id}` (full) · `POST/PATCH /documents`

| Field | Type | List? | Notes |
| --- | --- | --- | --- |
| `id` | string | ✓ | |
| `title` | string | ✓ | Free text, e.g. "Birth Certificate" |
| `category` | `DocumentCategory` | ✓ | Filterable. Required on create |
| `ownerId` | string | ✓ | **Immutable after creation.** See Ownership |
| `fileName` | string | ✓ | "Eleanor_Vance_Birth_Certificate.pdf" |
| `fileType` | string \| null | | `PDF`, `JPG`, … Null while `uploadState` is `pending` |
| `fileSizeBytes` | integer \| null | | Null while `pending` |
| `pageCount` | integer \| null | | Null until parsed server-side |
| `addedAt` | datetime | ✓ | Sort key for "Recent Documents" |
| `modifiedAt` | datetime | | |
| `addedById` | string | | Who created it (may differ from `ownerId`) |
| `visibility` | `Visibility` | | Who may open it |
| `tags` | string[] | | Free-form, deduped case-insensitively by the client |
| `fingerprint` | string \| null | | Content hash. Null while `pending` |
| `uploadState` | `UploadState` | | `pending` → client shows "Pending upload" |
| `previewAvailable` | boolean | | `false` until a renderer exists; details screen shows a placeholder |
| `encryption` | object | | `algorithm`, `keyVersion`, `storageKey` |

`DocumentSummary` (list rows) is `Document` minus `encryption` and `previewAvailable`.

`Visibility`:

```json
{ "mode": "all_members" }
{ "mode": "only_owner" }
{ "mode": "selected", "memberIds": ["mem_9f42", "mem_a1c7"] }
```

`mode: "selected"` must reference members whose `status` is `active`. Viewing is
not a per-member toggle — the invite screen offers no way to withhold it, since
an invite that cannot see anything is pointless. Rendered on the details screen
as the "Visible to" row.

### Preferences

`GET/PATCH /preferences` · the three `ToggleTile`s on the settings screen

| Field | Type | Default | Toggle |
| --- | --- | --- | --- |
| `biometricsEnabled` | boolean | `true` | Biometric / Face ID Lock |
| `lockOnExit` | boolean | `false` | Lock on exit |
| `emailAlerts` | boolean | `true` | Vault email alerts |

`PATCH` is a partial update; omitted keys are untouched.

### AuthSession

Returned by register / login / refresh.

| Field | Type | Notes |
| --- | --- | --- |
| `accessToken` | string | Short-lived, sent as a bearer token |
| `refreshToken` | string | Single-use, rotate on every refresh |
| `expiresIn` | integer | Seconds until `accessToken` expires |
| `user` | `UserProfile` | |
| `vault` | `Vault` | Saved by the client so Home needs no extra round trip |

## Routes

### Auth — onboarding and login

| Method | Path | Request | Response |
| --- | --- | --- | --- |
| `POST` | `/auth/register` | `RegisterRequest` | `AuthSession` |
| `POST` | `/auth/verify-email` | `{ "email", "code" }` | `{ "verified": true }` |
| `POST` | `/auth/login` | `{ "email", "password" }` | `AuthSession` |
| `POST` | `/auth/refresh` | `{ "refreshToken" }` | `AuthSession` |
| `POST` | `/auth/logout` | — | `204` |
| `POST` | `/auth/forgot-password` | `{ "email" }` | `202` |

```jsonc
// POST /auth/register
{
  "vaultName": "The Vance Family",   // max 36
  "fullName": "Eleanor Vance",
  "email": "eleanor@vance.family",
  "phone": "+15552345678",           // optional
  "password": "…",
  "biometricsEnabled": true
}
```

`/auth/verify-email` takes the 6-digit code (`pinput(length: 6)` on the third
onboarding screen). Return `code_invalid_or_expired` if stale.

`/auth/forgot-password` must return `202` whether or not the email exists, so the
endpoint cannot be used to enumerate accounts. The "Forgot password?" button on
the login card is currently a no-op and will call this.

### Vault and profile

| Method | Path | Request | Response |
| --- | --- | --- | --- |
| `GET` | `/vault` | — | `Vault` |
| `PATCH` | `/vault` | `{ "name"?, "tagline"? }` | `Vault` |
| `GET` | `/profile` | — | `UserProfile` |
| `PATCH` | `/profile` | `{ "fullName"?, "email"?, "phone"?, "avatarUrl"? }` | `UserProfile` |
| `GET` | `/preferences` | — | `Preferences` |
| `PATCH` | `/preferences` | partial `Preferences` | `Preferences` |

`PATCH /profile` returns the updated profile so the settings screen and the
`initialsOf`-derived avatar update from one response.

### Members

| Method | Path | Request | Response |
| --- | --- | --- | --- |
| `GET` | `/members` | — | `Member[]` (unpaginated; bounded by `Vault.memberLimit`) |
| `POST` | `/members` | `InviteMemberRequest` | `Member` (201, `status: "invited"`) |
| `PATCH` | `/members/{memberId}` | `{ "name"?, "relation"?, "canAddDocuments"?, "canOwnDocuments"? }` | `Member` |
| `DELETE` | `/members/{memberId}` | — | `204` |
| `POST` | `/members/{memberId}/resend-invite` | — | `Member` |

```jsonc
// POST /members  — the invite screen
{
  "name": "Noah Vance",
  "relation": "child",
  "canAddDocuments": true,
  "canOwnDocuments": false
}
```

Enforce `memberLimit` from `Vault` with `invite_limit_reached`. There is no email
field: the app identifies members by name, so an invite is delivered out of band.
If you add `email`, make it optional and treat it as a delivery address only.

`DELETE` must return `member_owns_documents` (409) when the member is the
`ownerId` of any document. See Ownership for why this is not fixable by a
transfer.

### Documents

| Method | Path | Request | Response |
| --- | --- | --- | --- |
| `GET` | `/documents` | query below | paginated `DocumentSummary` |
| `POST` | `/documents` | `CreateDocumentRequest` | `Document` (201, `uploadState: "pending"`) |
| `GET` | `/documents/{documentId}` | — | `Document` |
| `PATCH` | `/documents/{documentId}` | `UpdateDocumentRequest` | `Document` |
| `DELETE` | `/documents/{documentId}` | — | `204` |
| `GET` | `/documents/{documentId}/file` | — | binary ciphertext |
| `GET` | `/document-categories` | — | `[{ "id", "label" }]` |

`GET /documents` query parameters:

| Param | Type | Notes |
| --- | --- | --- |
| `category` | `DocumentCategory` | Omit for "All". Never send `all` |
| `ownerId` | string | |
| `tag` | string | Repeatable |
| `q` | string | Title/file name search |
| `sort` | string | `recent` (default) \| `title` \| `modified` |
| `page`, `pageSize` | integer | Default `1` / `20`, max `100` |

```jsonc
// POST /documents  — the add-file screen
{
  "title": "Birth Certificate",
  "category": "certificates",
  "ownerId": "mem_9f42",
  "visibility": { "mode": "all_members" },
  "tags": ["Vital record", "Certified copy"]
}
```

Returns `201` with `uploadState: "pending"`, `fileType`, `fileSizeBytes` and
`fingerprint` all `null`. The client then uploads bytes. This two-phase create
matches the screen, which already renders a record whose type, size and
fingerprint are "Pending".

```jsonc
// PATCH /documents/{documentId}
{ "title": "Noah's Birth Certificate", "category": "certificates", "tags": ["Vital record"] }
```

### Uploads

| Method | Path | Request | Response |
| --- | --- | --- | --- |
| `POST` | `/uploads` | `{ "documentId", "fileName", "fileSizeBytes" }` | `UploadTicket` |
| `PUT` | `/uploads/{uploadId}` | raw bytes (or chunk) | `{ "received": <int> }` |
| `POST` | `/uploads/{uploadId}/complete` | `{ "checksum" }` | `Document` |

```jsonc
// POST /uploads
{
  "uploadId": "upl_01h...",
  "storageKey": "vault_9f42/2026/09/doc_3b7d.enc",
  "chunkSize": 5242880,
  "expiresAt": "2026-09-24T15:03:11Z"
}
```

`PUT` bodies must already be encrypted with the vault key — the backend stores
ciphertext and must never be able to read it. `complete` verifies `checksum`
against the ciphertext, flips `uploadState` to `ready`, and fills in
`fileSizeBytes`, `fingerprint` and `pageCount`.

While `uploadState` is not `ready`, `GET /documents/{id}/file` returns
`upload_incomplete` (409).

## Rules the backend must enforce

### Ownership is permanent

`ownerId` is set once at `POST /documents` and can never change. `PATCH
/documents/{documentId}` must reject any body containing `ownerId` with
`owner_immutable` (409) — the client renders a permanent "Locked" pill next to
the Owner row and offers no reassignment path, so silently accepting it would
desync the UI from stored data.

This has two knock-on effects:

1. **Documents must reference `ownerId`, not the owner's name.** Otherwise
   renaming a member in `PATCH /members/{id}` retroactively changes the owner
   shown on every document they own. The current Flutter prototype stores
   `owner: "Eleanor Vance"` as a string, which is exactly this bug waiting to
   happen — switch it to an id when you wire up state.
2. **A member who owns documents cannot be deleted.** Return
   `member_owns_documents` (409) instead of cascading. Cascading would destroy
   documents or silently orphan them, and reassigning to unblock the delete
   would violate rule 1. Surface this in the UI as "this member owns N documents"
   rather than offering a transfer.

Only the vault owner may invite members, and only the vault owner may delete
documents.

### Zero-knowledge

The server stores ciphertext only. It must never receive plaintext file content,
and `GET /documents/{id}/file` returns ciphertext for client-side decryption. The
client encrypts with a key the backend does not hold, which is what makes
`encryption.algorithm` / `keyVersion` worth versioning.

## Client mapping

| DTO | Flutter target |
| --- | --- |
| `Document` | `lib/features/documents/document_item.dart` (`DocumentItem`) |
| `Member` | `lib/shared/vault_member.dart` (`VaultMember`) |
| `UserProfile` | `lib/features/settings/profile.dart` (`Profile`) |
| `Vault` | currently hardcoded in `VaultCard` and `VaultInfoCard` |
| `Preferences` | three booleans held as local state in `SettingsScreen` |
| `DocumentCategory` | `lib/features/documents/document_category.dart` |

The client currently has no state provider, so every screen owns local copies of
this data. `vaultMembers` is a growable list that the invite screen appends to;
that is the seam a `ChangeNotifier`-based store should replace.
