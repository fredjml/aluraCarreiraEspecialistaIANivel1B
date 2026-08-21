# POC Hermex — Instalação e validação dos MCPs

**Data da validação:** 21/08/2026  
**Ambiente:** Codex no VS Code, Windows, workspace `Nivel1`  
**Escopo:** Miro, Notion, n8n e Google Drive  
**Resultado geral:** quatro integrações acessíveis e validadas por chamadas somente leitura

## 1. Objetivo e critério de prova

O objetivo desta continuação, iniciada após o recarregamento do VS Code, foi confirmar que as integrações necessárias à POC Hermex estavam instaladas, carregadas e capazes de acessar recursos reais. Foi adotada uma cadeia de evidências em quatro níveis:

1. **Persistência:** entrada existente na configuração do Codex ou plugin carregado.
2. **Descoberta:** servidor ou ferramenta aparece no inventário da sessão.
3. **Autenticação/autorização:** uma chamada somente leitura chega ao serviço sem erro.
4. **Resultado de negócio:** a chamada retorna identidade, página, workflow ou arquivo relacionado à Hermex.

Uma entrada em arquivo de configuração, isoladamente, não foi considerada prova de funcionamento. Nenhuma senha, token, cookie ou segredo foi copiado para este relatório.

## 2. Resumo executivo

| Integração | Forma de instalação observada | Teste executado | Evidência retornada | Status |
|---|---|---|---|---|
| Miro | MCP remoto em `config.toml` | identidade do usuário autenticado | IDs válidos de usuário, equipe e organização | Funcionando |
| Notion | MCP remoto em `config.toml` e conector disponível | pesquisa por `Hermex` | páginas `POC Hermex — Validação Codex, MCP, n8n e Google Drive` e `Processos Hermex Log` | Funcionando |
| n8n | MCP remoto do workspace n8n Cloud | pesquisa de workflows por `Hermex` | workflow `Hermex — NPS Automação`, visível ao MCP | Funcionando |
| Google Drive | plugin/conector Google Drive do Codex | listagem de arquivos acessíveis | pasta e planilhas `pesquisa_satisfacao` e `handoff_vendas_posvenda` | Funcionando |

## 3. Passos comuns executados

### Passo 1 — Retomada após o recarregamento

Foi reaberto o workspace `E:\ProjAlura\CarreiraEspecialistaEmIAB\Nivel1` e analisado o histórico da POC, incluindo `projNivel1EspIAB.txt`, os relatórios anteriores e os artefatos locais. A análise mostrou que a fase anterior havia solicitado o recarregamento para que a nova configuração de integrações fosse incorporada pela sessão.

**Justificativa:** servidores MCP e plugins são carregados na inicialização da sessão; validar após o recarregamento evita confundir uma configuração persistida com uma sessão antiga ainda sem as ferramentas.

### Passo 2 — Inspeção segura da configuração

Foi inspecionado `C:\Users\MPT\.codex\config.toml`. Foram encontradas estas entradas, sem cabeçalhos de autenticação ou segredos no arquivo:

```toml
[mcp_servers.notion]
url = "https://mcp.notion.com/mcp"

[mcp_servers.miro]
url = "https://mcp.miro.com/"

[mcp_servers.n8n]
url = "https://fredjml.app.n8n.cloud/mcp-server/http"
```

O Google Drive não aparece nessa seção porque, neste ambiente, foi instalado como plugin/conector do Codex. A sessão expôs ferramentas `google_drive_*` e os skills Google Drive, Docs, Sheets e Slides.

**Justificativa:** distinguir MCP remoto configurado manualmente de plugin gerenciado evita documentar um comando de instalação que não corresponde à arquitetura efetivamente usada.

### Passo 3 — Inventário pela CLI

Foi executado:

```powershell
codex mcp list
codex mcp get miro
codex mcp get notion
codex mcp get n8n
```

Os três servidores apareceram como `enabled`, com transporte `streamable_http` e as URLs esperadas. A CLI mostrou `Auth: Unknown`; por isso a comprovação não parou nessa etapa e prosseguiu para chamadas funcionais.

**Observação:** a CLI também emitiu avisos de permissão ao tentar limpar diretórios temporários antigos. Esses avisos não impediram o inventário nem as chamadas MCP da sessão.

## 4. Miro

### Instalação/configuração registrada

A entrada persistida equivale à configuração produzida pelo fluxo abaixo:

```powershell
codex mcp add miro --url https://mcp.miro.com/
```

Após a autorização OAuth na interface do serviço e o recarregamento da janela, o servidor passou a anunciar ferramentas de boards, diagramas, documentos, comentários e usuário.

**Justificativa:** o Miro é necessário para publicar o fluxograma do pós-venda e o planejamento visual da Hermex; o MCP permite trabalhar no board sem transcrever manualmente todo o conteúdo.

### Validação executada

Foi chamada a operação somente leitura `user_who_am_i`. A resposta retornou identificadores não vazios de usuário, equipe e organização, com `isError: false`. Também foi descoberto o template de recurso `miro-preview://create/{key}`.

**Evidência:** a resposta autenticada comprova conectividade, negociação MCP, autorização e acesso à conta. Os identificadores completos foram omitidos deste relatório por minimização de dados.

**Status:** **Funcionando.** O teste comprova leitura/autenticação; nenhuma alteração de board foi feita nesta auditoria.

## 5. Notion

### Instalação/configuração registrada

A entrada persistida equivale ao fluxo:

```powershell
codex mcp add notion --url https://mcp.notion.com/mcp
```

Após a autorização no Notion e o recarregamento, a sessão passou a anunciar recursos de documentação e ferramentas de pesquisa e manipulação de páginas.

**Justificativa:** o Notion é a base semântica da POC, destinada a políticas, processo de reembolso, SLA e governança. A integração reduz divergências entre os artefatos locais e a base publicada.

### Validação executada

Foram descobertos recursos oficiais do servidor, entre eles a especificação de Markdown aprimorado. Em seguida foi executada uma pesquisa de workspace por `Hermex`.

**Evidências retornadas:**

- `POC Hermex — Validação Codex, MCP, n8n e Google Drive`;
- `Processos Hermex Log`.

A chamada retornou resultados do workspace com URLs válidas e sem erro.

**Status:** **Funcionando.** A evidência demonstra acesso de leitura ao conteúdo real da POC.

## 6. n8n

### Instalação/configuração registrada

Foi configurado o endpoint MCP do workspace n8n Cloud:

```powershell
codex mcp add n8n --url https://fredjml.app.n8n.cloud/mcp-server/http
```

O endpoint foi habilitado no n8n e carregado pelo Codex após o recarregamento.

**Justificativa:** o n8n executa a automação de NPS, integra Google Sheets, classificação, decisão e aprovação humana. O MCP permite consultar e validar o workflow diretamente no workspace.

### Validação executada

Primeiro, a descoberta de recursos retornou `n8n://workflow-sdk/reference`. Depois foi feita uma pesquisa de workflows com o termo `Hermex`.

**Evidência retornada:** um workflow chamado `Hermex — NPS Automação`, com identificador válido, `availableInMCP: true`, atualizado em 21/08/2026 e `active: false`.

O estado inativo é deliberado e coerente com a segurança da POC: evita disparos ou e-mails reais antes de credenciais, destinatário de teste e aprovação humana estarem confirmados.

**Status:** **Funcionando.** A integração consulta o workspace real e encontra o workflow esperado. O teste não comprova execução de ponta a ponta nem envio de e-mail, pois isso exigiria efeitos externos fora desta auditoria somente leitura.

## 7. Google Drive

### Instalação/configuração registrada

Neste ambiente, o Google Drive foi instalado como plugin/conector gerenciado do Codex, e não como bloco manual em `[mcp_servers]`. Foram carregados o plugin `google-drive` e seus skills para Drive, Docs, Sheets e Slides. A conexão OAuth foi autorizada pela interface do conector.

**Justificativa:** o Google Drive centraliza os datasets e as planilhas que alimentam o handoff, a pesquisa de satisfação, o n8n e o Looker Studio. O plugin gerenciado oferece ferramentas específicas e evita manter tokens no repositório ou em comandos de shell.

### Validação executada

Foi verificada a presença das ferramentas `google_drive_search`, `google_drive_fetch`, `google_drive_list_folder` e operações de Docs/Sheets/Slides. Depois foi realizada uma listagem somente leitura dos itens acessíveis.

**Evidências retornadas:**

- pasta `handoff_vendas_posvenda`;
- planilha `pesquisa_satisfacao`;
- planilha `handoff_vendas_posvenda`;
- documento Google acessível na mesma conta.

Uma busca específica por `Hermex` não retornou itens porque os títulos atuais não contêm esse termo; a listagem sem filtro confirmou a conexão e os recursos do projeto.

**Status:** **Funcionando.** A resposta retornou metadados reais de arquivos e pastas com `isError: false`.

## 8. Limites e diagnóstico da CLI de login

Também foram tentados comandos `codex mcp login` para os três MCPs remotos. No shell restrito, a descoberta de metadados OAuth falhou por erro de requisição de rede. Esse resultado não invalida as integrações: as chamadas feitas pelo runtime da sessão, que é o caminho efetivamente usado pelo Codex, foram bem-sucedidas e retornaram dados autenticados.

Assim, a interpretação correta é:

- **CLI isolada:** inventário funciona; renovação interativa de OAuth não foi comprovada nesse shell;
- **runtime do Codex após recarregamento:** Miro, Notion, n8n e Google Drive funcionam em leitura;
- **escrita/efeitos externos:** não executados nesta auditoria, para preservar boards, páginas, workflows e arquivos.

## 9. Matriz de aceite

| Critério | Evidência | Status |
|---|---|---|
| Miro persistido e habilitado | `config.toml`, `codex mcp list/get` | Feito |
| Miro autenticado | `user_who_am_i`, sem erro | Feito |
| Notion persistido e habilitado | `config.toml`, `codex mcp list/get` | Feito |
| Notion acessa conteúdo Hermex | duas páginas encontradas | Feito |
| n8n persistido e habilitado | `config.toml`, `codex mcp list/get` | Feito |
| n8n acessa workflow Hermex | workflow encontrado e visível ao MCP | Feito |
| Google Drive carregado | ferramentas e skills do plugin disponíveis | Feito |
| Google Drive acessa recursos reais | pasta e duas planilhas do projeto listadas | Feito |
| Segredos protegidos | nenhum token/senha registrado | Feito |
| Evidências sem efeito externo | somente operações de leitura | Feito |

## 10. Como repetir a comprovação

1. Recarregue o VS Code/Codex após qualquer alteração em `config.toml` ou plugins.
2. Execute `codex mcp list` e confirme `miro`, `notion` e `n8n` como `enabled`.
3. Em uma conversa no mesmo workspace, peça ao Codex para identificar o usuário do Miro.
4. Peça para pesquisar `Hermex` no Notion e confirme as duas páginas.
5. Peça para pesquisar workflows `Hermex` no n8n e confirme `Hermex — NPS Automação`.
6. Peça para listar arquivos do Google Drive e confirme as planilhas `pesquisa_satisfacao` e `handoff_vendas_posvenda`.
7. Para validar escrita, use cópias ou recursos de teste e solicite confirmação explícita antes da alteração.

## 11. Conclusão

O recarregamento surtiu efeito. Os quatro serviços estão disponíveis no runtime atual e responderam a chamadas reais de leitura. Miro comprovou identidade autenticada; Notion comprovou acesso às páginas da POC; n8n comprovou acesso ao workflow Hermex; e Google Drive comprovou acesso à pasta e às planilhas do projeto. O próximo passo operacional pode prosseguir com publicação/edição controlada dos artefatos, mantendo aprovação humana antes de qualquer efeito externo.

## 12. Referências e fontes de evidência

- Configuração local: `C:\Users\MPT\.codex\config.toml`.
- Inventário local: saída de `codex mcp list` e `codex mcp get` em 21/08/2026.
- Evidências funcionais: respostas das ferramentas MCP/conector na sessão atual.
- Documentação oficial OpenAI sobre ferramentas MCP e conectores: https://developers.openai.com/api/reference/cli/resources/responses/methods/create

