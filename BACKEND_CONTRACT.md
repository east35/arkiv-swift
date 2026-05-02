# Backend Contract Map

Authoritative inventory of Supabase surfaces the web app consumes, which the Swift client must also consume. The backend itself is never modified from this repo — changes live in the web repo's `supabase/` directory.

Web repo: `/Users/jimjordan/Development/arkiv`

## Auth

- Email / password sign-in
- Email / password sign-up with email confirmation
- Password reset via email link
- Magic link (where enabled)
- Session refresh via `supabase-swift` default behavior

Deep-link callbacks on native: to be finalized in Phase 1 (Universal Links via Associated Domains vs custom URL scheme).

## Tables Consumed by the Client

Observed via `supabase.from(...)` calls in `src/lib/` and `src/hooks/` of the web repo:

### Library & items
- `items` — canonical tracked-item row (polymorphic across media)
- `games`
- `books`
- `films`
- `tv_series`
- `tv_seasons`
- `tv_episodes`
- `item_progress`
- `item_history`
- `item_notes`
- `item_bookmarks`

### Collections
- `collections`
- `collection_items`

### Activity & AI
- `activity_log`
- `ai_conversations`
- `ai_conversation_threads`

### User state
- `user_preferences`
- `avatars`
- `analytics_events` (deferred — not in native v1)

### Guides
- `guide_sessions`

(Exhaustive per-table column shape is out of scope for Phase 0 — mapped per feature as it's built.)

## Edge Functions

All under `supabase/functions/` in the web repo. Invoked via `supabase.functions.invoke(...)` with the user's JWT.

- `ai-chat-proxy` — AI discussion surface. Provider keys live server-side; native never holds provider keys.
- `igdb-proxy` — games metadata
- `tmdb-proxy` — films + TV metadata
- `google-books-proxy` — books metadata
- `hardcover-proxy` — books metadata (alternative)
- `hltb-proxy` — game completion times
- `steam-proxy` — Steam sync
- `metron-proxy` — comics metadata
- `guide-proxy` — game guide retrieval
- `bookmark-metadata` — URL unfurl for item bookmarks
- `send-friend-request` — social
- `delete-account` — account deletion

## Storage

- `avatars` bucket — user profile images

## RLS Posture

All tables enforce RLS. Client requests are made with the user's JWT; no service-role keys in the client.

## Out of Scope for Native v1

- Realtime subscriptions — v1 uses fetch-on-focus invalidation. Revisit after parity.
- Demo / anonymous mode — deferred indefinitely.
- Analytics — deferred.
- Push notifications / background refresh — deferred.
