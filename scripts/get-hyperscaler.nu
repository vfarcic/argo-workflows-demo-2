#!/usr/bin/env nu

# Returns a selected hyperscaler.
def "main get hyperscaler" []: [
    string -> string
] {
    let hyperscaler = [aws google]
        | input list $"(ansi green_bold)Which Hyperscaler do you want to use?(ansi yellow_bold)"
    print $"(ansi reset)"

    $"export HYPERSCALER=($hyperscaler)\n" | save --append .env

    $hyperscaler
}
