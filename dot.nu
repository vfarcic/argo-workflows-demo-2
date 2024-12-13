#!/usr/bin/env nu

source scripts/kubernetes.nu
source scripts/registry.nu
source scripts/image.nu
source scripts/argo-events.nu

def main [] {}

def "main run unit_tests" [] {

    go test -v $"(pwd)/..."

}

def "main run gitops" [
    image: string # The full image (e.g., `ghcr.io/vfarcic/silly-demo:0.0.1`)
] {

    open app/deployment.yaml
        | upsert spec.template.spec.containers.0.image $image
        | save app/deployment.yaml --force

}

def "main run linter" [] {

    echo "Linting..."

}

def "main setup demo" [] {

    rm --force .env

    main create kubernetes kind

    kubectl create namespace argo

    (
        kubectl --namespace argo apply 
            --filename "https://github.com/argoproj/argo-workflows/releases/download/v3.6.0/quick-start-minimal.yaml"
    )

    let registry_data = main get registry --create_secret true

    kubectl create namespace a-team

}

def "main destroy demo" [] {

    main destroy kubernetes kind

}
