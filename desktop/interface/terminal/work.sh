o_creds() {
  export ONELOGIN_OAPI_URL=https://api.eu.onelogin.com
  export ONELOGIN_CLIENT_ID=$(eval pass mettle/onelogin/cli/id)
  export ONELOGIN_CLIENT_SECRET=$(eval pass mettle/onelogin/cli/secret)
}

gh_creds() {
  export GITHUB_TOKEN=$(eval pass mettle/github/pat)
}

gang() {
  firefox "https://gangway.oidc.$1-mettle.co.uk/login"
  sleep 5
  firefox "https://gangway.oidc.$1-mettle.co.uk/kubeconf"
  sleep 5
  mv ~/Downloads/kubeconf ~/.kube/mettle-$1
  chmod go-r ~/.kube/mettle-$1
  kenv $1
}

a() {
  password=$(eval pass mettle/onelogin/password)
  image=$(eval pass onelogin/image)

  docker run --rm -it -v ~/.aws:/home/mettle/.aws --network host \
  ${image} --profile default -u $(whoami) --onelogin-password ${password}
}

ao() {
  password=$(eval pass mettle/onelogin/password)
  image=$(eval pass onelogin/image)

  docker run --rm -it -v ~/.aws:/home/mettle/.aws --network host \
  ${image} --profile default -u $(whoami) --onelogin-password ${password} --onelogin-app-id 382920
}


bssh() {
  export ENV="${1:-sbx}"
  export KEYNAME="${2:-id_ecdsa}"

  #------------------------------------------------------------------------------
  # Boundary Auth
  #------------------------------------------------------------------------------
  export BOUNDARY_ADDR=https://boundary.platform.${ENV}-mettle.co.uk BOUNDARY_CLI_FORMAT=json
  export BOUNDARY_SCOPE_ID=$(boundary scopes list -scope-id=global | jq -r '.items[].id')
  export BOUNDARY_AUTH_METHOD_ID=$(boundary auth-methods list --filter '"onelogin" in "/item/name"' | jq -r '.items[].id')
  export BOUNDARY_TOKEN=$(boundary authenticate oidc | jq -r '.item.attributes.token')

  #------------------------------------------------------------------------------
  # List Available Targets
  #------------------------------------------------------------------------------
  select TARGETNAME in $(boundary targets list -recursive | jq -r '.items[].name' | sort); do if [ -n "$TARGETNAME" ]; then break; fi; done

  #------------------------------------------------------------------------------
  # Vault Auth - To Enable Signing of SSH Certificate
  #------------------------------------------------------------------------------
  export VAULT_SKIP_VERIFY=true
  boundary connect -exec vault -target-scope-name=platform -target-name=vault_ecs -listen-port=8200 -- login -method=oidc role=platform

  #------------------------------------------------------------------------------
  # Sign Cert & SSH onto target via Boundary
  #------------------------------------------------------------------------------
  boundary connect -exec vault -target-scope-name=platform -target-name=vault_ecs -listen-port=8200 \
           -- write -field=signed_key ssh/sign/client public_key=@$HOME/.ssh/${KEYNAME}.pub | tail -n +2 > ~/.ssh/${KEYNAME}-cert.pub
  boundary connect ssh -target-scope-name=platform -target-name="${TARGETNAME}"
}
