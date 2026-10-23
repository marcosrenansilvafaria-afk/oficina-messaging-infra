import { SagaEventEnvelope } from "./envelope";

/**
 * Publicado pelo Execution Service quando o reparo e concluido com sucesso.
 * Consumido pelo OS Service (status -> FINALIZADA). Fecha o fluxo feliz do
 * Saga.
 */
export interface ExecucaoConcluidaPayload {
  ordemServicoId: string;
  execucaoId: string;
  concluidaEm: string;
}

export type ExecucaoConcluidaEvent = SagaEventEnvelope<ExecucaoConcluidaPayload>;

export const EXECUCAO_CONCLUIDA_EVENT_TYPE = "ExecucaoConcluidaEvent" as const;
