# Relationship Milestones

A thoughtful web application for documenting meaningful moments in a relationship — tracking milestones, reflecting on patterns, and gaining insights into relationship health over time.

## 🚀 Overview

**Relationship Milestones** helps individuals and couples capture the moments that define their story. From first meetings to growth breakthroughs, from conflicts resolved to transitions navigated — every milestone is recorded with emotional context, multiple perspectives, and room for reflection.

The app introduces a **chapter system** that mirrors how relationships naturally evolve, allowing users to close one chapter and begin the next while preserving the full history.

This project was built with a focus on **intentional UX**, **emotional nuance**, and **clean Rails conventions**.

---

## 🛠 Tech Stack

* **Backend:** Ruby 3.1 | Rails 7.2
* **Database:** PostgreSQL
* **Frontend:** Tailwind CSS | Hotwire (Turbo + Stimulus)
* **JavaScript:** Importmap (no Node.js required)
* **File Storage:** Active Storage
* **Quality:** Minitest | SimpleCov | Brakeman | RuboCop

---

## ✨ Key Features

* **Milestone Recording:** Log significant moments categorized as firsts, funny, conflict, growth, transition, ending, or custom.
* **Dual Perspectives:** Capture both your perspective and your partner's on any milestone.
* **Emotional Tracking:** Tag milestones with emotions (joy, tension, vulnerability, growth, etc.) and rate intensity on a 1–10 scale.
* **Chapter System:** End and start new chapters as a relationship evolves, preserving full history with parent-child chapter linking.
* **Guided Reflections:** Prompted journaling ("When did I feel most myself?", "What patterns repeat?", "What will I carry forward?") plus open-ended entries.
* **Insights Dashboard:** Relationship health metrics, milestone breakdowns by type, monthly trends, and conflict resolution tracking.
* **Conflict Resolution Notes:** Dedicated repair notes on conflict milestones to track how disagreements were worked through.
* **Photo Attachments:** Attach photos to milestones via Active Storage.

---

## 🚦 Relationship Modes

| Mode | Description |
| :--- | :--- |
| **Solo** | Private, individual reflection on a relationship. |
| **Couple** | Shared space for both partners with perspective tracking and confirmation workflows. |

---

## 💻 Getting Started

### Prerequisites

* Ruby 3.1.x
* PostgreSQL 14+

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd relationship-milestones
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   bin/rails db:create db:migrate
   bin/rails db:seed
   ```
   Seeds load demo data with 8 milestones and 2 reflections.

4. **Run the development server**
   ```bash
   bin/rails server
   ```

   Visit `http://localhost:3000` to start.

---

### 🧪 Testing & Quality

Comprehensive test coverage across unit, controller, integration, and system tests.

```bash
bin/rails test              # unit + controller + integration tests
bin/rails test:system       # browser tests (Capybara + Selenium)
```

Reports are generated in the `/coverage` directory via SimpleCov.

### Security scanning with Brakeman:

```bash
bin/brakeman
```

### Linting with RuboCop:

```bash
bundle exec rubocop
```
