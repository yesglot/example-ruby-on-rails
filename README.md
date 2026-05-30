# Yesglot Ruby on Rails Example

This repository is a small Ruby on Rails internalization example that shows how a Rails app can keep product copy in YAML locale files and let [Yesglot](https://yesglot.com/) manage translation updates through pull requests.

The example app is intentionally minimal. The goal is not to demonstrate every Rails feature; it is to show the translation workflow you would use in a real Rails application.

## What This Example Demonstrates

- Rails' built-in `I18n.t` / `t` helpers
- YAML locale files under `config/locales`
- a source language file: `config/locales/en.yml`
- target language files: `config/locales/es.yml` and `config/locales/tr.yml`
- pluralization with `one` and `other`
- interpolation with `%{count}`
- blank target-language values that Yesglot can translate

## What Is Yesglot?

Yesglot is an AI-first translation workflow tool for software teams.

At a high level, you connect your GitHub repository, add a `yesglot.toml` file, point it to your source and target translation files, and Yesglot opens pull requests with generated translation updates.

For Rails apps, that usually means:

- your source language lives in a file like `config/locales/en.yml`
- your target languages live in files like `config/locales/es.yml` and `config/locales/tr.yml`
- your Rails views and controllers use stable translation keys
- Yesglot watches the source locale file for changes
- when source strings change, Yesglot creates a pull request with updated target locale files

That keeps translation changes in the same GitHub review flow your team already uses for code.

## How This Example Is Wired

The important Rails files are:

```text
example-project/
  app/
    controllers/
      application_controller.rb
      home_controller.rb
    views/
      home/
        index.html.erb
  config/
    application.rb
    locales/
      en.yml
      es.yml
      tr.yml
    routes.rb
```

`example-project/config/application.rb` configures Rails i18n:

```ruby
config.i18n.available_locales = %i[en es tr]
config.i18n.default_locale = :en
config.i18n.fallbacks = true
```

`example-project/app/views/home/index.html.erb` renders translated text with Rails helpers:

```erb
<h1><%= t(".hero_title") %></h1>
<p><%= t(".hero_copy", count: @projects_count) %></p>
<p><%= t(".notifications", count: @unread_notifications) %></p>
```

`example-project/config/locales/en.yml` is the source language file:

```yaml
en:
  home:
    index:
      hero_title: "Translate your Rails app with confidence"
      hero_copy: "Manage %{count} multilingual projects from one place."
      notifications:
        one: "You have %{count} unread notification."
        other: "You have %{count} unread notifications."
```

The target files keep the same keys under their own locale code:

```yaml
es:
  home:
    index:
      hero_title: ""
      hero_copy: ""
```

Those empty values are the kind of missing translations Yesglot can fill in through a pull request.

## How To Add Yesglot To A Rails App

### 1. Use Rails Locale Files

Keep your app copy in normal Rails YAML locale files:

```text
config/
  locales/
    en.yml
    es.yml
    tr.yml
```

Use one source language as the source of truth. In this example, English is the source language.

### 2. Configure Rails I18n

In `config/application.rb`, define the languages your app supports:

```ruby
module YourApp
  class Application < Rails::Application
    config.i18n.available_locales = %i[en es tr]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
  end
end
```

You can then use translation keys from views, controllers, mailers, jobs, and helpers:

```erb
<%= t("navigation.sign_in") %>
<%= t(".hero_copy", count: @projects_count) %>
```

### 3. Create A Project In Yesglot

Create a project at [yesglot.com](https://yesglot.com/) and connect your GitHub repository.

During setup, Yesglot opens a pull request that adds a `yesglot.toml` file to the root of your repository. That file tells Yesglot which files to watch and update.

### 4. Review The `yesglot.toml` Pull Request

The pull request created by Yesglot should look similar to this:

```toml
# https://github.com/yesglot/yesglot.toml
[yesglot]
version = 1

[project]
id = "proj_your_project_id"
technology = "rails"
tracked_branch = "main"
custom_prompt = "This is a Ruby on Rails SaaS app. Keep translations concise and product-friendly."

[source_language]
tag = "en"
path = "config/locales/en.yml"

[[target_language]]
tag = "es"
path = "config/locales/es.yml"

[[target_language]]
tag = "tr"
path = "config/locales/tr.yml"
custom_prompt = "Use natural Turkish. Preserve product names."
```

If your Rails app lives in a subdirectory, Yesglot should include that subdirectory in the paths:

```toml
[source_language]
tag = "en"
path = "example-project/config/locales/en.yml"

[[target_language]]
tag = "es"
path = "example-project/config/locales/es.yml"
```

Review the generated paths and language tags, then merge the pull request when the configuration looks correct.

Keep the `project.id` generated by Yesglot. Do not copy the placeholder ID from this README into a real project, and do not change the generated project ID after setup.

### 5. Update Source Strings First

When you add or change product copy, update the source locale file:

```yaml
en:
  checkout:
    title: "Complete your order"
    submit: "Pay now"
```

Then commit and push that change to the branch Yesglot tracks.

### 6. Review The Yesglot Pull Request

When Yesglot detects changes in the source file, it translates the new or changed strings and opens a pull request that updates the target locale files.

Your workflow becomes:

1. Add or update English strings in `config/locales/en.yml`.
2. Commit and push to the tracked branch.
3. Review the Yesglot pull request.
4. Merge the PR when the translations look good.
5. Deploy as usual.

## Rails Localization Tips

- Keep translation keys stable; changing a key is usually a new translation.
- Translate YAML values, not YAML keys.
- Preserve interpolation variables exactly, such as `%{count}` or `%{user_name}`.
- Preserve Rails pluralization keys such as `one`, `other`, `zero`, `few`, and `many`.
- Quote strings that contain YAML-sensitive characters like `:`, `{`, `}`, or `%`.
- Use relative view keys like `t(".hero_title")` when the copy belongs to one template.
- Use shared keys like `navigation.sign_in` when the copy appears in many places.

## Recommended Rails Workflow

If you want the simplest setup, use this order:

1. Move user-facing copy into Rails locale files.
2. Keep one source locale file, usually `config/locales/en.yml`.
3. Add one target locale file per supported language.
4. Create a project in Yesglot and connect the repository.
5. Review and merge the Yesglot pull request that adds `yesglot.toml`.
6. Let Yesglot create translation pull requests when source strings change.
7. Review translations before merging.

This gives your Rails team a localization workflow that stays close to code: source strings in Git, translated files in pull requests, and humans still in control.

## Sources

- [Yesglot](https://yesglot.com/)
- [yesglot.toml specification](https://github.com/yesglot/yesglot.toml)
- [Yesglot React example](https://github.com/yesglot/example-react)
- [Yesglot Node.js example](https://github.com/yesglot/example-node)
