#!/bin/sh
set -ex

# Syseng Dev Project
export SE_PROJECT=syseng-dev-dev1

# registry service account
export SE_GCR_PROJECT=${SE_PROJECT}
export SE_GCR_SA=syseng-gcr
export SE_GCR_CREDS=~/.config/gcloud/${SE_GCR_SA}.json

gcloud iam service-accounts create ${SE_GCR_SA} --display-name "${SE_GCR_SA}"
gcloud iam service-accounts keys create ${SE_GCR_CREDS} --iam-account ${SE_GCR_SA}@${SE_GCR_PROJECT}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${SE_GCR_PROJECT} --member serviceAccount:${SE_GCR_SA}@${SE_GCR_PROJECT}.iam.gserviceaccount.com --role roles/storage.admin

# packer service account
export SE_PACKER_PROJECT=${SE_PROJECT}
export SE_PACKER_SA=syseng-packer
export SE_PACKER_CREDS=~/.config/gcloud/${SE_PACKER_SA}.json

gcloud iam service-accounts create ${SE_PACKER_SA} --display-name "${SE_PACKER_SA}"
gcloud iam service-accounts keys create ${SE_PACKER_CREDS} --iam-account ${SE_PACKER_SA}@${SE_PACKER_PROJECT}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${SE_PACKER_PROJECT} --member serviceAccount:${SE_PACKER_SA}@${SE_PACKER_PROJECT}.iam.gserviceaccount.com --role roles/compute.instanceAdmin.v1

# terraform gitops service account
export SE_TF_PROJECT=${SE_PROJECT}
export SE_TF_SA=syseng-tf
export SE_TF_CREDS=~/.config/gcloud/${SE_TF_SA}.json

gcloud iam service-accounts create ${SE_TF_SA} --display-name "${SE_TF_SA}"
gcloud iam service-accounts keys create ${SE_TF_CREDS} --iam-account ${SE_TF_SA}@${SE_TF_PROJECT}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${SE_TF_PROJECT} --member serviceAccount:${SE_TF_SA}@${SE_TF_PROJECT}.iam.gserviceaccount.com --role roles/viewer
gcloud projects add-iam-policy-binding ${SE_TF_PROJECT} --member serviceAccount:${SE_TF_SA}@${SE_TF_PROJECT}.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding ${SE_TF_PROJECT} --member serviceAccount:${SE_TF_SA}@${SE_TF_PROJECT}.iam.gserviceaccount.com --role roles/storage.admin
gcloud projects add-iam-policy-binding ${SE_TF_PROJECT} --member serviceAccount:${SE_TF_SA}@${SE_TF_PROJECT}.iam.gserviceaccount.com --role roles/iam.serviceAccountUser

# ansible service account
export SE_ANSIBLE_PROJECT=${SE_PROJECT}
export SE_ANSIBLE_SA=syseng-ansible
export SE_ANSIBLE_CREDS=~/.config/gcloud/${SE_ANSIBLE_SA}.json

gcloud iam service-accounts create ${SE_ANSIBLE_SA} --display-name "${SE_ANSIBLE_SA}"
gcloud iam service-accounts keys create ${SE_ANSIBLE_CREDS} --iam-account ${SE_ANSIBLE_SA}@${SE_ANSIBLE_PROJECT}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${SE_ANSIBLE_PROJECT} --member serviceAccount:${SE_ANSIBLE_SA}@${SE_ANSIBLE_PROJECT}.iam.gserviceaccount.com --role roles/viewer
gcloud projects add-iam-policy-binding ${SE_ANSIBLE_PROJECT} --member serviceAccount:${SE_ANSIBLE_SA}@${SE_ANSIBLE_PROJECT}.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding ${SE_ANSIBLE_PROJECT} --member serviceAccount:${SE_ANSIBLE_SA}@${SE_ANSIBLE_PROJECT}.iam.gserviceaccount.com --role roles/iam.serviceAccountUser

ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/${SE_ANSIBLE_SA}

gcloud auth activate-service-account --key-file ${SE_ANSIBLE_CREDS}
gcloud compute os-login ssh-keys add --key-file ~/.ssh/${SE_ANSIBLE_SA}.pub --ttl 0
gcloud compute os-login ssh-keys list

gcloud projects get-iam-policy ${SE_PROJECT} | egrep "binding|member|role|syseng-"
