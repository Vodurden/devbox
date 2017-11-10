# REA-specific configuration
export REA_LDAP_USER={{ user.name }}
export AWS_DEFAULT_REGION=ap-southeast-2
export PATH="$HOME/.rea-slip-utils/bin:$PATH"

export CP_DOMAIN_ENV=production

# rea-slip-docker-login is too long!
alias docker-login="rea-slip-docker-login"

# Enable aws-shortcuts
if [ -e $HOME/.aws-shortcuts/iam-roles.txt ]; then
    source $HOME/.aws-shortcuts/aws-shortcuts.sh
else
    echo "Cannot source `aws-shortcuts`: iam-roles.txt is missing."
    echo "To fix run:"
    echo ""
    echo "    rea-as saml > ~/.aws-shortcuts/iam-roles.txt"
    echo ""
fi

# Alias aws-console-url
function aws-console {
    if [ -z ${AWS_ROLE} ]; then
        echo "No AWS_ROLE found. Are you authenticated?"
        return
    fi

    USER_DATA_DIR=/tmp/chrome-profile-$AWS_ROLE
    mkdir -p "${USER_DATA_DIR}"
    open -a "Google Chrome" --new --args --profile-directory="${USER_DATA_DIR}" --incognito $(aws-console-url)
}
