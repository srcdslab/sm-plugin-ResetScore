# Copilot Instructions for ResetScore SourceMod Plugin

## Repository Overview

This repository contains **ResetScore**, a SourceMod plugin for Source engine games that allows players to reset their kill/death statistics. The plugin provides simple console commands for players to clear their score and start fresh.

**Key Features:**
- Player score reset functionality (kills and deaths)
- Admin configurable enable/disable option
- Multi-language support via translation files
- Simple console command interface (`sm_rs`, `sm_resetscore`)

## Technical Environment

- **Language**: SourcePawn (.sp files)
- **Platform**: SourceMod 1.11.0+ (specifically tested with 1.11.0-git6917)
- **Build System**: SourceKnight (Python-based SourcePawn build tool)
- **Dependencies**: 
  - SourceMod SDK
  - MultiColors plugin (for colored chat messages)
- **CI/CD**: GitHub Actions with SourceKnight action

## Project Structure

```
addons/sourcemod/
├── scripting/
│   └── ResetScore.sp              # Main plugin source code
└── translations/
    └── resetscore.phrases.txt     # Translation phrases for all languages

.github/
├── workflows/
│   └── ci.yml                     # GitHub Actions CI/CD pipeline
└── dependabot.yml                 # Dependency update automation

sourceknight.yaml                  # Build configuration and dependencies
.gitignore                         # Git ignore rules (includes build artifacts)
```

## Build & Development Workflow

### Local Development
1. **Prerequisites**: Python 3.x with SourceKnight package
2. **Build Command**: `sourceknight build` (if SourceKnight is installed)
3. **Build Output**: Compiled `.smx` files go to `addons/sourcemod/plugins/`

### Dependencies Management
Dependencies are defined in `sourceknight.yaml`:
- SourceMod SDK is automatically downloaded and configured
- MultiColors plugin is pulled from GitHub and included

### CI/CD Pipeline
- **Trigger**: Push, PR, or manual workflow dispatch
- **Process**: 
  1. Build plugin using SourceKnight action
  2. Package with translations
  3. Create releases with artifacts
  4. Auto-tag latest builds from main/master branch

## Code Style & Standards

### SourcePawn Specific Guidelines
- **Indentation**: Use tabs (4 spaces equivalent)
- **Pragmas**: Always include `#pragma newdecls required` and `#pragma tabsize 0`
- **Variables**: 
  - Global variables: Prefix with `g_` (e.g., `g_cvEnableRs`)
  - Local variables: camelCase
  - Functions: PascalCase
- **Memory Management**: Use `delete` for cleanup (no null checks needed)
- **Includes**: Standard SourceMod includes first, then third-party

### Plugin Structure Requirements
- **Plugin Info**: Always define `myinfo` structure with name, author, description, version
- **Initialization**: Implement `OnPluginStart()` for setup
- **Translations**: Load via `LoadTranslations()` in OnPluginStart()
- **Commands**: Register with proper descriptions and permissions
- **ConVars**: Use descriptive names and auto-generate config files with `AutoExecConfig()`

### Best Practices for This Plugin
- Use `GetEntProp()`/`SetEntProp()` for player statistics manipulation
- Check ConVar states before executing functionality
- Always use translation system for user-facing messages
- **Client Validation**: Validate client indices with `IsValidClient()` or similar checks
- **Player State**: Ensure player is in-game and not a bot before stat operations
- Return appropriate `Action` values from command callbacks (`Plugin_Handled`, `Plugin_Continue`)
- Handle edge cases gracefully (0 score scenarios)

## Translation System

- **File Location**: `addons/sourcemod/translations/resetscore.phrases.txt`
- **Usage**: Reference phrases with `%t` format in `CPrintToChat()`
- **Current Phrases**:
  - `RsDisabled`: Plugin disabled message
  - `NoScore`: No score to reset message  
  - `ScoreReseted`: Successful reset confirmation

## Configuration

The plugin uses SourceMod's ConVar system:
- **`sm_rs_enabled`**: Boolean to enable/disable plugin functionality (default: 1)
- Configuration file auto-generated in `cfg/sourcemod/` directory

## Testing & Validation

### Manual Testing Checklist
1. **Plugin Loading**: Verify plugin loads without errors in SourceMod
2. **Commands**: Test `sm_rs` and `sm_resetscore` commands
3. **ConVar**: Test enable/disable functionality
4. **Edge Cases**:
   - Test with players who have 0 kills/deaths
   - Test with players who have existing scores
   - Test command when plugin is disabled
5. **Translations**: Verify messages appear correctly in game

### Build Validation
- Ensure plugin compiles without warnings
- Check that all dependencies are resolved
- Verify `.smx` output is generated correctly

## Common Development Tasks

### Adding New Features
1. Check if new ConVars are needed for configuration
2. Add translation phrases for any new user messages
3. Update plugin version in `myinfo` structure
4. Test thoroughly before committing

### Modifying Commands
1. Commands are registered in `OnPluginStart()`
2. Command handlers should return `Plugin_Handled` or `Plugin_Continue`
3. Always validate client parameter and check if client is valid
4. Use translation system for all user feedback

### Updating Dependencies
1. Modify `sourceknight.yaml` to update versions
2. Test build process to ensure compatibility
3. Update CI if SourceMod version requirements change

## Performance Considerations

- **Entity Properties**: `GetEntProp()`/`SetEntProp()` calls are relatively lightweight
- **Command Frequency**: Reset score commands are infrequent, no performance concerns
- **Memory Usage**: Plugin has minimal memory footprint (single ConVar, no timers/handles)

## Version Control & Releases

- **Versioning**: Follow semantic versioning in plugin `myinfo`
- **Releases**: Automated via GitHub Actions on tag creation
- **Branching**: Develop on feature branches, merge to main/master for releases

## Troubleshooting

### Common Issues
1. **Compilation Errors**: Check SourceMod SDK version compatibility (requires 1.11.0+)
2. **Missing Dependencies**: Verify MultiColors plugin is included in build environment
3. **Runtime Errors**: Check SourceMod error logs for entity property issues
4. **Translation Issues**: Ensure phrase keys match between code and translation file
5. **Build Failures**: Verify `sourceknight.yaml` dependencies are accessible and versions are valid

### Debug Steps
1. Check SourceMod error logs (`logs/errors_*.log`)
2. Verify plugin is loaded with `sm plugins list`
3. Test ConVar values with `sm_rs_enabled` console command
4. Validate plugin compilation with `sm plugins load resetscore`
5. Use SourceMod's built-in debugging features (`sm_debug 1`)
6. For CI issues, check GitHub Actions logs for SourceKnight build output

## Security Considerations

- **Command Access**: Commands are registered as console commands (no admin flags required)
- **Input Validation**: No user input beyond command execution
- **Entity Manipulation**: Only modifies player's own statistics, no privilege escalation risks

## Additional Resources

- [SourceMod Documentation](https://wiki.alliedmods.net/Category:SourceMod_Documentation)
- [SourcePawn Language Reference](https://wiki.alliedmods.net/Category:SourcePawn)
- [SourceKnight Build Tool](https://github.com/srcdslab/sourceknight)
- [MultiColors Plugin](https://github.com/srcdslab/sm-plugin-MultiColors)