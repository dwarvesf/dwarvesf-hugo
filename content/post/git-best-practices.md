---

title: "Gitflow and Pull Request"
draft: false
date: "2016-07-04T15:40:45+07:00"
categories: git, gitflow, pull request

coverimage: 2016-07-04-pullrequest.jpg

excerpt: "Git is one of the most popular source control. Github is one platform built over the top of Git and well adapted by lots of companies. Knowing the right workflow will help to increase the team productivity."

authorname: Tiểu Bảo
authorlink: http://tieubao.me
authortwitter: nntruonghan
authorgithub: tieubao
authorbio: Brother of all Miners
authorimage: gancho.png

---

Git is one of the most popular source control. Github is one platform built over the top of Git and well adapted by lots of companies. Knowing the right workflow will help to increase the team productivity. In this post, I will try to cover some of the best practices from the community and the way we applied them at [Dwarves Foundation](https://www.dwarvesf.com).

# Git branching model

Source: http://nvie.com/posts/a-successful-git-branching-model/

{{% img src="http://tieubao.me/writing/images/blog/2016-06-27-git-model.png" class="third right" %}}  

In sort, you will organise your repository into 5 types of branches:

### The main branches

- master: the main branch where the source code of HEAD always reflects a *production-ready* state
- develop: the main branch where the source code of HEAD always reflects a state with the latest delivered development changes for the next release. Some would call this the "integration branch".

### feature

- May branch off from: develop
- Must merge back into: develop
- Branch naming convention: anything except master, develop, release-\*, or hotfix-\*

Feature branches (or sometimes called topic branches) are used to develop new features for the upcoming or a distant future release. When starting development of a feature, the target release in which this feature will be incorporated may well be unknown at that point.

### release

- May branch off from: develop
- Must merge back into: develop and master
- Branch naming convention: release-*

Release branches are created from the develop branch. For example, say version 1.1.5 is the current production release and we have a big release coming up. The state of develop is ready for the “next release” and we have decided that this will become version 1.2 (rather than 1.1.6 or 2.0). So we branch off and give the release branch a name reflecting the new version number

### hotfix

- May branch off from: master
- Must merge back into: develop and master
- Branch naming convention: hotfix-*

Hotfix branches are very much like release branches in that they are also meant to prepare for a new production release, albeit unplanned. They arise from the necessity to act immediately upon an undesired state of a live production version. When a critical bug in a production version must be resolved immediately, a hotfix branch may be branched off from the corresponding tag on the master branch that marks the production version.

## Gitflow

Inspired by Vincent Driessen's branching model, git-flow are a set of git extensions to provide high-level repository operations for it. Git-flow is a merge based solution. It doesn't rebase feature branches.

- Checkout gitflow cheatsheet: http://danielkummer.github.io/git-flow-cheatsheet/
- Apps that support gitflow:
	+ Source Tree: https://www.sourcetreeapp.com
	+ Git Tower: https://www.git-tower.com

Note: Maybe after working for a long time with merge based Gitflow, you will find your git log a little bit confusing and look like that:

{{% img src="http://tieubao.me/writing/images/blog/2016-06-27-gitflow-mess.png" class="third right" %}}  

Please take no worries about this, because there is still a part about `git rebase`. For now, you can continue to read the article [GitFlow considered harmful](http://endoflineblog.com/gitflow-considered-harmful) to know more about the author issue.

# How to write commit message

Source: http://chris.beams.io/posts/git-commit/

{{% img src="http://tieubao.me/writing/images/blog/2016-06-27-git-commit.png" class="third right" %}}  

Have you ever read some repos with commit messages like above? 

While many repositories' logs look like the former, there are exceptions. The [Linux kernel](https://github.com/torvalds/linux/commits/master) and [git itself](https://github.com/git/git/commits/master) are great examples. Look at [Spring Boot](https://github.com/spring-projects/spring-boot/commits/master), or any repository managed by [Tim Pope](https://github.com/tpope/vim-pathogen/commits/master). The contributors to these repositories know that a well-crafted git commit message is the best way to communicate context about a change to fellow developers (and indeed to their future selves). A diff will tell you what changed, but only the commit message can properly tell you why.

Being known that, a project's long-term success rests (among other things) on its maintainability, reviewing others commits and pull requests is also the big reason that you should write great commit messages.

In the post, the author wants to address the most basic elements of keeping a healthy commit history: how to write an individual commit message. You can checkout the source article or just follow the **seven rules** below and you're on your way to committing like a pro

1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line
6. Wrap the body at 72 characters
7. Use the body to explain what and why vs. how

# Pull Request

Pull request is a feature that makes it easier for developers to collaborate. Pull request is a mechanism for a developer to notify team members that they have completed a feature.

Some tricks to make Pull Requests more awesome for your project:

- Open a Pull Request as early as possible

Pull Requests are a great way to start a conversation of a feature, so start one as soon as possible- even before you are finished with the code. Your team can comment on the feature as it evolves, instead of providing all their feedback at the very end.

- Pull Requests work branch to branch

No one has a fork of github/github. We make Pull Requests in the same repository by opening Pull Requests for branches.

- A Pull Request doesn't have to be merged

Pull Requests are easy to make and a great way to get feedback and track progress on a branch. But some ideas don't make it. It's okay to close a Pull Request without merging; we do it all the time.

Hint: Based on an article [Type of Pull Request](http://ben.balter.com/2015/12/08/types-of-pull-requests/), there are 6 types of PR. But [`WIP pattern`](http://ben.straub.cc/2015/04/02/wip-pull-request/) is the one that is using by lots of teams and companies. It follows the mantra of "**Open a Pull Request as early as possible**".

# Code Review

Source: https://github.com/thoughtbot/guides/tree/master/code-review

### Everyone 

- Accept that many programming decisions are opinions. Discuss tradeoffs, which you prefer, and reach a resolution quickly.
- Ask questions; don't make demands. ("What do you think about naming this :user_id?")
- Ask for clarification. ("I didn't understand. Can you clarify?")
- Avoid selective ownership of code. ("mine", "not mine", "yours")
- Avoid using terms that could be seen as referring to personal traits. ("dumb", "stupid"). Assume everyone is attractive, - intelligent, and well-meaning.
- Be explicit. Remember people don't always understand your intentions online.
- Be humble. ("I'm not sure - let's look it up.")
- Don't use hyperbole. ("always", "never", "endlessly", "nothing")
- Don't use sarcasm.
- Keep it real. If emoji, animated gifs, or humor aren't you, don't force them. If they are, use them with aplomb.
- Talk synchronously (e.g. chat, screensharing, in person) if there are too many "I didn't understand" or "Alternative solution:" comments. Post a follow-up comment summarizing the discussion.

### Having Your Code Reviewed

- Be grateful for the reviewer's suggestions. ("Good call. I'll make that change.")
- Don't take it personally. The review is of the code, not you.
- Explain why the code exists. ("It's like that because of these reasons. Would it be more clear if I rename this class/file/- method/variable?")
- Extract some changes and refactorings into future tickets/stories.
- Link to the code review from the ticket/story. ("Ready for review: https://github.com/organization/project/pull/1")
- Push commits based on earlier rounds of feedback as isolated commits to the branch. Do not squash until the branch is ready - to merge. Reviewers should be able to read individual updates based on their earlier feedback.
- Seek to understand the reviewer's perspective.
- Try to respond to every comment.
- Wait to merge the branch until Continuous Integration tells you the test suite is green in the - branch.
- Merge once you feel confident in the code and its impact on the project.

### Reviewing code

Understand why the change is necessary (fixes a bug, improves the user experience, refactors the existing code). Then:

- Communicate which ideas you feel strongly about and those you don't.
- Identify ways to simplify the code while still solving the problem.
- If discussions turn too philosophical or academic, move the discussion offline to a regular Friday afternoon technique - discussion. In the meantime, let the author make the final decision on alternative implementations.
- Offer alternative implementations, but assume the author already considered them. ("What do you think about using a custom - validator here?")
- Seek to understand the author's perspective.
- Sign off on the pull request with a 👍 or "Ready to merge" comment.

# Rebase vs Merge

Source: https://blog.sourcetreeapp.com/2012/08/21/merge-or-rebase/

{{% img src="http://tieubao.me/writing/images/blog/2016-06-27-merge-rebase.png" class="third right" %}}  

- Merging brings two lines of development together while preserving the ancestry of each commit history.
- In contrast, rebasing unifies the lines of development by re-writing changes from the source branch so that they appear as children of the destination branch – effectively pretending that those commits were written on top of the destination branch all along.

#### Merging Pros

- Simple to use and understand.
- Maintains the original context of the source branch.
- The commits on the source branch remain separate from other branch commits, provided you don’t perform a fast-forward merge. This separation can be useful in the case of feature branches, where you might want to take a feature and merge it into another branch later.
- Existing commits on the source branch are unchanged and remain valid; it doesn’t matter if they’ve been shared with others.

#### Merging Cons

- If the need to merge arises simply because multiple people are working on the same branch in parallel, the merges don’t serve any useful historic purpose and create clutter.

#### Rebase Pros

- Simplifies your history.
- Is the most intuitive and clutter-free way to combine commits from multiple developers in a shared branch

#### Rebase Cons

- Slightly more complex, especially under conflict conditions. Each commit is rebased in order, and a conflict will interrupt the process of rebasing multiple commits. With a conflict, you have to resolve the conflict in order to continue the rebase. SourceTree guides you through this process, but it can still become a bit more complicated.
- Rewriting of history has ramifications if you’ve previously pushed those commits elsewhere. In Mercurial, you simply cannot push commits that you later intend to rebase, because anyone pulling from the remote will get them. In Git, you may push commits you may want to rebase later (as a backup) but only if it’s to a remote branch that only you use. If anyone else checks out that branch and you later rebase it, it’s going to get very confusing.

Note: Other post from Atlassian: https://www.atlassian.com/git/tutorials/merging-vs-rebasing

# Git templates

To make things easier, we have adopted Issue template and Pull Request template that we think they are great to help the team to improve the productivity

[Issue-template](https://gist.githubusercontent.com/tieubao/2a9fc10be45a67ab315ef3f8ead6530d/raw/e99d04268bf83389f4f728f386f79d9da3132480/issue-template.md)
{{% gist tieubao 2a9fc10be45a67ab315ef3f8ead6530d %}}

<br>
[Pull Request-template](https://gist.githubusercontent.com/tieubao/98a83f179d06fe3e33e4dfe4f1395904/raw/4cd5eaa3586503c9a89b7cac34886e2769db01d1/pr-template.md)
{{% gist tieubao 98a83f179d06fe3e33e4dfe4f1395904 %}}

And finally, Atlassian has a full tutorials from scratch, you can find it at: https://www.atlassian.com/git/tutorials/what-is-version-control

Reference Links: http://tieubao.me/writing/2016/06/20/gitflow-and-pull-request/
