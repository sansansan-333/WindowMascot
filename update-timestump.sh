#!/bin/sh  
# https://developers.wonderpla.net/entry/2014/09/12/123426
# put this in project file
# and run when you want to make sure your changes on files will be reflected

find . -type d -print0 | xargs -0 touch