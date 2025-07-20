# 🧠 Git Branching & Reset Cheat Sheet

Your personal guide to mastering Git with flexibility and confidence. 💪

-
------------------------------------------------------------------------------------
Category	            Command	                        Purpose
------------------------------------------------------------------------------------
 Viewing & Status   	git status	                    See modified/staged files
 Viewing & Status	    git log --oneline --graph --all	Visual history of commits
 Staging & Committing	git add .	                    Stage all changes
 Staging & Committing	git commit -m 'your message'	 Save staged changes
 Staging & Committing	git commit --amend	            Edit last commit message/files
 Push & Pull	        git push origin main	        Push commits to remote
 Push & Pull	        git pull origin main	        Pull and merge remote to local
 Push & Pull	        git fetch --all	                Get remote changes without merging
 Branching	            git branch new-branch	        Create a new branch
 Branching	            git checkout -b new-branch	    Create and switch to a new branch
 Branching	            git branch -d branch-name	    Delete a branch
 Branching	            git push origin new-branch	    Push new branch to GitHub
 Merging & Switching	git checkout main	            Switch to another branch
 Merging & Switching	git merge new-branch	        Merge branch into current one
 Merging & Switching	git branch --merged	            See what has been merged
 Reset & Revert	        git reset --hard commit_id	    Reset to a specific commit (erase future)
 Reset & Revert	        git reset --soft commit_id	    Reset but keep changes staged
 Reset & Revert	        git revert commit_id	        Undo a specific commit (safely)
 Reset & Revert	        git reflog	                    See all checkout/reset history
 Reset & Revert     	git reset --hard HEAD@{1}	    Undo recent checkout/reset
 Reset & Revert	        git reset --merge	            Abort failed merge/conflict
 Stashing (Temp Save)	git stash	                    Temporarily save changes
 Stashing (Temp Save)	git stash list	                View stashed changes
 Stashing (Temp Save)	git stash pop	                Apply latest stash
 Conflict Resolution	git diff	                    Compare changes between branches/files
 Conflict Resolution	git mergetool	                Use tool to resolve merge conflicts
-----------------------------------------------------------------------------------------------------





## 🏗️ Branching Structure

```bash
main           # Stable production-ready code
│
├── dev        # Active development branch
│   ├── feature/login-page
│   ├── feature/ai-integration
│   └── hotfix/api-bug
└── test       # Optional branch for QA and testing
```

---

## 🌱 Branch Management

| Action                                | Command |
|---------------------------------------|---------|
| 🚀 Create new branch                  | `git checkout -b feature/my-feature` |
| 🔄 Switch to branch                   | `git checkout main` |
| 💥 Delete branch (local)             | `git branch -d feature/my-feature` |
| 🧨 Delete branch (remote)            | `git push origin --delete feature/my-feature` |
| 🆙 Push new branch to remote         | `git push -u origin feature/my-feature` |
| 🔍 List all branches                 | `git branch -a` |

---

## 🔃 Merging & Rebasing

| Action                                 | Command |
|----------------------------------------|---------|
| ⬅️ Merge branch into current branch    | `git merge feature/my-feature` |
| 🔀 Rebase feature onto latest main     | `git checkout feature/my-feature && git rebase main` |
| 🧹 Abort rebase                        | `git rebase --abort` |
| ✨ Resolve conflicts (after merge/rebase) | Edit files, then `git add .` and `git commit` |

---

## ⏮️ Moving Around Commits

| Action                                  | Command |
|-----------------------------------------|---------|
| 🧭 See log history                      | `git log --oneline --graph --all` |
| 🕰️ Reset to previous commit (soft)     | `git reset --soft HEAD~1` |
| ⛔ Reset to previous commit (hard)      | `git reset --hard HEAD~1` |
| 🔄 Revert a specific commit             | `git revert <commit_hash>` |
| 📌 Stash current changes                | `git stash` |
| 📂 Apply last stashed changes           | `git stash pop` |

---

## 📦 Pulling, Fetching & Pushing

| Action                                 | Command |
|----------------------------------------|---------|
| 🔄 Pull latest changes with merge      | `git pull` |
| 🕸️ Fetch all branches                  | `git fetch --all` |
| 🎯 Push current branch to remote       | `git push` |
| 🆕 Clone repo                          | `git clone <repo_url>` |
| 🌍 Set remote origin                   | `git remote add origin <url>` |

---

## 🛠️ Conflict Resolution

1. Edit conflicting files manually.
2. Use `git add <file>` to mark as resolved.
3. Run `git commit` or continue rebase: `git rebase --continue`.

---

## 🧪 Experimental Flow Example

```bash
# Start from dev branch
git checkout dev

# Create a new test branch
git checkout -b test/scroll-bug

# Test and commit code
git commit -am "🧪 testing scroll bug fix"

# Want to discard and go back?
git checkout dev
git branch -D test/scroll-bug

# Want to keep and merge?
git checkout dev
git merge test/scroll-bug
```

---

## 🧹 Cleanups

| Action                              | Command |
|-------------------------------------|---------|
| 🧽 Delete all local branches merged | `git branch --merged | grep -v '\*\|main' | xargs git branch -d` |
| 🧽 Clean untracked files            | `git clean -f -d` |

---

Enjoy clean workflows and fearless commits! 🚀


