#!/bin/bash

mdbook build
git check-out gh-pages
git add book
git commit -m "Automatic"
git check-out master
