# Registro de testes — Assistente Hermex Prazos

**Data:** 20/08/2026  
**Ambiente:** implementação local reproduzível  
**Fonte da regra:** `artefatos/01_planejamento_assistente_gpt.md`  
**Comando executado:** `node --input-type=module -e "... consultarPrazo ..."`

## Objetivo

Validar o assistente com três cenários regionais obrigatórios: um estado do Sudeste, um do Nordeste e um do Norte. A avaliação considera somente comportamento observável e o contrato de saída definido. Não se registra nem se solicita cadeia de pensamento privada.

## Cenários executados

| Caso | Entrada | Região esperada | Prazo esperado | Resultado observado | Status |
|---|---|---|---|---|---|
| GPT-01 | SP, frete comum | Sudeste | 5-5 dias corridos | SP, Sudeste, comum, 5-5 dias corridos | passou |
| GPT-02 | BA, frete expresso | Nordeste | 5-5 dias corridos | BA, Nordeste, expresso, 5-5 dias corridos | passou |
| GPT-03 | AM, frete comum | Norte | 5-5 dias corridos | AM, Norte, comum, 5-5 dias corridos | passou |

## Resultados completos

### GPT-01 — São Paulo

**Entrada:** UF `SP`; frete `comum`.

**Saída observada:**

```json
{
  "estado": "SP",
  "regiao": "Sudeste",
  "frete": "comum",
  "prazoMinimo": 5,
  "prazoMaximo": 5,
  "unidade": "dias corridos",
  "observacoes": "Prazo estimado oficial; sujeito à confirmação operacional e aprovação humana."
}
```

### GPT-02 — Bahia

**Entrada:** UF `BA`; frete `expresso`.

**Saída observada:**

```json
{
  "estado": "BA",
  "regiao": "Nordeste",
  "frete": "expresso",
  "prazoMinimo": 5,
  "prazoMaximo": 5,
  "unidade": "dias corridos",
  "observacoes": "Prazo estimado oficial; sujeito à confirmação operacional e aprovação humana."
}
```

### GPT-03 — Amazonas

**Entrada:** UF `AM`; frete `comum`.

**Saída observada:**

```json
{
  "estado": "AM",
  "regiao": "Norte",
  "frete": "comum",
  "prazoMinimo": 5,
  "prazoMaximo": 5,
  "unidade": "dias corridos",
  "observacoes": "Prazo estimado oficial; sujeito à confirmação operacional e aprovação humana."
}
```

## Avaliação do contrato de resposta

| Critério | Evidência | Avaliação |
|---|---|---|
| Normaliza e reconhece a UF | SP, BA e AM retornaram em maiúsculas | passou |
| Identifica a região | Sudeste, Nordeste e Norte retornados corretamente | passou |
| Valida o frete | comum e expresso aceitos conforme contrato | passou |
| Consulta somente a regra aprovada | todos retornaram 5-5 dias corridos | passou |
| Informa a unidade | `dias corridos` presente nos três resultados | passou |
| Inclui ressalva operacional | observação informa estimativa e confirmação humana | passou |
| Mantém formato estruturado | saída contém Estado, Região, Frete, prazos e observações | passou |
| Evita promessa não autorizada | nenhum resultado inventou prazo regional diferente | passou |

## Avaliação da cadeia de operações

A especificação define uma sequência observável: ler e normalizar a UF, identificar a região, validar o frete, consultar a regra oficial e formatar a resposta. Os resultados comprovam os efeitos dessa sequência nos três casos.

Não é apropriado avaliar ou armazenar a cadeia de pensamento privada do modelo. O critério usado aqui é a conformidade verificável da entrada, da saída, das regras aplicadas e dos avisos exibidos ao usuário.

## Conclusão

Os três cenários obrigatórios foram executados com sucesso no motor local. O assistente seguiu o formato definido e retornou as regiões corretas, a regra oficial de 5 a 5 dias corridos, a unidade de medida e a necessidade de confirmação operacional.

**Limite de evidência:** este registro comprova o motor local e o contrato preparado para o GPT. Não comprova uma execução dentro de uma conta externa do GPT Builder, pois essa publicação depende de acesso autenticado à plataforma.
