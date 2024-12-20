#!/usr/bin/env nu

source scripts/kubernetes.nu
source scripts/registry.nu
source scripts/image.nu
source scripts/argo-workflows.nu
source scripts/argo-events.nu
source scripts/github.nu
source scripts/get-hyperscaler.nu
source scripts/ingress.nu

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

    let hyperscaler = main get hyperscaler

    main create kubernetes $hyperscaler

    let ingress_data = main apply ingress traefik --hyperscaler $hyperscaler

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

    main destroy kubernetes $env.HYPERSCALER

}

def "main build image_ci" [
    tag: string
] {

    (
        main build image $tag --image argo-workflows-demo-2-ci
            --dockerfile Dockerfile-ci
    )

}
