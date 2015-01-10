DEPLOYMENT_REPO=dwarvesf.github.io

all: server

build: dist

help:
    @echo "\033[0;4mAvailable targets:\033[0m"
    @echo " server - serves up site locally (default target)"
    @echo " build - build the content for deployment in ${DEPLOYMENT_REPO}"

view:
    # open front page in browser
    open http://localhost:1313

server: clean
    # Server the site up locally
    hugo server -w  --buildDrafts=true

clean:
    # clean out the local server build artifacts
    -rm -r public/*

dist: dist-clean
    # Build the project for publishing
    hugo -s . -d ${DEPLOYMENT_REPO}

dist-clean:
    # clean publishing output dir
    # NB: Avoid removing the .git folder
    -rm -r ${DEPLOYMENT_REPO}/*