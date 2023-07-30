## [1.1.0](https://github.com/Structed/godot-playfab/compare/1.0.1...1.1.0) (2023-07-30)


### Features

* **platform:** Upgrade to Godot 4.1 ([#121](https://github.com/Structed/godot-playfab/issues/121)) ([42c2af4](https://github.com/Structed/godot-playfab/commit/42c2af43ac5c7e71ef27095530f66aafe9b4f5da))
* **setup:** add programmatic autoload in PlayFabEditor plugin script ([#120](https://github.com/Structed/godot-playfab/issues/120)) ([d34d7fe](https://github.com/Structed/godot-playfab/commit/d34d7fe9875765e0132b411d93fc6018d5b4e9e4))


### Bug Fixes

* add description on how to add Title ID ([69b09b1](https://github.com/Structed/godot-playfab/commit/69b09b15f8e513d6a8161aa654d232486f442c47))



### [1.0.1](https://github.com/Structed/godot-playfab/compare/1.0.0...1.0.1) (2023-06-13)


### Bug Fixes

* **serializer:** hardcoded ignoring of first 3 items of properties on to be serialized object ([#118](https://github.com/Structed/godot-playfab/issues/118)) ([0da7b4d](https://github.com/Structed/godot-playfab/commit/0da7b4d380eaa092006fee2093c436d4814c8503))



## [1.0.0](https://github.com/Structed/godot-playfab/compare/0.3.4...1.0.0) (2023-06-03)


### ⚠ BREAKING CHANGES

* **core:** Update for Godot 4 stable

Upgraded to Godot 4. Thanks to: @MikeSchulze for GDUnit his GH Action workflow examples - https://github.com/MikeSchulze/gdUnit4 @bitbrain for his GH Action workflow examples in https://github.com/bitbrain/beehave

fix(example): Update Events demo scene for Godot 4
fix(example): crash issue on writing telemetry events
ci(pipeline): workflow_dispatch to be in correct indent level
ci(pipeline): Update GDUnit4 actions
ci(pipeline): Run unit tests on Godot 4.02 & 4.0.3
ci(pipeline): Separate Godot 4 & 3 branches
ci(pipeline): Separate Godot 4 workflows
ci(pipeline): set new asset ID for new Asset in AssetLib
ci(pipeline): Exclude LoginIntegrationTest (broken)
ci(pipeline): Removed defunct & unused plugin refresher
test(pipeline): Switch test framework to GDUnit4
docs(readme): Added users of godot-playfab to README.md
docs(license)Updated licenses

### Features

* **core:** Godot 4 upgrade ([0d39b88](https://github.com/Structed/godot-playfab/commit/0d39b88faab532aced5259fbe2af8ca119636425))


### Changes

* add note note to highlight Godot4 prerelease availability ([fef9a1d](https://github.com/Structed/godot-playfab/commit/fef9a1d3344c7beb7f1305551df477b9e17d2971))


### Continuous Integration

* bump mathieudutour/github-tag-action to v6.1 ([7491b16](https://github.com/Structed/godot-playfab/commit/7491b16eb92adfacb9882004378d183f2e38877b))



### [0.3.4](https://github.com/Structed/godot-playfab/compare/0.3.3...0.3.4) (2023-01-25)


### Bug Fixes

* Implementation to check for GZip Accept-Encoding header  ([#101](https://github.com/Structed/godot-playfab/issues/101)) ([d4c1f15](https://github.com/Structed/godot-playfab/commit/d4c1f15c2d99c75028e159004cebdb75b02416e8))


### Continuous Integration

* enable release job on  branch ([e90d587](https://github.com/Structed/godot-playfab/commit/e90d5873dfb771e64b6629307244f4e46078292c))
* fix step name when using changelog output ([39269b5](https://github.com/Structed/godot-playfab/commit/39269b54b5a4fb880de9f5391c44edaae0a2bdb9))
* USe release notes from  and also create prereleases ([3e7b942](https://github.com/Structed/godot-playfab/commit/3e7b942e5428d8bda80edaa5eec320a33e53f2b7))



### [0.3.3](https://github.com/Structed/godot-playfab/compare/0.3.2...0.3.3) (2023-01-23)


### Bug Fixes

* Do not assume GZip compressed response. ([#99](https://github.com/Structed/godot-playfab/issues/99)) ([1110d8e](https://github.com/Structed/godot-playfab/commit/1110d8e750ad41d337beb65dd181562998a37371))



### [0.3.2](https://github.com/Structed/godot-playfab/compare/0.3.1...0.3.2) (2023-01-22)


### Bug Fixes

* .editorconfig ([79300cf](https://github.com/Structed/godot-playfab/commit/79300cf1764472a87d0d9ea68b7cb631b7406106))
* PlayFabEvent._assemble_event() did not properly accept the  parameter ([#95](https://github.com/Structed/godot-playfab/issues/95)) ([1ad4e3f](https://github.com/Structed/godot-playfab/commit/1ad4e3f89c85816256239dd760d0b3017a604239))


### Continuous Integration

* fix whitespace ([f4d53df](https://github.com/Structed/godot-playfab/commit/f4d53dfa03cc32f8e439705a77740412073b7a1b))
* fix yaml ([10f9fb9](https://github.com/Structed/godot-playfab/commit/10f9fb97afbfb9a07ad0d32fc9ca8772d1f5208c))
* remove unused env variable ([f991a2b](https://github.com/Structed/godot-playfab/commit/f991a2bd500e5c6c3aa03acfc576480477b5011f))
* updated/upgraded workflows ([3ffab3a](https://github.com/Structed/godot-playfab/commit/3ffab3a7acbc09230e9f47aac0d35a3323505aa6))
* using PAT again ([3a42d0f](https://github.com/Structed/godot-playfab/commit/3a42d0ff781e1fc364a0b3d130efcc9296d4fe40))



## [0.3.0](https://github.com/Structed/godot-playfab/compare/0.2.0...0.3.0) (2022-12-18)


### Features

* **pencil:** Add response compression (gzip) ([#87](https://github.com/Structed/godot-playfab/issues/87)) ([248972c](https://github.com/Structed/godot-playfab/commit/248972cdaf9891e5fd8a3308471831967ee00c9c))


### Bug Fixes

* **pencil:** Do not require callbacks for Events API ([#90](https://github.com/Structed/godot-playfab/issues/90)) ([71d0a92](https://github.com/Structed/godot-playfab/commit/71d0a929938428af305c2b2e9eb01a2a800f7153))



## [0.2.0](https://github.com/Structed/godot-playfab/compare/0.1.0...0.2.0) (2022-11-21)


### Features

* **pencil:** Add Default Theme ([#64](https://github.com/Structed/godot-playfab/issues/64)) ([72bce50](https://github.com/Structed/godot-playfab/commit/72bce508cb3ff08a4dc5fddab35c2d82b301ef4c))


### Bug Fixes

* **pencil:** 55 update documentation ([#78](https://github.com/Structed/godot-playfab/issues/78)) ([161dd26](https://github.com/Structed/godot-playfab/commit/161dd2666e63f05cde49afc77623c976a462eb4e))
* **pencil:** Added missing  in  to specify . Otherwise, deserialization would fail. ([e2d73c1](https://github.com/Structed/godot-playfab/commit/e2d73c10bd5c07f5920278c2a7a2087cb89c139e))
* **pencil:** Anonymous Login button does not turn green after successful anonymous login [#81](https://github.com/Structed/godot-playfab/issues/81) ([#82](https://github.com/Structed/godot-playfab/issues/82)) ([090dc2c](https://github.com/Structed/godot-playfab/commit/090dc2c61f6b8c2413de0b1f2afbd7db5dfa69ed))
* **pencil:** fix code docs ([47223ef](https://github.com/Structed/godot-playfab/commit/47223ef624efcb6e83af3ac85e8f76fb737844c8))
* **pencil:** Fix demo scene file ([a2a244f](https://github.com/Structed/godot-playfab/commit/a2a244f3ef1741cc08f49688196607ad6b982400))
* **pencil:** Login with incorrect credentials stalls the demo [#76](https://github.com/Structed/godot-playfab/issues/76) ([#77](https://github.com/Structed/godot-playfab/issues/77)) ([b4f25fb](https://github.com/Structed/godot-playfab/commit/b4f25fb05d35463ea8bf8d974a6b8a3dccd85f38))
* **pencil:** Update demo scene gif ([#80](https://github.com/Structed/godot-playfab/issues/80)) ([71c4b15](https://github.com/Structed/godot-playfab/commit/71c4b157babbaf037a6981ec5caca0955e702caf))



## [0.1.0](https://github.com/Structed/godot-playfab/compare/0.0.6...0.1.0) (2022-11-07)


### Features

* **pencil:** 65 timestamp of events ([#66](https://github.com/Structed/godot-playfab/issues/66)) ([34d0be7](https://github.com/Structed/godot-playfab/commit/34d0be7e9babb685b8ce9398a3ed5398f3be5a5f))
* **pencil:** 72 add discord shield ([#73](https://github.com/Structed/godot-playfab/issues/73)) ([5e666ba](https://github.com/Structed/godot-playfab/commit/5e666ba07ca8736644208c0be5cbadf561d63321))


### Bug Fixes

* **pencil:** Add missing icon.png.import ([97f9589](https://github.com/Structed/godot-playfab/commit/97f958986b0c69d76ce16664b42749e1a1f683b5))
* **pencil:** Add test step for Gopdot 3.4.4 ([#70](https://github.com/Structed/godot-playfab/issues/70)) ([7135bfe](https://github.com/Structed/godot-playfab/commit/7135bfe9bc1628572c38451aa773e0ecd3258839))
* **pencil:** Use Godot 3.5 stable ([#69](https://github.com/Structed/godot-playfab/issues/69)) ([74d06cc](https://github.com/Structed/godot-playfab/commit/74d06ccedb246d64a7be1493050baaaebb98dd0a))



### [0.0.5](https://github.com/Structed/godot-playfab/compare/v0.0.4...0.0.5) (2022-07-17)


### Bug Fixes

* **pencil:** release workflow ([1be05de](https://github.com/Structed/godot-playfab/commit/1be05deec0e2e9523d8e5d8156ebfb6a5218a1c3))
* changelog ([23b34c6](https://github.com/Structed/godot-playfab/commit/23b34c62a9feb9d275a065ee4f1f258ac20aed62))
* do not check on whether to update plugin.cfg ([e62bd1e](https://github.com/Structed/godot-playfab/commit/e62bd1ec61266b75e3d3b715a76b1f17e67def31))
* do not restrict on develop branch ([7cc878e](https://github.com/Structed/godot-playfab/commit/7cc878e739ef26ba17558e6a401a42bdeab1a5ad))
* dry run (do not create a tag) if not on main ([dbb3a68](https://github.com/Structed/godot-playfab/commit/dbb3a6806a335d8e1b2e952bdaca3a6f6fa9c258))
* enable itch ([c416eff](https://github.com/Structed/godot-playfab/commit/c416effbc14ac0a729184ff661e2db501258092a))
* introducing PAT ([b235453](https://github.com/Structed/godot-playfab/commit/b235453112bdf71ef2227321e892555456ecf5cd))
* make releases public by default ([edb6414](https://github.com/Structed/godot-playfab/commit/edb64145aee4e590072dc1f17ed99027a9b9103d))
* only run itch on main ([109c61f](https://github.com/Structed/godot-playfab/commit/109c61f9f1d0571d0e858f5d815fdd7789fe82f8))
* only run on branch main ([61d5a3a](https://github.com/Structed/godot-playfab/commit/61d5a3a008c6d0a0cb63a97485d5164e690d1986))
* quoting banch names ([764772e](https://github.com/Structed/godot-playfab/commit/764772e1fe32e52b93116ca014c27b09875358df))
* re-enable itch release ([3309664](https://github.com/Structed/godot-playfab/commit/3309664429bb1cbfe93ec67527c2ce0a360806d0))
* remove test-changelog ([d00ffab](https://github.com/Structed/godot-playfab/commit/d00ffab3112866d771c0dd0bc1a931f2e8ea2449))
* reset version ([f20d4d1](https://github.com/Structed/godot-playfab/commit/f20d4d10073054fc6c8abc19fcb23e8abd9ac713))
* reset version ([7cafbf2](https://github.com/Structed/godot-playfab/commit/7cafbf250e4cee4930c04566e92a430c47231c42))
* run asset lib release only on main ([f9d0f1e](https://github.com/Structed/godot-playfab/commit/f9d0f1e59bd67f029ac8f6f3946442b0565a95a5))
* run main workflow on main and develop ([956e328](https://github.com/Structed/godot-playfab/commit/956e328c9948c96cd16af661fea6828316091ceb))
* test again ([c07672d](https://github.com/Structed/godot-playfab/commit/c07672df773a3144c392005f7511bf218dca5ed1))
* upload of artifact with proper version ([ad83470](https://github.com/Structed/godot-playfab/commit/ad834707812a16c322688551e6d8c8abc83fb634))
* use calculate version ([bf0d538](https://github.com/Structed/godot-playfab/commit/bf0d5388dc042da87697c7e041ab085b84c39f21))
* version for itch build ([9baade6](https://github.com/Structed/godot-playfab/commit/9baade6e20aedf8e096cce57260165dd93649b24))
* version of mathieudutour/github-tag-action ([5304ba4](https://github.com/Structed/godot-playfab/commit/5304ba46ea552c6cf30aecf3718b1984f9dd876d))



### [0.0.13](https://github.com/Structed/godot-playfab/compare/0.0.12...0.0.13) (2022-07-17)


### Bug Fixes

* re-enable itch release ([3309664](https://github.com/Structed/godot-playfab/commit/3309664429bb1cbfe93ec67527c2ce0a360806d0))



### [0.0.12](https://github.com/Structed/godot-playfab/compare/0.0.11...0.0.12) (2022-07-16)


### Bug Fixes

* try version AssetLib HandleBars ([e0148fb](https://github.com/Structed/godot-playfab/commit/e0148fb9f6c6c7d83d4f77d8fcc539c998b5d8eb))



### [0.0.11](https://github.com/Structed/godot-playfab/compare/0.0.10...0.0.11) (2022-07-16)


### Bug Fixes

* accidentially committed failing yaml ([9e21f7d](https://github.com/Structed/godot-playfab/commit/9e21f7d463d8a95aeb0ad254c4a5ea20bbc01cd4))



### [0.0.10](https://github.com/Structed/godot-playfab/compare/0.0.9...0.0.10) (2022-07-16)


### Bug Fixes

* step name in HB ([2e0baa5](https://github.com/Structed/godot-playfab/commit/2e0baa5e406d407f0e318132d57bd660110f267c))
* update ([82496a3](https://github.com/Structed/godot-playfab/commit/82496a3b5d8e8932e7e10dfc7825bab5c6a626c4))



### [0.0.9](https://github.com/Structed/godot-playfab/compare/0.0.8...0.0.9) (2022-07-16)


### Bug Fixes

* version ion Handlebars for AssetLib ([83b2401](https://github.com/Structed/godot-playfab/commit/83b2401a9cd31eb116191222a7cca485c5aa888f))



### [0.0.8](https://github.com/Structed/godot-playfab/compare/0.0.7...0.0.8) (2022-07-16)


### Bug Fixes

* handlebars template for AssetLib export ([ff1bda7](https://github.com/Structed/godot-playfab/commit/ff1bda72acf82eadf2f4c562d44889c7c6400e95))



### [0.0.7](https://github.com/Structed/godot-playfab/compare/0.0.6...0.0.7) (2022-07-16)


### Bug Fixes

* only run on branch main ([61d5a3a](https://github.com/Structed/godot-playfab/commit/61d5a3a008c6d0a0cb63a97485d5164e690d1986))
* run main workflow on main and develop ([956e328](https://github.com/Structed/godot-playfab/commit/956e328c9948c96cd16af661fea6828316091ceb))



### [0.0.6](https://github.com/Structed/godot-playfab/compare/0.0.5...0.0.6) (2022-07-15)


### Bug Fixes

* dry run (do not create a tag) if not on main ([dbb3a68](https://github.com/Structed/godot-playfab/commit/dbb3a6806a335d8e1b2e952bdaca3a6f6fa9c258))
* only run itch on main ([109c61f](https://github.com/Structed/godot-playfab/commit/109c61f9f1d0571d0e858f5d815fdd7789fe82f8))



### [0.0.5](https://github.com/Structed/godot-playfab/compare/v0.0.4...0.0.5) (2022-07-15)


### Bug Fixes

* **pencil:** release workflow ([1be05de](https://github.com/Structed/godot-playfab/commit/1be05deec0e2e9523d8e5d8156ebfb6a5218a1c3))
* changelog ([23b34c6](https://github.com/Structed/godot-playfab/commit/23b34c62a9feb9d275a065ee4f1f258ac20aed62))
* do not check on whether to update plugin.cfg ([e62bd1e](https://github.com/Structed/godot-playfab/commit/e62bd1ec61266b75e3d3b715a76b1f17e67def31))
* do not restrict on develop branch ([7cc878e](https://github.com/Structed/godot-playfab/commit/7cc878e739ef26ba17558e6a401a42bdeab1a5ad))
* enable itch ([c416eff](https://github.com/Structed/godot-playfab/commit/c416effbc14ac0a729184ff661e2db501258092a))
* introducing PAT ([b235453](https://github.com/Structed/godot-playfab/commit/b235453112bdf71ef2227321e892555456ecf5cd))
* quoting banch names ([764772e](https://github.com/Structed/godot-playfab/commit/764772e1fe32e52b93116ca014c27b09875358df))
* remove test-changelog ([d00ffab](https://github.com/Structed/godot-playfab/commit/d00ffab3112866d771c0dd0bc1a931f2e8ea2449))
* reset version ([f20d4d1](https://github.com/Structed/godot-playfab/commit/f20d4d10073054fc6c8abc19fcb23e8abd9ac713))
* reset version ([7cafbf2](https://github.com/Structed/godot-playfab/commit/7cafbf250e4cee4930c04566e92a430c47231c42))
* run asset lib release only on main ([f9d0f1e](https://github.com/Structed/godot-playfab/commit/f9d0f1e59bd67f029ac8f6f3946442b0565a95a5))
* test again ([c07672d](https://github.com/Structed/godot-playfab/commit/c07672df773a3144c392005f7511bf218dca5ed1))
* upload of artifact with proper version ([ad83470](https://github.com/Structed/godot-playfab/commit/ad834707812a16c322688551e6d8c8abc83fb634))
* use calculate version ([bf0d538](https://github.com/Structed/godot-playfab/commit/bf0d5388dc042da87697c7e041ab085b84c39f21))
* version for itch build ([9baade6](https://github.com/Structed/godot-playfab/commit/9baade6e20aedf8e096cce57260165dd93649b24))
* version of mathieudutour/github-tag-action ([5304ba4](https://github.com/Structed/godot-playfab/commit/5304ba46ea552c6cf30aecf3718b1984f9dd876d))
