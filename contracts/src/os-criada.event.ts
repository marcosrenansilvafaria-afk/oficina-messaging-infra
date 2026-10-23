import { SagaEventEnvelope } from "./envelope";

/** Publicado pelo OS Service quando uma nova Ordem de Servico e criada. */
export interface OSCriadaPayload {
  ordemServicoId: string;
  clienteId: string;
  veiculoId: string;
  criadaEm: string;
}

export type OSCriadaEvent = SagaEventEnvelope<OSCriadaPayload>;

export const OS_CRIADA_EVENT_TYPE = "OSCriadaEvent" as const;
