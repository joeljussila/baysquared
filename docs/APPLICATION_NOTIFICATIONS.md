# Application email notifications

## Status — 14 October 2026

Live. Resend verified deltaandbay.com on 14 October 2026. The sending-only API key `deltaandbay-supabase-notifications` is scoped to that domain and stored in Supabase Vault as `deltaandbay_resend_api_key`; its value is not in the repository. The migration, INSERT trigger and active minute-by-minute Cron dispatcher are installed and recorded in migration history. The public privacy disclosure is deployed.

A QA application submitted through the public form with X empty created application `f401a1c4-6350-48fa-b1c9-b23c656c980f`. The scheduler automatically sent its notification on the first attempt (HTTP 200); the outbox reconciled to `sent`. Resend email `01a13d0f-1209-7a0f-9678-d3d78cb45293` records both sent and delivered events to info@deltaandbay.com at approximately 5:56 PM Pacific, 14 October. Applicant answers were not included in the email.

Actual inbox placement still awaits the user's confirmation: the info@deltaandbay.com mailbox was not accessible through the connected personal Gmail account or the signed-in SILTA mailbox. Provider-confirmed delivery is established; do not describe an inbox readback as completed without that confirmation. The QA application is retained and clearly marked as a test; exclude it from real outreach.

## Live implementation

Migration: `supabase/migrations/20261015010000_application_notifications.sql`.

Each new application inserts a reference into a private outbox in the same database transaction. A Supabase Cron job processes that queue every minute through pg_net and the Resend email API. No notification is created for existing applications. Application submission does not depend on Resend being online.

Sender: `delta & bay <applications@deltaandbay.com>`; fixed recipient: `info@deltaandbay.com`. Email contains only the application ID and authenticated Supabase dashboard link, not applicant names, email addresses, profiles or answers. The sender domain must be verified before activation.

The sending-only, domain-scoped Resend key belongs in Supabase Vault as `deltaandbay_resend_api_key`. It must never appear in GitHub, HTML, public API responses, screenshots or SQL source. Public roles cannot read the outbox or execute its dispatcher.

Provider failures receive delayed retries, up to ten attempts. A deterministic Resend idempotency key prevents duplicate notifications during its 24-hour window; automatic retries stop after 23 hours. `sent` means Resend accepted the send, not proof of inbox placement. Final delivery is checked separately in Resend and the receiving mailbox.

## Validation already completed

Ran the migration and `supabase/tests/application_notifications.sql` together in a transaction ending with ROLLBACK on the actual Supabase PostgreSQL instance. Passed: new-row queuing with X omitted, public access restrictions, reconciliation of successful responses, delayed retry after HTTP 503, retry limit, lost response recovery, and expiration before the idempotency window closes. No network request is sent before commit; the test does not leave its application or schema changes behind. All 17 existing Node form/video tests also passed.

## Setup completion

Domain verification, user-confirmed restricted-key creation, Vault storage, migration installation/history, public privacy disclosure and the live form-to-Resend delivery test are complete. Remaining check: the user should confirm receipt of “New delta & bay application” in info@deltaandbay.com (including Spam if needed). No historical applications were backfilled and no applicants were emailed.

## Operations

Privileged operators can inspect `application_notifications.outbox` for `queued`, `sending`, `sent` and `failed` status and the last HTTP status/error. A failed or expired item needs review in Resend before any manual retry; do not blindly reset old items, because the provider's idempotency window may have expired.

To pause delivery, unschedule `deltaandbay-application-notifications` in Supabase Cron. New applications continue entering the outbox. Keep a pause shorter than the retry window or review queued items manually before resuming. To rotate the key, replace the Vault secret without changing frontend code. Deleting an application cascades to its outbox reference.

References: [Supabase pg_net](https://supabase.com/docs/guides/database/extensions/pg_net), [Vault](https://supabase.com/docs/guides/database/vault), [Cron](https://supabase.com/docs/guides/cron), [Resend idempotency](https://resend.com/docs/dashboard/emails/idempotency-keys).
