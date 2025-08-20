# GitHub Copilot Usage Guidelines

This document outlines best practices and guidelines for using GitHub Copilot when contributing to this repository.

## Core Principles

### 1. Review Before Committing
- **Always review** Copilot suggestions carefully before accepting them
- Verify that the generated code aligns with the project's purpose and requirements
- Test suggested code changes when applicable

### 2. Code Quality Standards
- Ensure generated code follows existing coding style and conventions in the repository
- Maintain consistency with the Japanese documentation style used in README.md
- Keep code simple, readable, and well-documented

### 3. Security and Logic Verification
- **Never accept Copilot suggestions blindly**
- Verify the logic and security implications of suggested code
- Review any external dependencies or API calls suggested by Copilot
- Ensure sensitive information (API keys, tokens) are properly handled

## Project-Specific Guidelines

### Claude Code Verification Context
This repository is specifically for testing and verifying Claude Code functionality. When using Copilot:

- Ensure any generated test scripts or verification procedures align with the existing testing framework
- Maintain the systematic approach to functionality verification outlined in the README
- Keep documentation bilingual-friendly (Japanese primary, English secondary)

### Documentation Standards
- Follow the existing markdown structure and formatting
- Use clear, descriptive headings and bullet points
- Include code examples in appropriate code blocks with language specification

### Configuration Files
- Review any YAML/JSON configuration suggestions carefully
- Ensure workflow files maintain proper GitHub Actions syntax
- Verify that any new GitHub Actions or dependencies are appropriate for the project scope

## Best Practices

### When to Use Copilot
✅ **Good use cases:**
- Generating boilerplate test scripts
- Creating documentation templates
- Suggesting configuration file structures
- Writing verification procedures

❌ **Avoid for:**
- Critical security implementations without thorough review
- Complex business logic without understanding requirements
- Modifying existing working code without clear purpose

### Review Checklist
Before accepting any Copilot suggestion:
- [ ] Does it serve the project's verification/testing purpose?
- [ ] Is the code style consistent with existing files?
- [ ] Are there any security concerns?
- [ ] Does it follow the project's documentation standards?
- [ ] Is it necessary and adds value to the repository?

## Getting Help

If you're unsure about a Copilot suggestion:
1. Compare with existing code patterns in the repository
2. Refer to the main README.md for project context
3. Consider the impact on the Claude Code verification workflow
4. When in doubt, ask for review before committing

Remember: Copilot is a tool to assist development, not replace thoughtful engineering decisions.