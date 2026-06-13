# Contributing to CMG System

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch
4. Make your changes
5. Submit a pull request

## Branch Naming

```
feature/description - New features
bugfix/description  - Bug fixes
hotfix/description  - Urgent fixes
docs/description    - Documentation
refactor/description - Code refactoring
```

## Commit Messages

Follow conventional commits:
```
feat: add new feature
fix: fix bug
docs: update documentation
refactor: refactor code
test: add tests
chore: maintenance tasks
```

## Code Style

- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep methods small and focused
- Write tests for new features

## Pull Request Process

1. Update documentation
2. Add tests
3. Ensure all tests pass
4. Request review from maintainers
5. Address feedback
6. Merge when approved

## Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test.dart

# Run tests with coverage
flutter test --coverage
```

## Code Review Guidelines

When reviewing code, check:
- ✓ Follows project conventions
- ✓ No hardcoded values
- ✓ Proper error handling
- ✓ Tests included
- ✓ Documentation updated
- ✓ No breaking changes

## Architecture Guidelines

Maintain Clean Architecture principles:
- Separate concerns (UI, Business Logic, Data)
- Use repository pattern
- Implement proper error handling
- Follow MVVM pattern
- Use dependency injection (Riverpod)

## Documentation Requirements

For new features:
- Add code comments
- Update README if needed
- Update CHANGELOG
- Add doc strings to public methods
- Include usage examples

## Performance Considerations

- Minimize rebuilds with Riverpod selectors
- Use lazy loading for lists
- Implement proper caching
- Optimize Firestore queries
- Profile before optimizing

## Security Guidelines

- Never commit secrets
- Validate all user input
- Use secure password hashing
- Implement rate limiting
- Follow Firebase security best practices
- Use HTTPS for all network calls

## Release Process

1. Update version in pubspec.yaml
2. Update CHANGELOG.md
3. Create release notes
4. Tag release in Git
5. Build release APK/IPA
6. Submit to app store

## Questions?

Open an issue on GitHub or contact the maintainers.

Thank you for contributing! 🎉
