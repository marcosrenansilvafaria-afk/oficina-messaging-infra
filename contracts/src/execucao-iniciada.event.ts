import { SagaEventEnvelope } from "./envelope";

/**
 * Publicado pelo Execution Service quando o reparo entra em producao (apos
 * consumir PagamentoAprovadoEvent). Consumido pelo OS Service (status ->
 * EM_EXECUCAO).
 */
export interface ExecucaoIniciadaPayload {
  ordemServicoId: string;
  execucaoId: string;
  iniciadaEm: string;
}

export type ExecucaoIniciadaEvent = SagaEventEnvelope<ExecucaoIniciadaPayload>;

export const EXECUCAO_INICIADA_EVENT_TYPE = "ExecucaoIniciadaEvent" as const;
