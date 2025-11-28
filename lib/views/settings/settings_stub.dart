/// Stub implementation for non-web platforms
/// Clears web localStorage (no-op on native platforms)
void clearWebStorage() {
  // No-op: localStorage doesn't exist on native platforms
}

/// Reloads the page (no-op on native platforms)
void reloadPage() {
  // No-op: Page reload concept doesn't apply to native apps
}
