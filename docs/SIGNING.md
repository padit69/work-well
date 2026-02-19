# Code signing & notarization (macOS)

Để user có thể mở HealthyWork mà không gặp lỗi **"HealthyWork is damaged and can't be opened"**, bạn cần **ký (code sign)** và **notarize** app bằng Apple Developer ID. Hướng dẫn dưới đây dùng cho GitHub Actions.

## Yêu cầu

- **Apple Developer Program** (trả phí, ~$99/năm): [developer.apple.com](https://developer.apple.com/programs/)
- Team ID và quyền tạo **Developer ID Application** certificate

## Bước 1: Tạo Developer ID Application certificate

1. Vào [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/certificates/list).
2. **Certificates** → **+** (Add).
3. Chọn **Developer ID Application** → Continue.
4. Tạo **Certificate Signing Request (CSR)** trên Mac:
   - Mở **Keychain Access** → **Keychain Access** menu → **Certificate Assistant** → **Request a Certificate From a Certificate Authority**.
   - Email: email Apple ID của bạn.
   - Common Name: ví dụ `Developer ID Application: Your Name`.
   - Chọn **Saved to disk** → Continue → lưu file `.certSigningRequest`.
5. Quay lại trang Apple Developer, upload file CSR → Continue → **Download** certificate (`.cer`).
6. Double-click file `.cer` để cài vào Keychain.

## Bước 2: Export certificate thành file .p12

1. Mở **Keychain Access**.
2. Ở **login** keychain, chọn **My Certificates**.
3. Tìm certificate **Developer ID Application: …** (có thể nằm cùng private key bên dưới).
4. Chọn certificate (và key nếu chưa chọn), **File** → **Export Items…**.
5. Định dạng: **Personal Information Exchange (.p12)**.
6. Lưu file (ví dụ `DeveloperIDApplication.p12`) và đặt **mật khẩu mạnh** cho file .p12 (dùng làm `P12_PASSWORD`).

## Bước 3: Chuyển .p12 sang base64 (cho GitHub Secret)

Trên terminal (Mac):

```bash
base64 -i DeveloperIDApplication.p12 | pbcopy
```

Hoặc lưu vào file:

```bash
base64 -i DeveloperIDApplication.p12 -o p12-base64.txt
```

Nội dung (một dòng dài) sẽ dùng cho secret `BUILD_CERTIFICATE_BASE64`.

## Bước 4: App-specific password (cho notarization)

1. Vào [appleid.apple.com](https://appleid.apple.com) → **Sign-In and Security** → **App-Specific Passwords**.
2. Tạo password mới (ví dụ tên "GitHub Actions Notary"), copy và lưu lại (dùng làm `APPLE_APP_SPECIFIC_PASSWORD`).

## Bước 5: Cấu hình GitHub

### 5.1. Repository variables

Vào repo **Settings** → **Secrets and variables** → **Actions** → tab **Variables**:

| Name                | Value   | Ghi chú        |
|---------------------|---------|----------------|
| `ENABLE_CODE_SIGNING` | `true` | Bật ký + notarize |

### 5.2. Repository secrets

Cùng trang, tab **Secrets** → **New repository secret**:

| Secret name                   | Mô tả |
|------------------------------|--------|
| `BUILD_CERTIFICATE_BASE64`   | Nội dung base64 của file .p12 (bước 3) |
| `P12_PASSWORD`               | Mật khẩu file .p12 (bước 2) |
| `APPLE_ID`                   | Email Apple ID (dùng cho notary) |
| `APPLE_APP_SPECIFIC_PASSWORD`| App-specific password (bước 4) |
| `APPLE_TEAM_ID`              | Team ID (10 ký tự, ví dụ `NTMW9R35A8`) – xem [Membership](https://developer.apple.com/account#MembershipDetailsCard) |

## Bước 6: Chạy release

Sau khi đã set variable `ENABLE_CODE_SIGNING = true` và đủ 5 secrets:

1. Tạo tag và push: `git tag v1.0.1 && git push origin v1.0.1`.
2. Workflow **Release** sẽ:
   - Import certificate.
   - Build app với **Developer ID Application**.
   - Gửi app lên Apple Notary.
   - Staple ticket vào app.
   - Đóng gói ZIP/DMG và tạo GitHub Release.

User tải bản release này sẽ mở app bình thường, không còn lỗi "damaged".

## Không dùng ký / notarize

Nếu **không** set `ENABLE_CODE_SIGNING` (hoặc để `false`):

- Workflow vẫn chạy, build **unsigned** như trước.
- User mở app lần đầu: **Right-click** (hoặc Control-click) **HealthyWork.app** → **Open** → **Open** trong hộp thoại.

## Xử lý lỗi notarization

- Nếu bước **Notarize app** báo **Invalid**:
  - Trong log workflow có **submission ID**.
  - Trên Mac: `xcrun notarytool log <submission-id> --apple-id ... --password ... --team-id ...` để xem log chi tiết.
- Thường gặp: thiếu **Hardened Runtime** hoặc **entitlements** không đúng. Project HealthyWork đã bật `ENABLE_HARDENED_RUNTIME = YES`; nếu vẫn lỗi, kiểm tra entitlements và dependencies được ký đúng.

## Tham khảo

- [Signing Mac Software with Developer ID](https://developer.apple.com/developer-id/)
- [Notarizing macOS software before distribution](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)
- [apple-actions/import-codesign-certs](https://github.com/Apple-Actions/import-codesign-certs)
