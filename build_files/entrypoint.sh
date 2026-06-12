#!/usr/bin/env bash
set -e

echo "### Entrypoint injetado."

CLAUDINHO_PATH="$HOME/.claudinho"
if [ -d "$CLAUDINHO_PATH" ]; then
	echo " + Path do claudinho encontrado."
    sudo chown dev:dev -R "$CLAUDINHO_PATH"

    CLAUDE_JSON="$HOME/.claude.json"
	CLAUDINHO_JSON="$CLAUDINHO_PATH/.claude.json"
	if [ ! -f "$CLAUDINHO_JSON" ]; then
	    echo " + Criando .claude.json vazio..."
	    echo "{}" > "$CLAUDINHO_JSON"
	fi
	echo " + Criando link do .claude.json..."
	ln -sf "$CLAUDINHO_JSON" "$CLAUDE_JSON"
	
	SKILLS_MARKER="$CLAUDINHO_PATH/.skills_installed"
	if [ ! -f "$SKILLS_MARKER" ]; then
	    echo " + Instalando skills..."
	    npx --yes skills add https://github.com/vercel-labs/skills --skill find-skills -y
	    touch "$SKILLS_MARKER"
	else
	    echo " = Skills já instaladas, pulando..."
	fi

	echo " ? Caso queira executar algo ao iniciar o container crie o init_container.sh em $CLAUDINHO_PATH"
    INIT_FILE="$CLAUDINHO_PATH/init_container.sh"
	if [ -f "$INIT_FILE" ]; then
	    bash "$INIT_FILE"
	fi
fi
echo "### Entrypoint finalizado."
exec "$@"