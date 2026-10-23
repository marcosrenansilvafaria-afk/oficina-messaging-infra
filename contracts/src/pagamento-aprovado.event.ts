import { SagaEventEnvelope } from "./envelope";

/**
 * Publicado pelo Billing Service quando o Mercado Pago confirma o pagamento
 * (via webhook). Consumido pelo OS Service (status -> APROVADA) e pelo
 * Execution Service (inicia o reparo).
 */
export interface PagamentoAprovadoPayload {
  ordemServicoId: string;
  pagamentoId: string;
  mercadoPagoPaymentId: string;
  valorPago: number;
  aprovadoEm: string;
}

export type PagamentoAprovadoEvent = SagaEventEnvelope<PagamentoAprovadoPayload>;

export const PAGAMENTO_APROVADO_EVENT_TYPE = "PagamentoAprovadoEvent" as const;
