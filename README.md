# Billetto Engineer Test Implementation

This repository contains the completed test assignment for the Billetto Ruby on Rails Engineer role.

## 🚀 Setup Instructions

1. **Clone & Dependencies**
   ```bash
   bundle install
   yarn install
   ```

2. **Database Setup**
   ```bash
   bin/rails db:create db:migrate
   ```

3. **Environment Variables**
   Copy `.env.example` to `.env` and fill in your keys:
   ```env
   CLERK_PUBLISHABLE_KEY=pk_test_...
   CLERK_SECRET_KEY=sk_test_...
   BILLETTO_API_KEY=your_billetto_api_key
   ```

4. **Fetch Initial Data**
   Run the custom Rake task to fetch real public events from the Billetto API and ingest them into your database:
   ```bash
   bin/rails billetto:fetch_events
   ```

5. **Run the Server**
   ```bash
   bin/rails server
   ```
   Visit `http://localhost:3000` to view the application.

---

## 🏗️ Architecture & Design Choices

The application's backend architecture was explicitly designed to mirror the patterns outlined in the provided **Developer's Guide**:

### 1. CQRS & Event Sourcing (Rails Event Store)
- **Commands**: Simple self-executing commands (`Voting::Upvote` and `Voting::Downvote`) were created using a simulated `Command::Executable` module. These commands handle business validation and trigger the Domain Events.
- **Domain Events (Facts)**: `Voting::EventUpvoted` and `Voting::EventDownvoted` inherit from a strictly defined `Fact` base class. They define a strict `SCHEMA` and map directly to specific `stream_names`.
- **Event Store Injector**: The `Event` domain model includes `EventStoreInjector`, exposing `upvote!` and `downvote!` methods that elegantly publish the structured facts.
- **Async Read Models**: The `UpdateEventVoteCount` projection uses `Handler.async` and subscribes to the domain events. It intercepts the events in the background and safely increments/decrements the PostgreSQL `vote_count` within an `ActiveRecord::Base.transaction`.

### 2. API Integration
- `Billetto::FetchEventsService` connects to `https://billetto.dk/api/v3/public/events` using `Faraday`.
- It explicitly rescues `Faraday::Error` to prevent catastrophic task failures.
- It maps the `title`, `startdate`, `description`, and `image_link` to the local `Event` Active Record model to provide a lightning-fast UI without relying on live API calls during user visits.

### 3. Authentication (Clerk)
- Integrated using the `clerk-sdk-ruby` gem and the Clerk Drop-In JS UI to seamlessly bridge the gap between frontend session management and backend Rack middleware verification.
- Protected the vote creation routes using `require_authentication!`.

## 🧪 Testing

The RSpec test suite is comprehensive and tests all major layers of the architecture (10 passing tests):
- **Model Tests**: Validations (including date validation).
- **Authentication Tests**: Enforces 302 redirects for unauthenticated requests.
- **Event Store Tests**: Deep integration tests verifying that upvoting successfully dispatches a command, writes an immutable `Fact` to the stream, and correctly triggers the asynchronous Read Model tally.
- **System/Browser Tests**: Uses Capybara to simulate the UI state and authentication rendering.

Run the test suite with:
```bash
bundle exec rspec
```
