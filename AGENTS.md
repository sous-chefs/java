# AGENTS.md

## Purpose

This file records maintainer and agent decisions for the Java cookbook. Keep it focused on durable
patterns, support boundaries, and non-obvious implementation choices. Do not use it as a task
changelog.

## Modernization Scope

This cookbook is being modernized incrementally. Preserve the existing custom-resource API where it
is still useful, and avoid broad rewrites unless the requested work explicitly calls for a full
migration.

Prefer resource properties and helper-derived defaults over cookbook node attributes. Do not add
`attributes/` back to provide defaults for resources.

## Resource Defaults

Cookbook-owned defaults should live on resources as static defaults, `lazy` helper calls, or helper
methods in `libraries/`. This keeps defaults visible at the resource boundary and testable through
ChefSpec.

Do not write cookbook state into `node.default`, `node.normal`, `node.override`, or
`node.automatic`. In particular, do not reintroduce `node['java']` as an API surface for
`java_home`, `jdk_version`, `download_path`, install type, JCE values, or similar resource inputs.

Do not create custom Ohai plugins for cookbook defaults. Ohai automatic attributes should describe
discovered machine facts, not cookbook policy or resource configuration.

## Platform Support

Keep `metadata.rb`, Kitchen files, and GitHub Actions matrices aligned. Platform entries should be
current, non-EOL, and backed by either vendor support or explicit cookbook helper behavior.

OpenJDK package installs use the platform package manager where helper logic supports the requested
Java version. Source installs remain the fallback when a requested version is not available through
the package path.

## Dependency Management

Use `Policyfile.rb` for dependency resolution. Keep it local-only unless a real external cookbook
dependency is introduced. Do not add `default_source :supermarket` when every cookbook in the policy
is supplied by a path.

Avoid external cookbook dependencies for simple file edits in custom resources. Prefer native Chef
resources so unit tests and Kitchen do not need to contact Supermarket during Policyfile setup.

Do not reintroduce Berkshelf files or ChefSpec Berkshelf loading unless there is an explicit
compatibility reason.

## Resource Notes

`java_alternatives` accepts `bin_cmds` as an Array. Its public actions are `:set` and `:unset`.
Keep both actions covered by ChefSpec when changing alternatives behavior.

Linux install resources that include the shared Linux partial (`openjdk_pkg_install`,
`openjdk_source_install`, `openjdk_install`, `corretto_install`, and `temurin_package_install`)
default `reset_alternatives` to `true` through that partial.

`java_certificate` should provide sensible resource defaults without reading `node['java']`.
Current defaults are Java 17 and a platform-specific OpenJDK package `java_home` derived from helper
logic.

`java_jce` documents legacy Oracle JCE policy file installation only. It should not be described as
a general Java vendor installation path. JCE URL, checksum, and Java home are explicit resource
inputs; staging defaults to Chef's file cache path.

`temurin_package_install` does not have an `air_gap` property. It supports `repository_uri` for
alternate or mirrored package repositories. The resource must not make live Adoptium API calls while
evaluating defaults.

Amazon Corretto installs are source archive based and support the architecture-specific Corretto
archive naming handled by helper code (`x64` and `aarch64`). Kitchen and CI cover Corretto 11 and 17
only; do not add Corretto suites for other majors unless `libraries/corretto_helpers.rb`, docs, and
tests are updated with explicit archive metadata.

`openjdk_source_install` documentation examples should call `openjdk_source_install`, not the
dispatcher resource `openjdk_install`.
