# BA/PRD Skills - Product Requirements Mastery

A comprehensive skill for creating context-aware, expert-driven, and token-efficient Product Requirements Documents (PRDs).

## Quick Start

### 1. Run Repository Reconnaissance

```bash
node .claude/skills/ba-prd-skills/repo_scan.js
```

This generates `prelim_summary.md` with:
- Project type (new vs existing)
- Technology stack
- Architecture patterns
- Key observations
- Recommended next steps

### 2. Review the Findings

```bash
cat prelim_summary.md
```

Use this context to frame appropriate questions for PRD creation.

### 3. Create a New PRD

```bash
node .claude/skills/ba-prd-skills/create_prd.js "Feature Name"
```

This creates a new PRD folder with the template pre-filled.

### 4. Follow the Workflow

Refer to [skills.md](./skills.md) for the complete workflow:
1. Initial Reconnaissance
2. Identify Project Stage and Tech Context
3. Guide the User (Expert-Driven Approach)
4. Apply Best Practices and Organize Output

## Files in This Skill

### Core Documentation
- **[skills.md](./skills.md)** - Complete skill guide with expert frameworks, token efficiency guidelines, and best practices

### Helper Scripts
- **[repo_scan.js](./repo_scan.js)** - Repository reconnaissance script
- **[create_prd.js](./create_prd.js)** - PRD creation helper

### Templates
- **[templates/prd-template.md](./templates/prd-template.md)** - Token-efficient PRD template
- **[templates/research-template.md](./templates/research-template.md)** - User research template
- **[templates/technical-specs-template.md](./templates/technical-specs-template.md)** - Technical specifications template

### Examples
- **[examples/prd-example.md](./examples/prd-example.md)** - Complete example PRD
- **[examples/folder-structure.md](./examples/folder-structure.md)** - Guide to organizing PRDs

## Key Features

### 🔍 Context-Aware
Adapts to your project stage and tech stack through automated reconnaissance.

### 🎯 Expert-Driven
Uses questioning techniques from:
- **Marty Cagan** - Outcome-focused product discovery
- **Teresa Torres** - Continuous discovery habits
- **George Biddle** - Structured product management

### 🚀 Token-Efficient
Optimized format for AI readability:
- Structured lists over paragraphs
- Frontloaded key information
- Semantic markers (Must Have, Should Have, etc.)
- Target: 600-1200 tokens per PRD

### 📁 Well-Organized
Clear folder structure for managing multiple PRDs:
```
prds/
├── README.md
├── templates/
├── prd-001-feature-name/
│   ├── prd.md
│   ├── research.md
│   ├── technical-specs.md
│   └── mockups/
└── prd-002-another-feature/
```

## Workflow Overview

### Step 1: Reconnaissance
- Run `repo_scan.js`
- Review `prelim_summary.md`
- Understand project context

### Step 2: Context Identification
- Determine project stage (new/existing)
- Validate tech stack
- Identify constraints

### Step 3: User Guidance
- Ask expert-driven questions
- Extract requirements
- Validate assumptions

### Step 4: PRD Creation
- Use token-efficient format
- Organize in folder structure
- Link supporting documents

## Expert Questioning Frameworks

### Marty Cagan (Outcome-Focused)
- What problem are we solving?
- How do we know it's real?
- What does success look like?

### Teresa Torres (Continuous Discovery)
- What opportunities exist?
- What assumptions are we making?
- How can we test quickly?

### George Biddle (Structured)
- Who needs to approve?
- Is this technically feasible?
- What's the MVP scope?

## Token Efficiency Tips

### Before (Verbose - ~60 tokens)
```
The authentication system will need to support multiple authentication 
providers to give users flexibility in how they log in. We should support 
Google OAuth because many users have Google accounts...
```

### After (Optimized - ~25 tokens)
```
**Auth Providers**:
- Google OAuth (most users have accounts)
- GitHub OAuth (developer audience)
- Email/password (privacy-conscious users)
```

**Savings**: ~58% reduction

## Best Practices

1. ✅ **Start with Context** - Run reconnaissance first
2. ✅ **Focus on Outcomes** - Not outputs or features
3. ✅ **Validate Assumptions** - Test early and often
4. ✅ **Keep PRDs Living** - Update as you learn
5. ✅ **Optimize for AI** - Structure over narrative
6. ✅ **Maintain Traceability** - Link to implementation
7. ✅ **Use Templates** - Consistency reduces errors

## Common Use Cases

### New Feature Development
1. Run reconnaissance
2. Interview stakeholders
3. Create PRD using template
4. Link research and specs
5. Get approval
6. Track implementation

### Existing Feature Enhancement
1. Review current architecture
2. Understand constraints
3. Identify improvements
4. Document changes
5. Validate compatibility
6. Plan migration

### Architecture Changes
1. Document current state
2. Propose new architecture
3. Identify risks
4. Plan phased rollout
5. Track metrics
6. Iterate based on data

## Resources

- **[Main Skills Guide](./skills.md)** - Complete documentation
- **[PRD Template](./templates/prd-template.md)** - Start here for new PRDs
- **[Example PRD](./examples/prd-example.md)** - See it in action
- **[Folder Structure Guide](./examples/folder-structure.md)** - Organization tips

## Support

For questions or issues with this skill:
1. Review the [main skills guide](./skills.md)
2. Check the [examples](./examples/)
3. Reference the [templates](./templates/)

## Version

**Version**: 1.0  
**Author**: Callum Bir  
**Last Updated**: December 2024

---

**Built with ❤️ inspired by the product wisdom of Marty Cagan, Teresa Torres, and George Biddle**
