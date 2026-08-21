# Hermex Log - Projeto NPS

Implementacao local e reproduzivel do Desafio Hermex Log - Especialista em IA, Nivel 1. O projeto entrega regras de SLA, classificacao de feedback, calculo de NPS, roteamento de mensagens, artefatos importaveis para as plataformas SaaS e relatorios de validacao.

## Pacote para correcao

Este repositorio deve ser entregue junto com os links de leitura das ferramentas externas. Para avaliacao, considere os seguintes itens:

| Item | Caminho | Finalidade | Status |
|---|---|---|---|
| README principal | `README.md` | Guia de correcao, testes e acessos | feito |
| Evidencias detalhadas | `READM.md` | Tabelas de evidencias e criterios de aceite | feito |
| Artefatos SaaS | `artefatos/` | GPT, Miro/Mermaid, RACI, n8n, Looker, Notion e governanca | feito |
| Datasets | `dados/` | CSVs de NPS e handoff | feito |
| Codigo | `src/` | Regras locais e motor de validacao | feito |
| Testes | `test/` | Testes automatizados | feito |
| Relatorio Markdown | `Analise/relatorio_validacao_hermex_log.md` | Relatorio de validacao | feito |
| Relatorio Word | `Analise/relatorio_validacao_hermex_log.docx` | Relatorio final para entrega | feito |
| Capturas | `Analise/evidencias/` | Evidencias visuais quando link publico nao for possivel | preparar/apresentar |

## Execucao rapida

```bash
npm test
npm run demo
npm run data
```

Resultado esperado:

| Comando | Resultado esperado |
|---|---|
| `npm test` | 9 testes aprovados, 0 falhas |
| `npm run demo` | Consulta de prazo, detrator, promotor e NPS demonstrados |
| `npm run data` | 60 respostas NPS e 30 registros de handoff validados |

## Links de leitura para o professor

Antes de enviar, confirme que os links abaixo estao com permissao de leitura para o professor. Onde estiver `PREENCHER`, cole o link compartilhavel gerado pela propria ferramenta.

| Entrega externa | Link de leitura | Status |
|---|---|---|
| GPT customizado `Hermex Prazos` | `PREENCHER_LINK_DO_GPT_CUSTOMIZADO` | preencher |
| Board Miro | https://miro.com/app/board/uXjVHwPbfwI=/ | confirmado via MCP |
| Pasta Google Drive `handoff_vendas_posvenda` | https://drive.google.com/drive/folders/1eaeIZOCvHx-dldNU6blgvHKCG-ZX7cyC | confirmado via MCP |
| Google Sheets `handoff_vendas_posvenda` | https://docs.google.com/spreadsheets/d/15ldumkb96Aqlqd3KOvBzwO2g-xKyNkTbhYJ-Yf8DRL4/edit?usp=drivesdk | confirmado via MCP |
| Google Sheets `pesquisa_satisfacao` | https://docs.google.com/spreadsheets/d/14oy0JGbaC-7tBf0qCVs0CHmA6OP1y8CRtA2bkOzY1-I/edit?usp=drivesdk | confirmado via MCP |
| Google Forms de NPS | `PREENCHER_LINK_DO_GOOGLE_FORMS` | preencher |
| Workflow n8n `Hermex - NPS Automacao` | `https://fredjml.app.n8n.cloud/workflow/aKtnS8C5ofaxZiG1` | confirmar permissao/compartilhamento |
| Dashboard Looker Studio | `PREENCHER_LINK_DO_LOOKER_STUDIO` | preencher |
| Database/pagina Notion `Processos Hermex Log` | https://app.notion.com/p/3c2fb0968aa381da90a5c07339f5f56a?pvs=204 | confirmado via MCP |
| Pagina Notion de validacao MCP | https://app.notion.com/p/3c3fb0968aa381918fafc67a33e290a9?pvs=204 | confirmado via MCP |

## Evidencias visuais recomendadas

Se algum link nao puder ser aberto pelo professor, coloque capturas em `Analise/evidencias/` com estes nomes sugeridos:

| Arquivo sugerido | Conteudo esperado | Status |
|---|---|---|
| `01_gpt_instrucoes.png` | GPT Hermex Prazos com instrucoes/configuracao | pendente |
| `02_gpt_testes_sp_ba_am.png` | Testes SP, BA e AM no GPT customizado | pendente |
| `03_miro_fluxograma.png` | Fluxograma no Miro com pontos de automacao | pendente |
| `04_sheets_matriz_raci.png` | Aba `Matriz RACI` no Google Sheets | pendente |
| `05_forms_nps.png` | Google Forms com ID Pedido, Nota NPS e Comentario | pendente |
| `06_n8n_detrator.png` | Execucao detratora no n8n | pendente |
| `07_n8n_promotor.png` | Execucao promotora no n8n | pendente |
| `08_gmail_emails_teste.png` | E-mails recebidos/enviados em conta de teste | pendente |
| `09_looker_dashboard.png` | Dashboard com scorecards, mapa, barras e tabela | pendente |
| `10_notion_base.png` | Notion com Politica de Devolucao, Reembolso e SLA | pendente |

## Como ativar e testar os disparos reais no n8n

1. Abra o workflow `Hermex - NPS Automacao` no n8n.
2. Configure as credenciais do Google Sheets, Gemini e Gmail dentro do n8n. Nao coloque chaves, tokens ou senhas no repositorio.
3. Confirme que o Google Sheets Trigger aponta para a aba de respostas do Google Forms vinculada a `pesquisa_satisfacao`.
4. No Gemini, use prompt restritivo:

```text
Classifique o comentario em exatamente uma palavra:
Atraso, Defeito, Atendimento, Embalagem ou Outro.
Nao explique.
```

5. No caminho de nota `< 6`, envie alerta para o e-mail operacional/teste de pos-vendas.
6. No caminho de nota `>= 6`, envie agradecimento para o e-mail do cliente ou e-mail de teste.
7. Ative o workflow somente durante o teste.
8. Envie uma resposta detratora pelo Forms, por exemplo nota `4`, e confirme a execucao no n8n.
9. Envie uma resposta promotora pelo Forms, por exemplo nota `9`, e confirme a execucao no n8n.
10. Verifique o recebimento dos e-mails em Gmail ou TempEmail.
11. Salve capturas das duas execucoes e dos e-mails em `Analise/evidencias/`.
12. Desative o workflow se a apresentacao for apenas demonstrativa.

## Estrutura

- `src/`: regras de SLA, classificacao segura, NPS, enriquecimento e roteamento.
- `test/`: testes automatizados de unidade e integracao local.
- `artefatos/`: arquivos prontos para importar ou copiar nas plataformas SaaS.
- `dados/`: datasets do desafio.
- `Analise/`: relatorios finais em Markdown e Word.

## Regra oficial adotada

- SLA: 5 dias corridos, prazo exato, fretes comum e expresso.
- Detrator operacional: nota `< 6`.
- NPS analitico: convencao do dashboard, detratores `< 7` e promotores `> 8`.
- Respostas externas: exigem aprovacao humana.
- Retencao: marcar para expiracao em 2 dias; apagar ate 7 dias corridos.

## Observacoes de seguranca

Credenciais, tokens, chaves Gemini, OAuth, senhas e dados reais nao pertencem ao repositorio. A entrega deve usar links com permissao de leitura e capturas anonimizadas sempre que houver dados pessoais.

