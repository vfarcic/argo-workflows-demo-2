#!/usr/bin/env nu

def "main apply argoevents" [] {

    kubectl create namespace argo-events

    (
        kubectl apply
            --filename https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
    )
    
    (
        kubectl apply
            --filename https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install-validating-webhook.yaml
    )

    (
        kubectl apply --namespace argo-events
            --filename https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
    )

    (
        kubectl apply --namespace argo-events
            --filename https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/event-sources/webhook.yaml
    )

    (
        kubectl apply --namespace argo-events
            --filename https://raw.githubusercontent.com/argoproj/argo-events/master/examples/rbac/sensor-rbac.yaml
    )

    (
        kubectl apply --namespace argo-events
            --filename https://raw.githubusercontent.com/argoproj/argo-events/master/examples/rbac/workflow-rbac.yaml
    )

}
