# Git Style Guide

## Branching

- Choose short and descriptive names:

```
# GOOD
$ git checkout -b feature/oauth-migtration

# BAD
$git checkout -b login_fix
```

- Identifiers from corresponding tickets in an external service (eg. a GitHub issue) are also good candidates for use in branch names. For example:

```
# GitHub issue #23

$ git checkout -b fix/issue-15
```

- Use slashes to separate words
- When several people are working on the same feature, it might be convenient to have personal feature branches and a team-wide feature branch. Use the following name convention:

```
$ git checkout -b feature-a/master # team-wide branch

$ git checkout -b feature-a/joao # Joao's personal branch

$ git checkout -b feature-a/maria # Maria's personal branch
```

- Merge at will the personal branches to the team-wide branch. Eventually, the team-wide branch will be merged to `master`.
- Delete your branch from the upstream repository after it's merged, unless there is a specific reason not to. 
- _Tip_: Use the following command while being on `master`, to list merged branches:
```
$ git branch --merged | grep -v `\\*`
```

## Commits

- **Each commit should be a single logical change.** Don't make several logical changes in one commit. For example, if a patch fixes a bug and optimizes the performance of a feature, split it into two separate commits.

- _Tip_: Use `git add -p` to interactively stage specific portions of the modified files.

- **Don't split a single logical change into several commits.** For example, the implementation of a feature and the corresponding tests should be in the same commit.

- **Commit _early_ and _often_.**  Small, self-contained commits are easier to understand and revert when something goes wrong.

- **Commits should be ordered _logically_ .**  For example, if commit X depends on changes done in commit Y, then commit Y should come before commit X.

### Commit Messages

A commit message consists of three distinct parts separated by a blank line: the title, the (optional) body and the (optional) footer. The layout looks like this:
```
feat: Teach how to write commit message

A further explanation is a good practice we recommend you follow.

Resolves: #1234
```
The **title** is split into 2 parts: the **type** and the **subject**.

### Type

The type is contained within the title and can be one of the following:

- **feat:** a new feature
- **fix:** a bug fix
- **docs:** changes to documentation
- **style:** formatting, missing semi-colons, etc.; no code change
- **refactor:** refactoring production code
- **test:** adding tests, refactoring test; no production code change
- **chore:** updating build tasks, package manager configs, etc.; no production code change

### Subject

Subjects should be no greater than 50 characters, should begin with a capital letter and do not end with a period. Use the imperative mood in the subject line. Separate the subject from the body (when there is one) with a blank line.

Example:

```
# GOOD
refactor: Refactor subsystem X for readability
fix: Remove deprecated methods

# BAD
Fixed bug with Y
More fixes from broken stuff
```

### Body

As not all commits are complex enough to warrant a body, it should only be present in the message when providing context there and then will save fellow and future contributors' time. Normally you'll want to provide more context when your commit has one of these types: `feat`, `refactor` and `fix`.

Use the body to explain the what and why of a commit, not the how – the code is supposed to do that.

When writing a commit message, think about what you would need to know if you ran across the commit a year from now.

Wrap the body at 72 characters per line.

### Footer

The footer is also optional and is used for tracking/referring to issues:

Example:

```

Resolves: #123

See also: #456, #789

```

## Merging

- **Do not rewrite published history.** The repository's history is valuable in its own right and it is very important to be able to tell what actually happened. Altering published history is a common source of problems for anyone working on the project.
- However, there are cases where rewriting history is legitimate. These are when:
  - You are the only one working on the branch and it is not being reviewed.
  - You want to tidy up your branch (eg. squash commits) and/or rebase it onto the `master` in order to merge it later.

- That said, never rewrite the history of the `master` branch or any other special branches (ie. used by production or CI servers).

- Keep the history clean and simple. Just before you merge your branch:
  - Make sure it conforms to the style guide and perform any needed actions if it doesn't (squash/reorder commits, reword messages etc.)
  - Rebase it onto the branch it's going to be merged to

- This results in a branch that can be applied directly to the end of the `master` branch and results in a very simple history.

- This strategy is better suited for projects with short-running branches. Otherwise it might be better to occasionally merge the `master` branch instead of rebasing onto it.

- If your branch includes more than one commit, do not merge with a fast-forward:

```
# GOOD - ensures that a merge commit is created

$ git merge --no-ff my-branch

# BAD
  
$ git merge my-branch
```

- **NEVER** commit something like `Fix linter` or `Fix tests`. These `fixes` should be squashed to the commits that originated the change.

- **NEVER** fully squash a branch before merging it, unless the whole branch (all commits) are related to a single logical change.

- **NEVER** use git merge master on a branch. **ALWAYS** use git rebase master, then force-push, wait for the CI to clear and only then merge into master.

- **CONVENTION** is to always use Github's web interface to merge into master and **NEVER** using Git on the command -line (i.e. git checkout master; git merge --no-ff branch; git push). This avoids confusion and forgetting about some really important things such as non-fast-forward merge.

## Miscellaneous

- There are various workflows and each one has its strengths and weaknesses. Whether a workflow fits your case, depends on the team, the project and your development procedures.

That said, the most important thing is to actually choose a workflow and stick with it.

- _Be consistent_. This is related to the workflow but also expands to things like commit messages, branch names and tags. Having a consistent style throughout the repository makes it easy for all contributors to understand what is going on by looking at the log, a commit message, etc.
- _Test before you push_. Do not push half-done work.

**Use the Common Sense, Luke.** FOLLOW THIS GUIDE! This is really important, otherwise we would not make you read this before contributing to our repositories.

## Acknowledgments

This guide was inspired on other guides found in the community, some of which we'd like to give a special thanks:

[https://github.com/agis/git-style-guide#merging](https://github.com/agis/git-style-guide#merging)

[https://chris.beams.io/posts/git-commit/](https://chris.beams.io/posts/git-commit/)

[https://github.com/chrisjlee/git-style-guide](https://github.com/chrisjlee/git-style-guide)
