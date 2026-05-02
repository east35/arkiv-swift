import Foundation

/// Namespace for all arkiv design tokens.
///
/// Call sites look like:
/// ```
/// Tokens.Color.surfacePrimary
/// Tokens.Spacing.px16
/// Tokens.Typography.heading1
/// Tokens.Size.interactionMinHeight
/// ```
///
/// Source of truth for values: `/Users/jimjordan/Development/arkiv/.claude/skills/arkiv-skill/SKILL.md`
/// and `src/globals.css` in the web repo. Keep this module in sync with the web tokens —
/// brand is "arkiv" (lowercase); design language is single source of truth across platforms.
public enum Tokens {}
