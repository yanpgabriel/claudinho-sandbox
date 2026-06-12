#!/usr/bin/env bash
set -e

echo "Entrypoint injetado."
whoami
pwd

CLAUDINHO_PATH="$HOME/.claudinho"
if [ -d "$CLAUDINHO_PATH" ]; then
	echo "Path do claudinho encontrado."
	ls -lah $CLAUDINHO_PATH
    sudo chown dev:dev -R "$CLAUDINHO_PATH"

	SKILLS_MARKER="$CLAUDINHO_PATH/.skills_installed"
	if [ ! -f "$SKILLS_MARKER" ]; then
	    echo "Instalando skills..."
	    npx --yes skills add https://github.com/vercel-labs/skills --skill find-skills -y
	    touch "$SKILLS_MARKER"
	else
	    echo "Skills já instaladas, pulando..."
	fi

    INIT_FILE="$CLAUDINHO_PATH/init_container.sh"
	if [ -f "$INIT_FILE" ]; then
		echo "Script init_container.sh encontrado."
	    bash "$INIT_FILE"
	fi
fi

exec "$@"