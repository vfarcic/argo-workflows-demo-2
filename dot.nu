#!/usr/bin/env nu

source scripts/kubernetes.nu
source scripts/registry.nu
source  scripts/image.nu

def main [] {}

def "main run ci" [
    tag: string                    # The tag of the image (e.g., 0.0.1)
    --registry = "ghcr.io/vfarcic" # Image registry (e.g., ghcr.io/vfarcic)
    --image = "silly-demo"         # Image name (e.g., silly-demo)
    --builder = "docker"           # Image builder; currently supported are: `docker` and `kaniko`
    --skip-image-build = false     # Whether to skip the image build
] {

    if not $skip-image-build {
        (
            main build image $tag
                --registry $registry --image $image
                --builder "kaniko"
        )
    }

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
