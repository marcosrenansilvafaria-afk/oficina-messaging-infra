import { SagaEventEnvelope } from "./envelope";

export type TipoItemOrcamento = "SERVICO" | "PECA";

export interface ItemOrcamento {
  descricao: string;
  tipo: TipoItemOrcamento;
  preco: number;
  quantidade: number;
}

/**
 * Publicado pelo OS Service apos o diagnostico, quando o orcamento (valor
 * total + itens) e calculado. Consumido pelo Billing Service para abrir a
 * cobranca no Mercado Pago.
 */
export interface OrcamentoGeradoPayload {
  ordemServicoId: string;
  valorTotal: number;
  itens: ItemOrcamento[];
  geradoEm: string;
}

export type OrcamentoGeradoEvent = SagaEventEnvelope<OrcamentoGeradoPayload>;

export const ORCAMENTO_GERADO_EVENT_TYPE = "OrcamentoGeradoEvent" as const;
