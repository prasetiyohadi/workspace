# AWX

[AWX](https://github.com/ansible/awx) provides a web-based user interface, REST API, and task engine built on top of [Ansible](https://github.com/ansible/ansible).
It is one of the upstream projects for [Red Hat Ansible Automation Platform](https://www.ansible.com/products/automation-platform).

An Ansible [AWX operator](https://github.com/ansible/awx-operator) for Kubernetes built with Operator SDK and Ansible.

## Getting Started

**Install AWX in local kubernetes**
 
```
kustomize overlays/local | kubectl apply -f -
```

**Get the AWX admin password**

```
kubectl get secrets -n awx awx-local-admin-password -o jsonpath='{.data.password}' | base64 -d
```
