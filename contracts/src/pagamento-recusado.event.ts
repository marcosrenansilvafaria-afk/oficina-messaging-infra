import { SagaEventEnvelope } from "./envelope";

/**
 * Publicado pelo Billing Service quando o Mercado Pago recusa/expira o
 * pagamento. E o trigger de compensacao do Saga - o Billing Service deve
 * publicar tambem um CompensarOSEvent (origemFalha = "PAGAMENTO") junto com
 * este evento.
 */
export interface PagamentoRecusadoPayload {
  ordemServicoId: string;
  pagamentoId: string;
  mercadoPagoPaymentId: string;
  motivo: string;
  recusadoEm: string;
}

export type PagamentoRecusadoEvent = SagaEventEnvelope<PagamentoRecusadoPayload>;

export const PAGAMENTO_RECUSADO_EVENT_TYPE = "PagamentoRecusadoEvent" as const;
