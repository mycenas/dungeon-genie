# DungeonGenie — Architecture Overview

## What the App Does End-to-End

DungeonGenie is a Rails 7 single-player D&D app with an AI Dungeon Master. The full user flow:

1. **Sign up / sign in** (Devise, email + password)
2. **Create a character** — pick a name (with an in-page fantasy name generator), race, class, and gender. The app auto-assigns HP, armor class, equipment, languages, ability scores, and a portrait image based on that race/class/gender combination. Only 4 races × 4 classes × 2 genders have portrait images.
3. **Browse campaign options** at `/campaign_options` — 3 pre-seeded campaigns. Pick one and choose which character to play.
4. **Campaign show page** (`/campaigns/:id`) — shows campaign art, your character portrait, and a button to "Begin Campaign" (creates a new `CampaignSession`) or "Continue Campaign" (reopens the last one).
5. **Session page** (`/campaigns/:id/campaign_sessions/:id`) — a Three.js scene with an animated wizard and dungeon table renders in the background. A chat box in the foreground lets you type actions to the DM.
6. **Chat / AI turn** — submitting a message POSTs to `MessagesController#create`, which:
   - Saves your message to the DB
   - Broadcasts the rendered HTML to the ActionCable channel (so the UI updates live)
   - Calls `ChatService` (GPT-4, streaming) with a DM system prompt built from your character sheet and campaign description
   - Saves the AI response as a Message with `user_id = 5` (hardcoded "Dungeon Genie" bot user)
   - Broadcasts the AI message HTML to the channel
7. Both messages appear in the chat box via ActionCable without a page reload.

---

## Main Models

### Reference / Seed Data (read-only after seeding)

| Model | What it is |
|---|---|
| `Race` | One of 4 playable races (Wood Elf, Dragonborn, Hill Dwarf, Tiefling). Stores description, ability bonuses, traits, languages. |
| `CharacterClass` | One of 4 classes (Druid, Cleric, Warlock, Fighter). Stores description, hit die, primary/spellcasting abilities. |
| `Stats` | The 6 D&D ability score names (Strength, Dexterity, etc.). Used as a reference table; the `value` column on this table is irrelevant — per-character values live on `CharacterStats`. |
| `CampaignOption` | A pre-written campaign scenario. Has name, location, description, and an image filename used as the `image_url`. |

### User-Created Data

| Model | What it is |
|---|---|
| `User` | Devise auth. Owns many campaigns and characters. |
| `Character` | A player character. Belongs to User, Race, CharacterClass. Has HP, armor class, equipment (Array), languages (Array), gender, level, and a portrait filename in `image_path`. Stats live in the `CharacterStats` join table. |
| `CharacterStats` | Join table between `Character` and `Stats` with a `value` integer. This is where actual per-character ability scores (e.g. Strength 16) are stored. |
| `Campaign` | Links a `User` to a `CampaignOption` and a `Character`. One row per "I'm playing this campaign as this character." |
| `CampaignSession` | One play session within a campaign. Has many Messages. |
| `Message` | A single chat message. Has `content`, `role` (unused — see tech debt), belongs to `User` (optional) and `CampaignSession`. AI messages are stored with `user_id = 5`. |

### Dead / Unused Models

| Model | Status |
|---|---|
| `Chat` | An earlier attempt at AI chat using GPT-3.5-turbo. Has its own `history` (JSON) and `q_and_a` (array) columns. No routes exist for `ChatsController`. Fully replaced by `ChatService` + `Message`. |
| `Spell` / `character_spells` | Schema and models exist, join table exists, but no spells are seeded, none are assigned to characters, and they never appear in the UI. |
| `UserCampaignSession` | A join table for a potential multiplayer feature. The `has_many :user_campaign_sessions` on `CampaignSession` is commented out. Nothing creates a `UserCampaignSession` record. |

---

## How the Three.js Part Works

**Entry point:** `app/javascript/controllers/wizard_controller.js` — a Stimulus controller.

When the `<div data-controller="wizard" id="wizard-container">` in `shared/_wizard.html.erb` mounts, the controller's `connect()` fires and:

1. Creates a `WebGLRenderer` and appends its canvas to `#wizard-container`.
2. Sets a background using `background-image.png` as a Three.js texture.
3. Creates a `PerspectiveCamera` with a narrow 10° FOV, positioned far back (z=90) to frame the scene.
4. Adds two directional lights: warm orange from above-front, and a blue fill from the left.
5. Loads `waving.glb` (the wizard figure) via `GLTFLoader`. The wizard's waving animation plays once via `AnimationMixer`, then clamps on the last frame.
6. Loads `table.glb` (a dungeon master's table) and positions it in front of the wizard.
7. Runs a render loop via `renderer.setAnimationLoop(animate)`.
8. Attaches a window resize listener that updates camera aspect ratio and renderer size.

On `disconnect()`, it cancels animation frames, disposes all mesh geometries and materials, removes the resize listener, and calls `renderer.dispose()`.

**The GLB files** are in `app/assets/builds/` (fingerprinted copies) and `app/javascript/` (source). The webpack build copies them via content-hash filenames, and the controller resolves them with `new URL("./../waving.glb", import.meta.url)` so webpack can trace and bundle the asset URLs.

---

## How the Chat / ActionCable Part Works

### Server side

**`CampaignSessionChannel`** (`app/channels/campaign_session_channel.rb`):
- `subscribed` finds the `CampaignSession` by `params[:id]` and calls `stream_for campaign_session`, which creates a namespaced Redis pub/sub channel.

**`MessagesController#create`**:
1. Finds the session and campaign, creates and saves the user's `Message`.
2. Calls `CampaignSessionChannel.broadcast_to(@campaign_session, rendered_html)` with the `messages/_message` partial.
3. Assembles message history from the DB as an array of `{role:, content:}` hashes.
4. Instantiates `ChatService` with the message, history, campaign description, and a character hash built from the live DB records.
5. `ChatService#call` hits GPT-4 with a system prompt that introduces the character and the DM rules, then streams the response. The full streamed text is returned synchronously once complete.
6. Creates and saves an AI `Message` (`user_id = 5`), then broadcasts it.

**`ChatService`** (`app/services/chat_service.rb`):
- For the first message (empty history), builds DM system prompts: one that establishes the DM role, campaign description, character backstory, and the instruction to request dice rolls.
- For subsequent messages, passes the accumulated history directly plus the new user message.
- Uses `ruby-openai`'s streaming API (a `proc` that concatenates chunks), but waits for the full response before returning.

### Client side

**`campaign_session_subscription_controller.js`** (Stimulus):
- On `connect()`, calls `createConsumer().subscriptions.create({ channel: 'CampaignSessionChannel', id: ... })`.
- `received(data)` inserts the pre-rendered HTML at the bottom of `#messages` and scrolls down.
- `resetForm(event)` clears the input field on `turbo:submit-end`.
- On `disconnect()`, unsubscribes from the channel.

The form uses `simple_form_for` with Turbo. On submission Turbo sends a POST, the controller responds with `head :ok`, and Turbo fires `turbo:submit-end` to clear the form. The actual message display comes through ActionCable, not Turbo Streams.

**Redis** is required in both development and production for ActionCable to work. Without a running Redis server the subscription silently fails.

---

## Broken, Half-Finished, and Tech Debt

### Bugs / Things That Will Crash

**1. Hardcoded AI user_id = 5**
`MessagesController` saves AI messages with `user_id = 5`, assuming the "dungeongenie@dungeongenie.com" seed user was created fifth. If the DB is reseeded in a different order or on a fresh DB, this ID won't match the right user — or won't exist at all.

**2. `_message.html.erb` will crash if AI user is missing**
The partial does `message.user.email.split(/@/)[0].capitalize` with no nil guard. `Message` has `belongs_to :user, optional: true`, so if user_id 5 doesn't exist, this raises `NoMethodError: undefined method 'email' for nil`.

**3. AI message history uses wrong role for AI turns**
In `MessagesController`, the history rebuild is:
```ruby
role: msg.user == current_user ? "user" : "system"
```
OpenAI expects `"assistant"` for prior AI responses, not `"system"`. This means after the first exchange, the DM's previous lines are sent as system messages, which confuses the model's understanding of the conversation flow.

**4. Malformed HTML in `campaign_sessions/show.html.erb`**
The `data-campaign-description` attribute on line 46 opens a double-quoted string that is never closed before `data-character-name` begins. The attributes `data-character-name` through `data-character-languages` end up inside the value of `data-campaign-description` as raw text rather than as separate HTML attributes. (These data attributes are never read by the Stimulus controller anyway, but the HTML is invalid.)

**5. `home.html.erb` has its own `<!DOCTYPE html>`**
The home page view includes a full HTML document structure (`<!DOCTYPE html>`, `<html>`, `<head>`, `<body>`), but it's rendered inside `layouts/application.html.erb` which also has the full structure. This produces double-nested HTML.

### Incomplete Features

**6. `Spell` system is a stub**
The `spells` table, `character_spells` join table, `Spell` model, and `has_and_belongs_to_many :spells` on `Character` all exist. No spells are seeded, none are assigned at character creation, and there is no UI for them.

**7. `UserCampaignSession` / multiplayer is commented out**
`CampaignSession` has `has_many :user_campaign_sessions` and `has_many :users, through: :user_campaign_sessions` commented out. There was a plan to support multiple players per session. The join table exists but nothing ever writes to it.

**8. `veil_of_the_verdant_moon.png` is an orphan**
This campaign image is in `app/assets/images/` but no `CampaignOption` seed references it — a fourth campaign that was cut.

**9. `Message#role` column is never set**
Migration `20230829092616` added a `role` column to `messages`, presumably to properly track user vs. AI messages. Nothing in the current code sets it on save. History reconstruction currently uses the user_id comparison workaround.

**10. `CampaignSessionsController` is unauthenticated**
`CampaignsController` and `CharactersController` both have `before_action :authenticate_user!`. `CampaignSessionsController` does not, so any unauthenticated request can create or view sessions.

**11. ActionCable connection has no auth**
`ApplicationCable::Connection` is empty — no `current_user` is identified. Any client that knows a campaign session's ID can subscribe to its channel.

### Three.js / JS Tech Debt

**12. Module-scope Three.js globals**
`renderer`, `scene`, `textureLoader`, and `gltflLoader` are initialized at the top of `wizard_controller.js` before the `import` statements. In ESM this is technically invalid (imports are hoisted by webpack so it works in practice). More importantly, these are shared across all instances of the controller — Turbo navigation that re-mounts the controller would reuse the same renderer, potentially causing WebGL context issues or double-rendering.

**13. Double animation loop**
`wizard_controller.js` calls `renderer.setAnimationLoop(animate)` (line 89), and inside `animate()` also calls `requestAnimationFrame(animate)` (line 87). This schedules two separate loops, so `animate` runs twice per frame — two renders, two mixer updates.

### Dead Code

**14. `Chat` model and `ChatsController` are unreachable**
The `chats` table, `Chat` model, and full `ChatsController` scaffold exist but there are no routes for them in `routes.rb`. The `Chat` model holds an older GPT-3.5-turbo approach (with a `message=` virtual attribute that calls the API on assignment). All of this is superseded by `ChatService` + `Message`.

**15. `Stats#value` column is misleading**
The `stats` table has a `value` column set to 10. These records are reference/lookup rows (just the names Strength, Dexterity, etc.) — the actual per-character values are on `character_stats.value`. The column on `stats` serves no purpose.

**16. `dump.rdb` is checked in**
A Redis database dump file (`dump.rdb`) is committed to the repo root. This is runtime state, not source code, and may contain seed user passwords or session data.

**17. README references a deleted `src/index.html` Parcel setup**
The README says to run `parcel ./src/index.html` for the Three.js file server. That directory and file don't exist. The actual build is `yarn build` which runs webpack.

### Performance Note

**18. GPT-4 streaming blocks the HTTP request**
`ChatService` uses OpenAI's streaming API but collects all chunks before returning. The HTTP request to `MessagesController#create` hangs open for the full GPT-4 generation time (often 5–15 seconds) with no timeout set. There's no background job, no loading indicator in the UI, and no error handling if the API call fails mid-stream.
