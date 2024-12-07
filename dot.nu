#!/usr/bin/env nu

source scripts/kubernetes.nu
source scripts/registry.nu
source scripts/image.nu
source scripts/argo-events.nu

def main [] {}

def "main run unit_tests" [] {

    echo "Running unit tests"

}

def "main run gitops" [] {

    echo "Modifying the GitOps repository..."

}

def "main run linter" [] {

    echo "Linting..."

}

def "main create demo" [] {

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
