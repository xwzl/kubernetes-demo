#!/bin/sh
TOKENS=$(kubectl describe serviceaccount kubernetes-dashboard -n kube-system | grep "Tokens:" | awk '{ print $2}')
kubectl describe secret $TOKENS -n kube-system | grep "token:" | awk '{ print $2}'