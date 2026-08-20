# Hermex Log

## Relatório Executivo de Processos, Dados e IA

**Projeto:** Carreira Especialista em IA — Nível 1  
**Organização:** Hermex Log  
**Versão:** 1.0  
**Data:** 20/08/2026  
**Status:** Material consolidado para entrega

Este documento reúne o desenho do pós-venda, as regras de negócio, a especificação do dashboard, a base de conhecimento e a governança necessária para uso responsável de automações e modelos de linguagem.

<!-- PAGEBREAK -->

# Sumário executivo

### Objetivo

Organizar o pós-venda da Hermex Log em uma operação rastreável, com indicadores claros, conhecimento estruturado e pontos de aprovação humana para decisões críticas.

### Entregas consolidadas

- Fluxo de handoff entre vendas e pós-venda
- Regras de devolução, reembolso e SLA regional
- Dashboard especificado para Looker Studio
- Base de conhecimento estruturada para Notion
- Governança de dados e conhecimento para futuras automações

### Resultado esperado

Com a separação entre dados operacionais e documentação semântica, a Hermex Log consegue medir a operação, explicar suas regras e reduzir o risco de respostas incorretas ou alucinações em chatbots.

### Guia de leitura

1. Regras e decisão de negócio
2. Fluxo do processo pós-venda
3. Instruções para Looker Studio
4. Estrutura no Notion
5. Governança de dados
6. Arquitetura de governança e checklist final

<!-- PAGEBREAK -->

# Relatório Final — Hermex Log

## 1. Contexto e objetivo

Este documento consolida o processo operacional de pós-venda da Hermex Log, incluindo regras de SLA, handoff de vendas para pós-venda, gestão de NPS, dashboard em Looker Studio, documentação no Notion e governança de dados para IA e automação.

A entrega foi organizada para funcionar como material final de apresentação e como base para implementação em Google Sheets, Looker Studio, Notion e bloco de notas.

---

## 2. Regras e decisão de negócio

### 2.1 SLA de entrega por região

- Sudeste: 2 a 5 dias
- Sul: 3 a 6 dias
- Centro-Oeste: 4 a 7 dias
- Nordeste: 6 a 12 dias
- Norte: 8 a 16 dias

### 2.2 Política de devolução

- Prazo de devolução: até 7 dias corridos após o recebimento
- Condições do produto: deve estar conforme a entrega inicial, com itens e acessórios
- Processo: solicitação do cliente, validação humana, acompanhamento do pós-vendas e instruções de envio
- Reembolso: sujeito à conferência e aprovação de responsável

### 2.3 Processo de reembolso

- A solicitação é registrada pelo pós-vendas
- A análise da elegibilidade é feita por responsável qualificado
- O status é informado ao cliente
- O reembolso é processado em até 10 dias úteis
- Exceções e recusas precisam de justificativa documentada

### 2.4 Regras do NPS

- Promotores: nota maior que 8
- Detratores: nota menor que 7
- NPS: (promotores / total) - (detratores / total)
- Formato recomendado: percentual ou índice de -100 a 100, conforme convenção da visão do dashboard

### 2.5 Criticidade do handoff

O handoff entre vendas e pós-venda é o ponto crítico do processo porque concentra:

- repetitividade
- regras claras
- transferência de informações entre equipes
- rastreabilidade
- exigência de ação humana em casos críticos

---

## 3. Fluxo do processo pós-venda

### 3.1 Visão operacional

1. O pedido é registrado e repassado para o pós-venda
2. O responsável confirma a entrega e inicia o acompanhamento
3. A equipe valida o status da entrega e o prazo
4. A pesquisa de satisfação é enviada ao cliente
5. A resposta é classificada por categoria
6. Quando houver insatisfação, o caso é escalado para revisão humana
7. O processo conclui com registro, acerto de SLA e conhecimento estruturado

### 3.2 Principais decisões do fluxo

- Se a entrega foi confirmada: seguir para pesquisa
- Se o cliente não confirmou: repetir acompanhamento
- Se a nota for baixa: encaminhar para análise e intervenção
- Se houver retorno ou devolução: aplicar política de devolução e reembolso

---

## 4. Instruções para Looker Studio

Conecte a planilha `pesquisa_satisfacao` do Google Sheets como fonte de dados.

### 4.1 Ajustes de tipos

- `estado`: tipo geográfico, subdivisão de país nível 1
- `data_pedido`: data
- `data_envio`: data
- `data_recebimento`: data
- `nota_nps`: número

### 4.2 Campos calculados

```text
Promotores: IF(nota_nps > 8, 1, 0)
Detratores: IF(nota_nps < 7, 1, 0)
NPS: (SUM(Promotores)/COUNT(nota_nps)) - (SUM(Detratores)/COUNT(nota_nps))
Dias até envio: DATE_DIFF(data_envio, data_pedido)
Dias até entrega: DATE_DIFF(data_recebimento, data_pedido)
```

Observação: o NPS deve ser formatado como porcentagem ou em pontos, conforme a convenção escolhida para o dashboard.

### 4.3 Dashboard mínimo exigido

#### (a) Scorecard

- NPS geral
- total de promotores
- total de detratores

#### (b) Mapa do Brasil

- cor por NPS médio por estado
- azul para valores altos
- vermelho para valores baixos

#### (c) Gráfico de barras

- média de dias até entrega por estado

#### (d) Tabela analítica

- estado
- quantidade de respostas
- NPS
- média de dias até envio
- média de dias até entrega

---

## 5. Estrutura no Notion

Crie um banco de dados chamado `Processos Hermex Log` com pelo menos três páginas:

1. `Política de Devolução`
2. `Processo de Reembolso`
3. `SLA de Entrega por Região`

### 5.1 Política de Devolução

Descreva em linguagem natural:

- prazo de 7 dias
- condições do produto
- processo de solicitação
- confirmação humana
- rastreabilidade da decisão

### 5.2 Processo de Reembolso

Descreva:

- etapas do processo
- prazo máximo de até 10 dias úteis
- critérios de aprovação
- status e comunicação ao cliente
- rastreabilidade e justificativa

### 5.3 SLA de Entrega por Região

- Sudeste: 2-5 dias
- Sul: 3-6 dias
- Centro-Oeste: 4-7 dias
- Nordeste: 6-12 dias
- Norte: 8-16 dias

---

## 6. Governança de dados

### 6.1 Responsáveis pela atualização de cada base

Usando a lógica da Matriz RACI:

- José: responsável pelo SLA e atualização da base de prazos
- João: responsável pelo pós-venda, devolução e reembolso
- Pedro: responsável pelo dashboard e indicadores
- Paulo: responsável pela base de conhecimento no Notion
- Liderança: aprova mudanças e regras de negócio críticas

### 6.2 Frequência de revisão

- SLA: mensal e sempre que houver mudança logística
- Pós-venda/devolução: mensal e após incidentes relevantes
- Dashboard: revisão semanal ou mensal, conforme volume de dados
- Notion: revisão mensal e após alterações de processo

### 6.3 Riscos se a base ficar desatualizada

- respostas incorretas de chatbots
- alucinação por modelos de linguagem
- promessas inconsistentes de prazo
- tomada de decisão operacional errada
- perda de confiança do cliente
- falhas em reembolso e devolução

### 6.4 Por que dados semânticos são mais eficazes que dados operacionais brutos

Dados semânticos, como textos interpretados, explicam regra, contexto, exceções e responsabilidade. Isso é mais útil para modelos de linguagem porque:

- melhora a recuperação contextual
- reduz ambiguidades e interpretações erradas
- preserva a lógica de negócio em linguagem natural
- viabiliza resposta coerente em automações e chatbots
- complementa dados operacionais, que continuam importantes para métricas e auditoria

---

## 7. Arquitetura de governança sugerida

- manter a base operacional em planilhas ou sistemas estruturados
- manter a interpretação do processo em documentação semântica
- revisar os dados com frequência
- separar regras de negócio de métricas operacionais
- exigir aprovação humana em decisões críticas

---

## 8. Evidências e conclusão

A solução combina:

- base de dados operacional
- visualização analítica
- documentação de processo
- governança de conhecimento
- regras de decisão humanamente revisadas

Esse conjunto permite que a operação Hermes Log funcione com mais previsibilidade, sustentabilidade e menor risco de erro em automações e respostas de IA.

---

## 9. Checklist final

- [x] Conectar a planilha de pesquisa de satisfação ao Looker Studio
- [x] Ajustar tipos de campo
- [x] Criar campos calculados de NPS e prazos
- [x] Montar dashboard com no mínimo 4 visualizações
- [x] Criar base no Notion com as páginas exigidas
- [x] Redigir governança de dados com responsabilidades, revisão e riscos
- [x] Documentar vantagem dos dados semânticos sobre dados brutos
- [x] Preparar material em Word para entrega
