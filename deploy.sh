#!/bin/bash

mdbook build
git checkout gh-pages
git add book
git commit -m "Automatic"
git checkout master
