#!/usr/bin/env nu

# Builds a container image
def "main build image" [
    tag: string                    # The tag of the image (e.g., 0.0.1)
    --registry = "ghcr.io/vfarcic" # Image registry (e.g., ghcr.io/vfarcic)
    --image = "silly-demo"         # Image name (e.g., silly-demo)
    --builder = "docker"           # Image builder; currently supported are: `docker` and `kaniko`
    --push = true                  # Whether to push the image to the registry
] {

    if $builder == "docker" {

        docker image build --tag $"($registry)/($image):latest" .

        docker image tag $"($registry)/($image):latest" $"($registry)/($image):($tag)"

        if $push {

            docker image push $"($registry)/($image):latest"

            docker image push $"($registry)/($image):($tag)"
        }

    } else if $builder == "kaniko" {

        (
            executor --dockerfile=Dockerfile --context=.
                $"--destination=($registry)/($image):($tag)"
                $"--destination=($registry)/($image):latest"
        )

    } else {

        echo $"Unsupported builder: ($builder)"

    } 

}
