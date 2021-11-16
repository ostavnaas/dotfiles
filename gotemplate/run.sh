#!/usr/bin/env bash

gomplate -c ctx=settings.yaml -f template.tmpl -t _helpers.tpl
