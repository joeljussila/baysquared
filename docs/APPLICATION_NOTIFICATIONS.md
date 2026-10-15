# Application email notifications

## Status — 14 October 2026

Resend has verified deltaandbay.com. The private notification queue, trigger and Cron dispatcher are installed in Supabase and migration history records version 20261015010000. A sending-only key scoped to deltaandbay.com was created after user confirmation. Secure Vault storage and the live application/inbox delivery test are in progress; do not call the end-to-end setup complete until those are recorded below.

## Prepared implementation

Migration: `supabase/migrations/20261015010000_application_notifications.sql`.

Each new application inserts a reference into a private outbox in the same database transaction. A Supabase Cron job processes that queue every minute through pg_net and the Resend email API. No notification is created for existing applications. Application submission does not depend on Resend being online.

Sender: `delta & bay <applications@deltaandbay.com>`; fixed recipient: `info@deltaandbay.com`. Email contains only the application ID and authenticated Supabase dashboard link, not applicant names, email addresses, profiles or answers. The sender domain must be verified before activation.

The sending-only, domain-scoped Resend key belongs in Supabase Vault as `deltaandbay_resend_api_key`. It must never appear in GitHub, HTML, public API responses, screenshots or SQL source. Public roles cannot read the outbox or execute its dispatcher.

Provider failures receive delayed retries, up to ten attempts. A deterministic Resend idempotency key prevents duplicate notifications during its 24-hour window; automatic retries stop after 23 hours. `sent` means Resend accepted the send, not proof of inbox placement. Final delivery is checked separately in Resend and the receiving mailbox.

## Validation already completed

Ran the migration and `supabase/tests/application_notifications.sql` together in a transaction ending with ROLLBACK on the actual Supabase PostgreSQL instance. Passed: new-row queuing with X omitted, public access restrictions, reconciliation of successful responses, delayed retry after HTTP 503, retry limit, lost response recovery, and expiration before the idempotency window closes. No network request is sent before commit; the test does not leave its application or schema changes behind. All 17 existing Node form/video tests also passed.

## Activation still required

1. Sign in to Resend and verify deltaandbay.com against its displayed DNS requirements.
2. Create a sending-only API key scoped to deltaandbay.com and securely save it in Supabase Vault. Browser policy requires action-time confirmation for creating persistent credentials.
3. Apply the prepared migration, record its version/name/statements in Supabase migration history, and verify the trigger, Cron job and permission restrictions.
4. Update the public privacy notice to disclose Resend's internal notification processing before activation.
5. Submit one clearly labelled QA application through the public form with X empty. Confirm the row, outbox state, Resend delivery event and receipt in info@deltaandbay.com. Do not email existing applicants or backfill historical notifications.
6. Record the QA application's ID, test results and final live status here and in `docs/CHAT_HANDOFF.md`. Keep real applicant information and keys out of GitHub.

## Operations

Privileged operators can inspect `application_notifications.outbox` for `queued`, `sending`, `sent` and `failed` status and the last HTTP status/error. A failed or expired item needs review in Resend before any manual retry; do not blindly reset old items, because the provider's idempotency window may have expired.

To pause delivery, unschedule `deltaandbay-application-notifications` in Supabase Cron. New applications continue entering the outbox. Keep a pause shorter than the retry window or review queued items manually before resuming. To rotate the key, replace the Vault secret without changing frontend code. Deleting an application cascades to its outbox reference.

References: [Supabase pg_net](https://supabase.com/docs/guides/database/extensions/pg_net), [Vault](https://supabase.com/docs/guides/database/vault), [Cron](https://supabase.com/docs/guides/cron), [Resend idempotency](https://resend.com/docs/dashboard/emails/idempotency-keys).
