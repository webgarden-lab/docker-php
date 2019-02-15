#!/usr/bin/env bash

_generate() {
	FROM=$2

	if [[ $FROM == "" ]]; then
		FROM=$1
	fi

	echo "Copy $1"
	{
		echo "# -------------------------------------------------------------"
		echo "# @Generated $(date)"
		echo "#"
		echo "# Don't edit this file directly!"
		echo "# For edit use Docker file in root directory & run ./copy.sh"
		echo "# to regenerate"
		echo "# -------------------------------------------------------------"
		echo
		echo FROM php:$FROM
		cat ./Dockerfile
	} > $1/Dockerfile
}

_generate 7.1 7.1-fpm-jessie
_generate 7.2 7.2-fpm-jessie
_generate 7.3 7.3-fpm-jessie

_generate 7.1-fpm-stretch
_generate 7.2-fpm-stretch
_generate 7.3-fpm-stretch
