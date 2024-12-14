#!/usr/bin/env nu

source scripts/kubernetes.nu
source scripts/registry.nu
source scripts/image.nu
source scripts/argo-workflows.nu
source scripts/argo-events.nu
source scripts/github.nu

def main [] {}

def "main run unit_tests" [] {

    go test -v .

}

def "main run gitops" [
    image: string # The full image (e.g., `ghcr.io/vfarcic/silly-demo:0.0.1`)
] {

    open app/deployment.yaml
        | upsert spec.template.spec.containers.0.image $image
        | save app/deployment.yaml --force

}

def "main run linter" [] {

    print "Linting..."

}

def "main setup" [] {

    rm --force .env

    main create kubernetes kind

    let registry_data = main get registry

    let github_data = main get github

    (
        main apply argoworkflows
            $github_data.token
            $registry_data.user
            $registry_data.password
            $registry_data.email
            --registry $registry_data.server 
    )

    main apply argoevents

    kubectl create namespace a-team

}

def "main destroy" [] {

    main destroy kubernetes kind

}
