import { SagaEventEnvelope } from "./envelope";

export type OrigemFalhaCompensacao = "PAGAMENTO" | "EXECUCAO";

/**
 * Evento de compensacao GENERICO do Saga. Publicado por qualquer servico que
 * detecte uma falha downstream:
 * - Billing Service, junto com PagamentoRecusadoEvent (origemFalha = "PAGAMENTO").
 * - Execution Service, no lugar de ExecucaoConcluidaEvent se o reparo falhar
 *   (origemFalha = "EXECUCAO").
 *
 * Consumido por:
 * - OS Service: sempre, para reverter o status da OS.
 * - Billing Service: quando origemFalha = "EXECUCAO", para iniciar o
 *   reembolso no Mercado Pago (o pagamento ja tinha sido aprovado).
 * - Execution Service: quando origemFalha = "PAGAMENTO" e por algum motivo
 *   ja havia reservado recursos de producao, para liberar essa reserva.
 */
export interface CompensarOSPayload {
  ordemServicoId: string;
  origemFalha: OrigemFalhaCompensacao;
  motivo: string;
  compensarEm: string;
}

export type CompensarOSEvent = SagaEventEnvelope<CompensarOSPayload>;

export const COMPENSAR_OS_EVENT_TYPE = "CompensarOSEvent" as const;
