# Contratos de evento do Saga

Interfaces TypeScript (`src/`) e JSON Schemas draft-07 (`schemas/`) para os 7
eventos trocados entre OS Service, Billing Service e Execution Service via o
tópico SNS FIFO `oficina-saga-events.fifo`. Ver
[`SAGA_PATTERN_SPEC.md`](../../oficina-app/docs/SAGA_PATTERN_SPEC.md) (no
repositório `oficina-app`) para o desenho completo do fluxo feliz e dos
cenários de compensação.

## Eventos

| Evento | Publicado por | Consumido por |
|---|---|---|
| `OSCriadaEvent` | OS Service | — (informativo/auditoria) |
| `OrcamentoGeradoEvent` | OS Service | Billing Service |
| `PagamentoAprovadoEvent` | Billing Service | OS Service, Execution Service |
| `PagamentoRecusadoEvent` | Billing Service | — (ver `CompensarOSEvent`) |
| `ExecucaoIniciadaEvent` | Execution Service | OS Service |
| `ExecucaoConcluidaEvent` | Execution Service | OS Service |
| `CompensarOSEvent` | Billing Service ou Execution Service | OS Service, Billing Service, Execution Service (conforme `origemFalha`) |

## Versionamento

Cada evento carrega `eventVersion` (ex: `"1.0"`) no envelope. Mudanças
aditivas (novo campo opcional) incrementam a versão minor; mudanças que
quebram compatibilidade (campo removido/renomeado, tipo alterado) exigem uma
nova versão major e os consumidores devem suportar ambas durante a transição.

## Como os futuros repositórios de serviço consomem isto

Esta sprint só cria os contratos — os 3 repositórios de serviço
(`oficina-os-service`, `oficina-billing-service`, `oficina-execution-service`)
ainda não existem. Quando forem criados, a forma mais simples (escopo
acadêmico, sem publicar um pacote npm privado) é copiar os arquivos de
`src/` e `schemas/` para dentro de cada repositório de serviço, ou referenciar
este repositório como submódulo git — ambas as opções evitam infraestrutura
extra de registry de pacotes.

## Validação em runtime

Os arquivos em `schemas/` são JSON Schema draft-07 puro, consumíveis por
qualquer linguagem/lib (`ajv` em Node, `jsonschema` em Python, etc.) — não
dependem do NestJS nem de nenhum framework específico, já que os 3 serviços
futuros podem não ser todos implementados na mesma stack.
