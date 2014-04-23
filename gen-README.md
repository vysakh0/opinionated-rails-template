Application instructions
========================

## THE DEV environment

- Follow [this](https://gist.github.com/vysakh0/f0d21023bfe47d69bf06) and get your dev enviornment sleek and runnnig that it does not waste time

## Trello board
- Update your daily activity at the end of your day.

## Don't fucking get stuck
- If there is any issue or question or doubts, raise an issue in github ASAP. Don't spend hours in the same code.
- If there is an issue, immediately Google, look stackoverflow, blogs, spend just 30 minutes. You could raise an issue in github and git stash your current code and move on to some other work.

## Workflow  - Follow strictly!
- See [my blogpost](vysakh0.github.io/development-flow-with-git-flow-github/)
### Version control - Git

- [Write good commit messages with proper one line or possible description about commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- NOTE: *Do NOT use git push -f*
- Always rebase when pulling, set auto rebasing. This will do `git pull --rebase` when you do `git pull`
``` bash
git config --global branch.autosetuprebase always
```
- Check this when you issue pull request http://codeinthehole.com/writing/pull-requests-and-other-good-practices-for-teams-using-github/

#### Create features

- Use [git flow](https://github.com/nvie/gitflow)
- Create a feature branch lets say ("admin-dashboard"), once the some big feature or fix is done in the branch, issue a pull request for someone to review and suggest changes, **do not merge into develop or master branch directly**

Eg: Install git flow.

``` bash
git flow init
#enter enter all
git flow feature start payments
# after few commits
git flow feature publish payments
# issue pull request in the github page whenever there is a big change. Don't wait for entire feature completion.
# Also, squash commits before pull request, check git rebase -i (Try to do git rebase -i develop)
# do changes when suggested and commit, then comment in the issue page

# before merging the branch into develop branch, rebase with develop for a cleaner history.
git rebase develop
# when finishing the feature branch that would be merged into develop branch,
# issue pull request instead of merging the develop branch, until then start working on the next feature, bug fixes etc.
git flow feature start performer-dashboard
```

## Development - Ruby

### Code should be readable

-  Do not use variables like **a**, **b** use meaningful varible names like, **performer** instead of *perf*.
-  Methods
   - The method should have a clear name like **mangage_performer** instead of **manage**.
   - The method should do only **one** thing. For eg, an **index** action should perform only one listing of one role.
   - The method should have minimum lines possible, under 10 lines.
- Try to minimize the usage of "if, else blocks"

### For more on the style guides, check [this repo from thoughtbot](https://github.com/thoughtbot/guides)

## Development - Javascript
Style guide - https://github.com/airbnb/javascript

## Rake tasks - Update when a new rake task is created by you

- task name (importance, when to be run)

## To use this repo

### RAILS PART

``` bash
git clone git@github.com:username/reponame.git
cd reponame
bundle install
rake db:migrate
rails s
```

### Server Deploy

Get some basic [idea about sshing from this gist](https://gist.github.com/vysakh0/9408c047a37981fa4c6f)
```bash
bundle exec cap staging deploy
```

### Things that are setup in server

[These are the things that are/will be installed in our Ubuntu server](https://gist.github.com/vysakh0/7788490)
