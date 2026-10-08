# Mealie

[Mealie](https://mealie.io/) is a recipe manager and meal planner. You import a recipe from a web address, plan your meals, and build shopping lists.

This stack runs Mealie with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://mealie.<tailnet>.ts.net` |
| Service port  | `9000`                            |
| Image         | `ghcr.io/mealie-recipes/mealie`   |
| Data          | `./mealie-data`                   |

## Before you start

Set `BASE_URL` in `compose.yaml` to the address of the web interface, `https://mealie.<tailnet>.ts.net`. The sample value is `https://mealie.yourdomain.ts.net`.

## Deviations from the standard setup

- **Memory limit.** The stack limits the `application` container to 1000 MB of memory.
- **No sign-up.** `ALLOW_SIGNUP` is `"false"`, so new users need an invitation from an administrator.

## First run

Open the web interface and log in with the default account `changeme@example.com` and password `MyPassword`. Mealie then asks you to set up your own account. Change the email address and the password right away.

## Links

- [Mealie documentation](https://docs.mealie.io/)
- [Mealie source code](https://github.com/mealie-recipes/mealie)
